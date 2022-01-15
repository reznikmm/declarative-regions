with Ada.Unchecked_Deallocation;

package body Regions.Shared_Lists is

   procedure Reference (Self : not null List_Node_Access) with Inline;
   procedure Unreference (Self : in out List_Node_Access) with Inline;

   procedure Free is new Ada.Unchecked_Deallocation
     (List_Node, List_Node_Access);

   ---------
   -- "=" --
   ---------

   function "=" (Left, Right : List) return Boolean is
      function Compare (L, R : List_Node_Access) return Boolean;
      --  Compare item in node chains

      function Compare (L, R : List_Node_Access) return Boolean is
      begin
         if L = R then
            return True;
         elsif L.Next = null then
            return L.Data = R.Data;
         elsif L.Data = R.Data then
            return Compare (L.Next, R.Next);
         else
            return False;
         end if;
      end Compare;
   begin
      return Left.Length = Right.Length
        and then Compare (Left.Head, Right.Head);
   end "=";

   ------------
   -- Adjust --
   ------------

   overriding procedure Adjust (Self : in out List) is
   begin
      if Self.Head /= null then
         Reference (Self.Head);
      end if;
   end Adjust;

   -----------------------
   -- Constant_Indexing --
   -----------------------

   function Constant_Indexing
     (Self     : List;
      Position : Cursor) return Element_Type
   is
      pragma Unreferenced (Self);
   begin
      return Position.Item.Data;
   end Constant_Indexing;

   ----------------
   -- Empty_List --
   ----------------

   function Empty_List return List is
   begin
      return (Ada.Finalization.Controlled with Head => null, Length => 0);
   end Empty_List;

   --------------
   -- Finalize --
   --------------

   overriding procedure Finalize (Self : in out List) is
   begin
      Unreference (Self.Head);
      Self.Length := 0;
   end Finalize;

   -----------
   -- First --
   -----------

   overriding function First (Self : Forward_Iterator) return Cursor is
   begin
      return Self.First;
   end First;

   -------------------
   -- First_Element --
   -------------------

   function First_Element (Self : List) return Element_Type is
   begin
      return Self.Head.Data;
   end First_Element;

   -----------------
   -- Has_Element --
   -----------------

   function Has_Element (Self : Cursor) return Boolean is
   begin
      return Self.Item.Next /= null;
   end Has_Element;

   --------------
   -- Is_Empty --
   --------------

   function Is_Empty (Self : List) return Boolean is
   begin
      return Self.Head = null;
   end Is_Empty;

   -------------
   -- Iterate --
   -------------

   function Iterate (Self : List'Class) return Forward_Iterator is
   begin
      return (First => (Item => Self.Head));
   end Iterate;

   ------------
   -- Length --
   ------------

   function Length (Self : List) return Natural is
   begin
      return Self.Length;
   end Length;

   ----------
   -- Next --
   ----------

   overriding function Next
     (Self     : Forward_Iterator;
      Position : Cursor) return Cursor
   is
      pragma Unreferenced (Self);
   begin
      if Position.Item = null then
         return Position;
      else
         return (Item => Position.Item.Next);
      end if;
   end Next;


   -------------
   -- Prepend --
   -------------

   procedure Prepend (Self : in out List; Item : Element_Type) is
   begin
      Self.Head := new List_Node'(Self.Head, 1, Item);
      Self.Length := Self.Length + 1;
   end Prepend;

   ---------------
   -- Reference --
   ---------------

   procedure Reference (Self : not null List_Node_Access) is
   begin
      Self.Counter := Self.Counter + 1;
   end Reference;

   -----------------
   -- Unreference --
   -----------------

   procedure Unreference (Self : in out List_Node_Access) is
   begin
      if Self /= null then
         Self.Counter := Self.Counter - 1;

         if Self.Counter = 0 then
            Destroy (Self.Data);
            Unreference (Self.Next);
            Free (Self);
         else
            Self := null;
         end if;
      end if;
   end Unreference;

end Regions.Shared_Lists;
