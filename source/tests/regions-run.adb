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
   Std  : constant Regions.Entities.Packages.Package_Access :=
     F.Create_Package (Root);
   pragma Unreferenced (Std);
begin
   Ada.Wide_Wide_Text_IO.Put_Line (" Hello!");
end Regions.Run;
