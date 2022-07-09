with Ada.Unchecked_Deallocation;

package body Regions.Shared_Hashed_Maps is

   --  pragma Compile_Time_Warning
   --    (Hash_Type'Modulus = 2 ** Hash_Type'Size, "Unexpected hash type");

   procedure Free is new Ada.Unchecked_Deallocation (Node, Node_Access);

   function Pop_Count (Value : Unsigned_64; Bit : Bit_Index) return Bit_Count;
   --  Count 1 bits in Value (0 .. Bit)

   procedure Reference (Self : not null Node_Access) with Inline;
   procedure Unreference (Self : in out Node_Access) with Inline;

   function Descend (Path : Node_Access_Array) return Cursor;
   --  Find left leaf child of the last item in Path and return
   --  corresponding Cursor.

   function To_Index
     (Node  : Node_Access;
      Hash  : Hash_Type;
      Depth : Bit_Index) return Bit_Count;
   --   Find an index in Node.Child for given Hash and Depth in bits

   ---------
   -- "=" --
   ---------

   function "=" (Left : Map; Right : Map) return Boolean is
      function Compare (Left, Right : Node_Access) return Boolean;
      --  Compare Left and Right subtries

      function Compare (Left, Right : Node_Access) return Boolean is
      begin
         if Left = Right then
            return True;
         elsif Left = null xor Right = null then
            return False;
         elsif Left.Length /= Right.Length then
            return False;
         elsif Left.Length = 0 then
            return Left.Item = Right.Item;
         else
            return (for all J in 1 .. Left.Length =>
                      Compare (Left.Child (J), Right.Child (J)));
         end if;
      end Compare;
   begin
      return Compare (Left.Root, Right.Root);
   end "=";

   ------------
   -- Adjust --
   ------------

   overriding procedure Adjust (Self : in out Map) is
   begin
      if Self.Root /= null then
         Reference (Self.Root);
      end if;
   end Adjust;

   -----------------------
   -- Constant_Indexing --
   -----------------------

   function Constant_Indexing (Self : Map; Position : Cursor)
     return Constant_Reference is
   begin
      return (Element => Position.Path (Position.Length).Item'Access);
   end Constant_Indexing;

   --------------
   -- Contains --
   --------------

   function Contains (Self : Map; Key : Key_Type) return Boolean is
      Key_Hash : constant Hash_Type := Hash (Key);
      Mask     : constant Hash_Type := Hash_Type (Branches - 1);
      Next     : Node_Access := Self.Root;
      Rest     : Hash_Type := Key_Hash;
   begin
      while Next /= null loop
         if Next.Length > 0 then
            declare
               Bit : constant Bit_Index := Bit_Index (Rest and Mask);
            begin
               if (Next.Mask and 2 ** Bit) = 0 then
                  return False;
               else
                  Next := Next.Child (Pop_Count (Next.Mask, Bit));
                  Rest := Rest / Branches;
               end if;
            end;
         elsif Next.Hash = Key_Hash then
            return Equivalent_Keys (Next.Key, Key);
            --  FIXME: "Hash collision"
         else
            return False;
         end if;
      end loop;

      return False;
   end Contains;

   -------------
   -- Descend --
   -------------

   function Descend (Path : Node_Access_Array) return Cursor is
      Node : constant not null Node_Access := Path (Path'Last);
   begin
      if Node.Length = 0 then
         return (Length => Path'Length, Path => Path);
      else
         return Descend (Path & Node.Child (1));
      end if;
   end Descend;

   -------------
   -- Element --
   -------------

   function Element (Self : Map; Key : Key_Type) return Element_Type is
      Key_Hash : constant Hash_Type := Hash (Key);
      Mask     : constant Hash_Type := Hash_Type (Branches - 1);
      Next     : Node_Access := Self.Root;
      Rest     : Hash_Type := Key_Hash;
   begin
      while Next /= null loop
         if Next.Length > 0 then
            declare
               Bit : constant Bit_Index := Bit_Index (Rest and Mask);
            begin
               if (Next.Mask and 2 ** Bit) = 0 then
                  raise Constraint_Error;
               else
                  Next := Next.Child (Pop_Count (Next.Mask, Bit));
                  Rest := Rest / Branches;
               end if;
            end;
         elsif Next.Hash = Key_Hash
           and then Equivalent_Keys (Next.Key, Key)
         then
            return Next.Item;
            --  FIXME: "Hash collision"
         else
            raise Constraint_Error;
         end if;
      end loop;

      return raise Constraint_Error;
   end Element;

   ---------------
   -- Empty_Map --
   ---------------

   function Empty_Map (Active : not null access Change_Count) return Map is
   begin
      return (Ada.Finalization.Controlled with Active, Root => null);
   end Empty_Map;

   --------------
   -- Finalize --
   --------------

   overriding procedure Finalize (Self : in out Map) is
   begin
      Unreference (Self.Root);
   end Finalize;

   -----------
   -- First --
   -----------

   overriding function First (Self : Forward_Iterator) return Cursor is
   begin
      return Self.First;
   end First;

   -----------------
   -- Has_Element --
   -----------------

   function Has_Element (Self : Cursor) return Boolean is
   begin
      return Self.Length /= 0;
   end Has_Element;

   ------------
   -- Insert --
   ------------

   procedure Insert
     (Self : in out Map;
      Key  : Key_Type;
      Item : Element_Type)
   is
      Mask     : constant Hash_Type := Hash_Type (Branches - 1);
      Key_Hash : constant Hash_Type := Hash (Key);

      function Create_Leaf return Node_Access;

      procedure Descent
        (Parent : in out Node_Access;
         Shift  : Bit_Count);

      function Create_Leaf return Node_Access is
         Child : constant Node_Access := new Node'
           (Length  => 0,
            Version => Self.Active.all,
            Counter => 1,
            Hash    => Key_Hash,
            Key     => Key,
            Item    => Item);
      begin
         return Child;
      end Create_Leaf;

      procedure Descent
        (Parent : in out Node_Access;
         Shift  : Bit_Count)
      is
         Suffix : constant Hash_Type := Key_Hash / 2 ** Shift;
         Slit   : constant Hash_Type := Mask * 2 ** Shift;
         Bit    : constant Bit_Index := Bit_Index (Suffix and Mask);
      begin
         if Parent = null then
            Parent := Create_Leaf;
         elsif Parent.Length > 0 then
            declare
               Index : constant Bit_Count := Pop_Count (Parent.Mask, Bit);
            begin
               if (Parent.Mask and 2 ** Bit) = 0 then
                  declare
                     Joint : constant Node_Access := new Node
                       (Length => Parent.Length + 1);
                  begin
                     for Child of Parent.Child loop
                        Reference (Child);
                     end loop;

                     Joint.Version := Self.Active.all;
                     Joint.Counter := 1;
                     Joint.Mask := Parent.Mask or 2 ** Bit;
                     Joint.Child (1 .. Index) := Parent.Child (1 .. Index);
                     Joint.Child (Index + 1) := Create_Leaf;
                     Joint.Child (Index + 2 .. Parent.Length + 1) :=
                       Parent.Child (Index + 1 .. Parent.Length);
                     Unreference (Parent);
                     Parent := Joint;
                  end;
               else
                  if Parent.Version /= Self.Active.all then
                     declare
                        Joint : constant Node_Access :=
                           new Node'(Parent.all);
                     begin
                        Joint.Version := Self.Active.all;
                        Joint.Counter := 1;

                        for Child of Joint.Child loop
                           Reference (Child);
                        end loop;

                        Unreference (Parent);
                        Parent := Joint;
                     end;
                  end if;

                  Descent (Parent.Child (Index), Shift + Slit_Bits);
               end if;
            end;
         elsif Parent.Hash = Key_Hash then
            if not Equivalent_Keys (Parent.Key, Key) then
               raise Program_Error with "Hash collision";
            elsif Parent.Version = Self.Active.all then
               Parent.Item := Item;
            else
               Unreference (Parent);
               Parent := Create_Leaf;
            end if;
         elsif (Parent.Hash and Slit) = (Key_Hash and Slit) then
            declare
               Joint : constant Node_Access := new Node (Length => 1);
            begin
               Joint.Version := Self.Active.all;
               Joint.Counter := 1;
               Joint.Mask := 2 ** Bit;
               Joint.Child (1) := Parent;
               Parent := Joint;
               Descent (Parent.Child (1), Shift + Slit_Bits);
            end;
         else
            declare
               Joint : constant Node_Access := new Node (Length => 2);
               Bit_2 : constant Bit_Index :=
                 Bit_Index ((Parent.Hash / 2 ** Shift) and Mask);
            begin
               Joint.Version := Self.Active.all;
               Joint.Counter := 1;
               Joint.Mask := 2 ** Bit or 2 ** Bit_2;
               if Bit < Bit_2 then
                  Joint.Child (1) := Create_Leaf;
                  Joint.Child (2) := Parent;
               else
                  Joint.Child (1) := Parent;
                  Joint.Child (2) := Create_Leaf;
               end if;

               Parent := Joint;
            end;
         end if;
      end Descent;

   begin
      if Self.Root /= null and then
        (Self.Root.Counter > 1 and Self.Root.Version = Self.Active.all)
      then
         Self.Active.all := Self.Active.all + 1;
      end if;

      Descent (Self.Root, 0);
   end Insert;

   ---------------
   -- Is_Shared --
   ---------------

   function Is_Shared (Self : Map; Key : Key_Type) return Boolean is
      Key_Hash : constant Hash_Type := Hash (Key);
      Mask     : constant Hash_Type := Hash_Type (Branches - 1);
      Next     : Node_Access := Self.Root;
      Rest     : Hash_Type := Key_Hash;
   begin
      if Self.Root.Counter > 1 then
         return True;
      end if;

      while Next /= null loop
         if Next.Version /= Self.Active.all then
            return True;
         elsif Next.Length > 0 then
            declare
               Bit : constant Bit_Index := Bit_Index (Rest and Mask);
            begin
               if (Next.Mask and 2 ** Bit) = 0 then
                  return True;
               else
                  Next := Next.Child (Pop_Count (Next.Mask, Bit));
                  Rest := Rest / Branches;
               end if;
            end;
         else
            return False;
         end if;
      end loop;

      return True;
   end Is_Shared;

   -------------
   -- Iterate --
   -------------

   function Iterate (Self : Map'Class) return Forward_Iterator is
   begin
      if Self.Root = null then
         return (First => (Length => 0, Path => <>));
      else
         return (First => Descend ((1 => Self.Root)));
      end if;
   end Iterate;

   ---------
   -- Key --
   ---------

   function Key (Self : Cursor) return Key_Type is
   begin
      return Self.Path (Self.Length).Key;
   end Key;

   ----------
   -- Next --
   ----------

   overriding function Next
     (Self     : Forward_Iterator;
      Position : Cursor) return Cursor
   is
      pragma Unreferenced (Self);

      function Find_Next
        (Hash  : Hash_Type;
         Depth : Tree_Depth) return Cursor;

      function Find_Next
        (Hash  : Hash_Type;
         Depth : Tree_Depth) return Cursor
      is
         Node   : constant not null Node_Access := Position.Path (Depth);
         Index  : constant Bit_Count :=
           To_Index (Node, Hash, (Depth - 1) * Slit_Bits);
      begin
         if Index < Node.Length then
            return Descend
              (Position.Path (1 .. Depth) & Node.Child (Index + 1));
         elsif Depth = 1 then
            return (Length => 0, Path => <>);
         else
            return Find_Next (Hash, Depth - 1);
         end if;
      end Find_Next;

   begin
      if Position.Length <= 1 then
         return (Length => 0, Path => <>);
      end if;

      return Find_Next
         (Hash  => Position.Path (Position.Length).Hash,
          Depth => Position.Length - 1);
   end Next;

   ---------------
   -- Pop_Count --
   ---------------

   function Pop_Count
     (Value : Unsigned_64;
      Bit   : Bit_Index) return Bit_Count
   is
      Temp   : Unsigned_64 := Value;
      Result : Bit_Count := 0;
   begin
      for J in 0 .. Bit loop
         if (Temp and 1) /= 0 then
            Result := Result + 1;
         end if;

         Temp := Temp / 2;
      end loop;

      return Result;
   end Pop_Count;

   ---------------
   -- Reference --
   ---------------

   procedure Reference (Self : not null Node_Access) is
   begin
      Self.Counter := Self.Counter + 1;
   end Reference;

   ----------------
   -- To_Element --
   ----------------

   function To_Element (Self : Cursor) return Element_Type is
   begin
      return Self.Path (Self.Length).Item;
   end To_Element;

   --------------
   -- To_Index --
   --------------

   function To_Index
     (Node  : Node_Access;
      Hash  : Hash_Type;
      Depth : Bit_Index) return Bit_Count
   is
      Mask   : constant Hash_Type := Hash_Type (Branches - 1);
      Suffix : constant Hash_Type := Hash / 2 ** Depth;
      Bit    : constant Bit_Index := Bit_Index (Suffix and Mask);
      Index  : constant Bit_Count := Pop_Count (Node.Mask, Bit);
   begin
      return Index;
   end To_Index;

   -----------------
   -- Unreference --
   -----------------

   procedure Unreference (Self : in out Node_Access) is
   begin
      if Self /= null then
         Self.Counter := Self.Counter - 1;

         if Self.Counter = 0 then
            if Self.Length > 0 then
               for Child of Self.Child loop
                  Unreference (Child);
               end loop;
            else
               Destroy (Self.Item);
            end if;

            Free (Self);
         else
            Self := null;
         end if;
      end if;
   end Unreference;

   -----------------------
   -- Variable_Indexing --
   -----------------------

   function Variable_Indexing
     (Self : in out Map; Position : Cursor) return Variable_Reference
   is
      Hash    : constant Hash_Type := Position.Path (Position.Length).Hash;
      Changed : Boolean := False;
      Copy    : Node_Access_Array (Position.Path'Range);
      Next    : Node_Access;
   begin
      if Self.Root.Counter > 1 and Self.Root.Version = Self.Active.all then
         Self.Active.all := Self.Active.all + 1;
      end if;

      for J in reverse Position.Path'Range loop
         Next := Position.Path (J);

         if Changed
           or Next.Counter > 1
           or Next.Version /= Self.Active.all
         then
            Changed := True;
            Next := new Node'(Next.all);
            Next.Counter := 1;
            Next.Version := Self.Active.all;

            if Next.Length > 0 then
               Next.Child (To_Index (Next, Hash, (J - 1) * Slit_Bits)) :=
                 Copy (J + 1);
            end if;
         end if;

         Copy (J) := Next;
      end loop;

      Self.Root := Copy (1);
      return (Element => Copy (Position.Length).Item'Access);
   end Variable_Indexing;

end Regions.Shared_Hashed_Maps;
