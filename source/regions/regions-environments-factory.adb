--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0
-------------------------------------------------------------

with Regions.Contexts;
with Regions.Entities.Enumeration_Types;
with Regions.Entities.Enumeration_Literals;
with Regions.Entities.Packages;
with Regions.Entities.Roots;
with Regions.Entities.Signed_Integer_Types;
with Regions.Entities.Subtypes;

package body Regions.Environments.Factory is

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

      Type_Name : Regions.Contexts.Selected_Entity_Name;
   begin
      declare
         Entity : constant Entity_Access := new Regions.Entities.Entity'Class'
           (Regions.Entities.Enumeration_Types.Create (Self'Unchecked_Access));

         --  Insert Entity into environment can change Parent :(
         Parent : constant Entity_Access :=
           Get_Entity (Self'Unchecked_Access, Parent_Id);
      begin
         Parent.Region.Insert (Symbol, Parent_Id, Type_Name);
         Self.Entity_Map.Insert (Type_Name, Entity);
         Set_Name (Entity.all, Type_Name);
      end;

      for S of Literals loop
         declare
            Entity : constant Entity_Access :=
              new Regions.Entities.Entity'Class'
                (Regions.Entities.Enumeration_Literals.Create
                   (Self'Unchecked_Access, Type_Name));

            Name : Regions.Contexts.Selected_Entity_Name;

            --  Insert Entity into environment can change Parent :(
            Parent : constant Entity_Access :=
              Get_Entity (Self'Unchecked_Access, Parent_Id);
         begin
            Parent.Region.Insert (S, Parent_Id, Name);
            Self.Entity_Map.Insert (Name, Entity);
            Set_Name (Entity.all, Name);
         end;
      end loop;
   end Create_Enumeration_Type;

   --------------------
   -- Create_Package --
   --------------------

   procedure Create_Package
     (Self   : in out Environment;
      Symbol : Regions.Symbol)
   is
      Parent_Id : constant Regions.Contexts.Selected_Entity_Name :=
        Entity_Name_Lists.First_Element (Self.Nested);

      Entity : constant Entity_Access :=
        new Regions.Entities.Entity'Class'
          (Regions.Entities.Packages.Create (Self'Unchecked_Access));

      Name : Regions.Contexts.Selected_Entity_Name;
   begin
      declare
         --  Insert Entity into environment can change Parent :(
         Parent : constant Entity_Access :=
           Get_Entity (Self'Unchecked_Access, Parent_Id);
      begin
         Parent.Region.Insert (Symbol, Parent_Id, Name);
      end;

      Self.Entity_Map.Insert (Name, Entity);
      Self.Nested.Prepend (Name);
      Set_Name (Entity.all, Name);
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

      Type_Name : Regions.Contexts.Selected_Entity_Name;
   begin
      declare
         Entity : constant Entity_Access := new Regions.Entities.Entity'Class'
           (Regions.Entities.Signed_Integer_Types.Create
              (Self'Unchecked_Access));

         --  Insert Entity into environment can change Parent :(
         Parent : constant Entity_Access :=
           Get_Entity (Self'Unchecked_Access, Parent_Id);
      begin
         Parent.Region.Insert (Symbol, Parent_Id, Type_Name);
         Self.Entity_Map.Insert (Type_Name, Entity);
         Set_Name (Entity.all, Type_Name);
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

      Type_Name : Regions.Contexts.Selected_Entity_Name;
   begin
      declare
         Entity : constant Entity_Access := new Regions.Entities.Entity'Class'
           (Regions.Entities.Subtypes.Create
              (Self'Unchecked_Access, Subtype_Mark.Selected_Name));

         --  Insert Entity into environment can change Parent :(
         Parent : constant Entity_Access :=
           Get_Entity (Self'Unchecked_Access, Parent_Id);
      begin
         Parent.Region.Insert (Symbol, Parent_Id, Type_Name);
         Self.Entity_Map.Insert (Type_Name, Entity);
         Set_Name (Entity.all, Type_Name);
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
