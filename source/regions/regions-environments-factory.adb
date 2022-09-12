--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Regions.Contexts;
with Regions.Entities.Array_Types;
with Regions.Entities.Enumeration_Literals;
with Regions.Entities.Enumeration_Types;
with Regions.Entities.Exceptions;
with Regions.Entities.Fixed_Point_Types;
with Regions.Entities.Floating_Point_Types;
with Regions.Entities.Packages;
with Regions.Entities.Roots;
with Regions.Entities.Signed_Integer_Types;
with Regions.Entities.Subtypes;

package body Regions.Environments.Factory is

   -----------------------
   -- Create_Array_Type --
   -----------------------

   procedure Create_Array_Type
     (Self    : in out Environment;
      Symbol  : Regions.Symbol;
      Indexes : Regions.Entity_Access_Array)
   is
      Parent_Id : constant Regions.Contexts.Selected_Entity_Name :=
        Entity_Name_Lists.First_Element (Self.Nested);

      Type_Name : constant Regions.Contexts.Selected_Entity_Name :=
        Self.Context.New_Selected_Name
          (Parent_Id, Self.Context.New_Entity_Name (Symbol));

      Index_Names : Contexts.Selected_Entity_Name_Array (Indexes'Range);
   begin
      for J in Indexes'Range loop
         Index_Names (J) := Indexes (J).Selected_Name;
      end loop;

      declare
         Entity : constant Entity_Access := new Regions.Entities.Entity'Class'
           (Regions.Entities.Array_Types.Create
              (Self'Unchecked_Access, Type_Name, Index_Names));

         --  Insert Entity into environment can change Parent :(
         Parent : constant Entity_Access :=
           Get_Entity (Self'Unchecked_Access, Parent_Id);
      begin
         Parent.Region.Insert (Symbol, Type_Name);
         Self.Entity_Map.Insert (Type_Name, Entity);
      end;
   end Create_Array_Type;

   -----------------------------
   -- Create_Enumeration_Type --
   -----------------------------

   procedure Create_Enumeration_Type
     (Self     : in out Environment;
      Symbol   : Regions.Symbol;
      Literals : Regions.Symbol_Array)
   is
      Parent_Id : constant Regions.Contexts.Selected_Entity_Name :=
        Entity_Name_Lists.First_Element (Self.Nested);

      Type_Name : constant Regions.Contexts.Selected_Entity_Name :=
        Self.Context.New_Selected_Name
          (Parent_Id, Self.Context.New_Entity_Name (Symbol));

      Profile : constant Regions.Contexts.Profile_Id :=
        Self.Context.Empty_Function_Profile (Type_Name);

   begin
      declare
         Entity : constant Entity_Access := new Regions.Entities.Entity'Class'
           (Regions.Entities.Enumeration_Types.Create
              (Self'Unchecked_Access, Type_Name));

         --  Insert Entity into environment can change Parent :(
         Parent : constant Entity_Access :=
           Get_Entity (Self'Unchecked_Access, Parent_Id);
      begin
         Parent.Region.Insert (Symbol, Type_Name);
         Self.Entity_Map.Insert (Type_Name, Entity);
      end;

      for S of Literals loop
         declare
            Name : constant Regions.Contexts.Selected_Entity_Name :=
              Self.Context.New_Selected_Name
                (Parent_Id, Self.Context.New_Entity_Name (S, Profile));

            Entity : constant Entity_Access :=
              new Regions.Entities.Entity'Class'
                (Regions.Entities.Enumeration_Literals.Create
                   (Self'Unchecked_Access, Name, Type_Name));

            --  Insert Entity into environment can change Parent :(
            Parent : constant Entity_Access :=
              Get_Entity (Self'Unchecked_Access, Parent_Id);
         begin
            Parent.Region.Insert (S, Name);
            Self.Entity_Map.Insert (Name, Entity);
         end;
      end loop;
   end Create_Enumeration_Type;

   ----------------------
   -- Create_Exception --
   ----------------------

   procedure Create_Exception
     (Self   : in out Environment;
      Symbol : Regions.Symbol)
   is
      Parent_Id : constant Regions.Contexts.Selected_Entity_Name :=
        Entity_Name_Lists.First_Element (Self.Nested);

      Type_Name : constant Regions.Contexts.Selected_Entity_Name :=
        Self.Context.New_Selected_Name
          (Parent_Id, Self.Context.New_Entity_Name (Symbol));

   begin
      declare
         Entity : constant Entity_Access := new Regions.Entities.Entity'Class'
           (Regions.Entities.Exceptions.Create
              (Self'Unchecked_Access, Type_Name));

         --  Insert Entity into environment can change Parent :(
         Parent : constant Entity_Access :=
           Get_Entity (Self'Unchecked_Access, Parent_Id);
      begin
         Parent.Region.Insert (Symbol, Type_Name);
         Self.Entity_Map.Insert (Type_Name, Entity);
      end;
   end Create_Exception;

   -----------------------------
   -- Create_Fixed_Point_Type --
   -----------------------------

   procedure Create_Fixed_Point_Type
     (Self   : in out Environment;
      Symbol : Regions.Symbol)
   is
      Parent_Id : constant Regions.Contexts.Selected_Entity_Name :=
        Entity_Name_Lists.First_Element (Self.Nested);

      Type_Name : constant Regions.Contexts.Selected_Entity_Name :=
        Self.Context.New_Selected_Name
          (Parent_Id, Self.Context.New_Entity_Name (Symbol));

   begin
      declare
         Entity : constant Entity_Access := new Regions.Entities.Entity'Class'
           (Regions.Entities.Fixed_Point_Types.Create
              (Self'Unchecked_Access, Type_Name));

         --  Insert Entity into environment can change Parent :(
         Parent : constant Entity_Access :=
           Get_Entity (Self'Unchecked_Access, Parent_Id);
      begin
         Parent.Region.Insert (Symbol, Type_Name);
         Self.Entity_Map.Insert (Type_Name, Entity);
      end;
   end Create_Fixed_Point_Type;

   --------------------------------
   -- Create_Floating_Point_Type --
   --------------------------------

   procedure Create_Floating_Point_Type
     (Self     : in out Environment;
      Symbol   : Regions.Symbol)
   is
      Parent_Id : constant Regions.Contexts.Selected_Entity_Name :=
        Entity_Name_Lists.First_Element (Self.Nested);

      Type_Name : constant Regions.Contexts.Selected_Entity_Name :=
        Self.Context.New_Selected_Name
          (Parent_Id, Self.Context.New_Entity_Name (Symbol));

   begin
      declare
         Entity : constant Entity_Access := new Regions.Entities.Entity'Class'
           (Regions.Entities.Floating_Point_Types.Create
              (Self'Unchecked_Access, Type_Name));

         --  Insert Entity into environment can change Parent :(
         Parent : constant Entity_Access :=
           Get_Entity (Self'Unchecked_Access, Parent_Id);
      begin
         Parent.Region.Insert (Symbol, Type_Name);
         Self.Entity_Map.Insert (Type_Name, Entity);
      end;
   end Create_Floating_Point_Type;

   --------------------
   -- Create_Package --
   --------------------

   procedure Create_Package
     (Self   : in out Environment;
      Symbol : Regions.Symbol)
   is
      Parent_Id : constant Regions.Contexts.Selected_Entity_Name :=
        Entity_Name_Lists.First_Element (Self.Nested);

      Name : constant Regions.Contexts.Selected_Entity_Name :=
        Self.Context.New_Selected_Name
          (Parent_Id, Self.Context.New_Entity_Name (Symbol));

      Entity : constant Entity_Access :=
        new Regions.Entities.Entity'Class'
          (Regions.Entities.Packages.Create (Self'Unchecked_Access, Name));

   begin
      declare
         --  Insert Entity into environment can change Parent :(
         Parent : constant Entity_Access :=
           Get_Entity (Self'Unchecked_Access, Parent_Id);
      begin
         Parent.Region.Insert (Symbol, Name);
      end;

      Self.Entity_Map.Insert (Name, Entity);
      Self.Nested.Prepend (Name);
   end Create_Package;

   --------------------------------
   -- Create_Signed_Integer_Type --
   --------------------------------

   procedure Create_Signed_Integer_Type
     (Self     : in out Environment;
      Symbol   : Regions.Symbol)
   is
      Parent_Id : constant Regions.Contexts.Selected_Entity_Name :=
        Entity_Name_Lists.First_Element (Self.Nested);

      Type_Name : constant Regions.Contexts.Selected_Entity_Name :=
        Self.Context.New_Selected_Name
          (Parent_Id, Self.Context.New_Entity_Name (Symbol));

   begin
      declare
         Entity : constant Entity_Access := new Regions.Entities.Entity'Class'
           (Regions.Entities.Signed_Integer_Types.Create
              (Self'Unchecked_Access, Type_Name));

         --  Insert Entity into environment can change Parent :(
         Parent : constant Entity_Access :=
           Get_Entity (Self'Unchecked_Access, Parent_Id);
      begin
         Parent.Region.Insert (Symbol, Type_Name);
         Self.Entity_Map.Insert (Type_Name, Entity);
      end;
   end Create_Signed_Integer_Type;

   --------------------
   -- Create_Subtype --
   --------------------

   procedure Create_Subtype
     (Self         : in out Environment;
      Symbol       : Regions.Symbol;
      Subtype_Mark : Regions.Entity_Access)
   is
      Parent_Id : constant Regions.Contexts.Selected_Entity_Name :=
        Entity_Name_Lists.First_Element (Self.Nested);

      Type_Name : constant Regions.Contexts.Selected_Entity_Name :=
        Self.Context.New_Selected_Name
          (Parent_Id, Self.Context.New_Entity_Name (Symbol));

   begin
      declare
         Entity : constant Entity_Access := new Regions.Entities.Entity'Class'
           (Regions.Entities.Subtypes.Create
              (Self'Unchecked_Access, Type_Name, Subtype_Mark.Selected_Name));

         --  Insert Entity into environment can change Parent :(
         Parent : constant Entity_Access :=
           Get_Entity (Self'Unchecked_Access, Parent_Id);
      begin
         Parent.Region.Insert (Symbol, Type_Name);
         Self.Entity_Map.Insert (Type_Name, Entity);
      end;
   end Create_Subtype;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
     (Self     : in out Environment;
      Standard : Symbol)
   is
      Root : constant Entity_Access :=
        new Regions.Entities.Entity'Class'
          (Regions.Entities.Roots.Create (Self'Unchecked_Access, Standard));
   begin
      Self.Entity_Map.Insert (Self.Context.Root_Name, Root);

      Self.Nested.Prepend (Self.Context.Root_Name);
   end Initialize;

   ------------------
   -- Leave_Region --
   ------------------

   procedure Leave_Region (Self : in out Environment) is
   begin
      Self.Nested := Self.Nested.Tail;
   end Leave_Region;

   -------------------
   -- Load_Snapshot --
   -------------------

   procedure Load_Snapshot
     (Self  : in out Environment;
      Value : Snapshot'Class) is
   begin
      Version := Version + 1;
      Self.Entity_Map := Value.Entity_Map;
      Self.Nested := Value.Nested;
   end Load_Snapshot;

   -------------------
   -- Make_Snapshot --
   -------------------

   function Make_Snapshot
     (Self : Environment) return not null Snapshot_Access is
   begin
      return Result : constant not null Snapshot_Access :=
        new Snapshot (Self.Context)
      do
         Version := Version + 1;  --  Freeze Entity_Map update
         Result.Entity_Map := Self.Entity_Map;
         Result.Nested := Self.Nested;
      end return;
   end Make_Snapshot;

   ------------------------
   -- Set_Component_Type --
   ------------------------

   procedure Set_Component_Type
     (Self    : in out Environment;
      Element : Regions.Entity_Access)
   is
      Parent_Id : constant Regions.Contexts.Selected_Entity_Name :=
        Entity_Name_Lists.First_Element (Self.Nested);

      Parent : constant Entity_Access :=
        Get_Entity (Self'Unchecked_Access, Parent_Id);

   begin
      Regions.Entities.Array_Types.Array_Type_Entity (Parent.all)
        .Set_Element (Element.Selected_Name);
   end Set_Component_Type;

   -------------------
   -- With_Snapshot --
   -------------------

   procedure With_Snapshot
     (Self  : in out Environment;
      Value : Snapshot'Class) is
   begin
      Version := Version + 1;
      Self.Entity_Map := Self.Entity_Map.Union (Value.Entity_Map);
   end With_Snapshot;

end Regions.Environments.Factory;
