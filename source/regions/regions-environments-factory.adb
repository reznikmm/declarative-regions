--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0
-------------------------------------------------------------

with Regions.Entities.Roots;
with Regions.Entities.Packages;
with Regions.Contexts;

package body Regions.Environments.Factory is

   --------------------
   -- Create_Package --
   --------------------

   procedure Create_Package
     (Self   : in out Environment;
      Symbol : Regions.Symbol)
   is
      Entity : constant Entity_Access :=
        new Regions.Entities.Entity'Class'
          (Regions.Entities.Packages.Create (Self'Unchecked_Access, Symbol));

      Name : Regions.Contexts.Selected_Entity_Name;
   begin
      declare
         Id : constant Regions.Contexts.Selected_Entity_Name :=
           Entity_Name_Lists.First_Element (Self.Nested);

         --  Insert Entity into environment can change Parent :(
         Parent : constant Entity_Access :=
           Get_Entity (Self'Unchecked_Access, Id);
      begin
         Parent.Region.Insert (Symbol, Id, Name);
      end;

      Self.Entity_Map.Insert (Name, Entity);
      Self.Nested.Prepend (Name);
   end Create_Package;

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

end Regions.Environments.Factory;
