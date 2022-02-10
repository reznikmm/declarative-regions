package body Regions.Contexts is

   procedure New_Profile
     (Self   : in out Context'Class;
      Key    : Profile_Key;
      Result : out Profile_Id);

   ----------------------
   -- Append_Parameter --
   ----------------------

   procedure Append_Parameter
     (Self      : in out Context;
      Origin    : Profile_Id;
      Type_Name : Selected_Entity_Name;
      Result    : out Profile_Id)
   is
      Key : constant Profile_Key := (Parameter_Data, Origin, Type_Name);
   begin
      Self.New_Profile (Key, Result);
   end Append_Parameter;

   ----------------------
   -- Append_Parameter --
   ----------------------

   procedure Append_Parameter
     (Self       : in out Context;
      Origin     : Profile_Id;
      Subprogram : Profile_Id;
      Result     : out Profile_Id)
   is
      Key : constant Profile_Key := (Parameter_Code, Origin, Subprogram);
   begin
      Self.New_Profile (Key, Result);
   end Append_Parameter;

   ----------------------------
   -- Empty_Function_Profile --
   ----------------------------

   procedure Empty_Function_Profile
     (Self        : in out Context;
      Return_Type : Selected_Entity_Name;
      Result      : out Profile_Id)
   is
      Key : constant Profile_Key := (Root_Data, Return_Type);
   begin
      Self.New_Profile (Key, Result);
   end Empty_Function_Profile;

   ----------------------------
   -- Empty_Function_Profile --
   ----------------------------

   procedure Empty_Function_Profile
     (Self           : in out Context;
      Return_Profile : Profile_Id;
      Result         : out Profile_Id)
   is
      Key : constant Profile_Key := (Root_Code, Return_Profile);
   begin
      Self.New_Profile (Key, Result);
   end Empty_Function_Profile;

   -----------------------------
   -- Empty_Procedure_Profile --
   -----------------------------

   function Empty_Procedure_Profile (Self : Context) return Profile_Id is
   begin
      return 1;
   end Empty_Procedure_Profile;

   ----------
   -- Hash --
   ----------

   function Hash (Value : Profile_Key) return Ada.Containers.Hash_Type is
      use type Ada.Containers.Hash_Type;

      Prime  : constant := 115_249;
      Result : Ada.Containers.Hash_Type;
   begin
      case Value.Kind is
         when Root_Data =>
            Result := 0 + 3 * Ada.Containers.Hash_Type'Mod (Value.Root_Data);
         when Root_Code =>
            Result := 1 + 3 * Ada.Containers.Hash_Type'Mod (Value.Root_Code);
         when Parameter_Data | Parameter_Code =>

            case Value.Kind is
               when Root_Data | Root_Code =>
                  null;
               when Parameter_Data =>
                  Result := 0 +
                    2 * Ada.Containers.Hash_Type'Mod (Value.Parameter_Data);
               when Parameter_Code =>
                  Result := 1 +
                    2 * Ada.Containers.Hash_Type'Mod (Value.Parameter_Code);
            end case;

            Result := 2 + 3 *
              (Ada.Containers.Hash_Type'Mod (Value.Parent) * Prime + Result);
      end case;

      return Result;
   end Hash;

   ----------
   -- Hash --
   ----------

   function Hash (Value : Entity_Name_Key) return Ada.Containers.Hash_Type is
      use type Ada.Containers.Hash_Type;

      Prime : constant := 109_297;
   begin
      return Ada.Containers.Hash_Type'Mod (Value.Symbol) * Prime +
        Ada.Containers.Hash_Type'Mod (Value.Profile);
   end Hash;

   ----------
   -- Hash --
   ----------

   function Hash
     (Value : Selected_Entity_Name_Key) return Ada.Containers.Hash_Type
   is
      use type Ada.Containers.Hash_Type;

      Prime : constant := 101_111;
   begin
      return Ada.Containers.Hash_Type'Mod (Value.Prefix) * Prime +
        Ada.Containers.Hash_Type'Mod (Value.Selector);
   end Hash;

   ---------------------
   -- New_Entity_Name --
   ---------------------

   procedure New_Entity_Name
     (Self   : in out Context;
      Symbol : Regions.Symbols.Symbol;
      Result : out Entity_Name) is
   begin
      Self.New_Entity_Name (Symbol, No_Profile, Result);
   end New_Entity_Name;

   ---------------------
   -- New_Entity_Name --
   ---------------------

   procedure New_Entity_Name
     (Self    : in out Context;
      Symbol  : Regions.Symbols.Symbol;
      Profile : Profile_Id;
      Result  : out Entity_Name)
   is
      Key    : constant Entity_Name_Key := (Symbol, Profile);
      Cursor : constant Entity_Name_Maps.Cursor := Self.Names.Find (Key);
   begin
      if Entity_Name_Maps.Has_Element (Cursor) then
         Result := Entity_Name_Maps.Element (Cursor);
      else
         Self.Last_Name := Self.Last_Name + 1;
         Self.Names.Insert (Key, Self.Last_Name);
         Result := Self.Last_Name;
      end if;
   end New_Entity_Name;

   -----------------
   -- New_Profile --
   -----------------

   procedure New_Profile
     (Self   : in out Context'Class;
      Key    : Profile_Key;
      Result : out Profile_Id)
   is
      Cursor : constant Profile_Maps.Cursor := Self.Profiles.Find (Key);
   begin
      if Profile_Maps.Has_Element (Cursor) then
         Result := Profile_Maps.Element (Cursor);
      else
         Self.Last_Profile := Self.Last_Profile + 1;
         Self.Profiles.Insert (Key, Self.Last_Profile);
         Result := Self.Last_Profile;
      end if;
   end New_Profile;

   -----------------------
   -- New_Selected_Name --
   -----------------------

   procedure New_Selected_Name
     (Self     : in out Context;
      Prefix   : Selected_Entity_Name;
      Selector : Entity_Name;
      Result   : out Selected_Entity_Name)
   is
      Key    : constant Selected_Entity_Name_Key := (Prefix, Selector);
      Cursor : constant Selected_Entity_Name_Maps.Cursor :=
        Self.Selected.Find (Key);
   begin
      if Selected_Entity_Name_Maps.Has_Element (Cursor) then
         Result := Selected_Entity_Name_Maps.Element (Cursor);
      else
         Self.Last_Selected := Self.Last_Selected + 1;
         Self.Selected.Insert (Key, Self.Last_Selected);
         Result := Self.Last_Selected;
      end if;
   end New_Selected_Name;

   ---------------
   -- Root_Name --
   ---------------

   function Root_Name (Self : Context) return Selected_Entity_Name is
   begin
      return 0;
   end Root_Name;

end Regions.Contexts;
