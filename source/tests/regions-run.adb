--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Wide_Wide_Text_IO;

with Regions.Contexts;
with Regions.Environments;
with Regions.Environments.Factories;
with Regions.Entities.Packages;

procedure Regions.Run is
   Ctx : aliased Regions.Contexts.Context;
   F   : aliased Regions.Environments.Factories.Factory (Ctx'Unchecked_Access);

   Root : constant Regions.Environments.Environment := F.Root_Environment;
   Std  : Regions.Entities.Packages.Package_Access;
   Std_Name_1 : Regions.Contexts.Entity_Name;
   Std_Name   : Regions.Contexts.Selected_Entity_Name;
begin
   Ctx.New_Entity_Name (1, Std_Name_1);
   Ctx.New_Selected_Name (Ctx.Root_Name, Std_Name_1, Std_Name);
   Std := F.Create_Package (Root, Std_Name);
   pragma Assert (Std.Is_Assigned);

   declare
      Env : constant Regions.Environments.Environment :=
        F.Enter_Region (Root, Std);
      Int : Regions.Entity_Iterator_Interfaces.Forward_Iterator'Class :=
        Env.Nested_Regions;
   begin
      for X in Int loop
         Ada.Wide_Wide_Text_IO.Put_Line ("Hello!");
      end loop;
   end;
end Regions.Run;
