--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Wide_Wide_Text_IO;
with Regions.Contexts;
with Regions.Environments.Factory;

procedure Regions.Run is
   Context : aliased Regions.Contexts.Context;
   Env : Regions.Environments.Environment (Context'Unchecked_Access);

   Standard : constant Regions.Symbol := 1;
begin
   Regions.Environments.Factory.Initialize (Env, Standard);
   Regions.Environments.Factory.Create_Package (Env, Standard);

   declare
      Scope : constant Regions.Region_Access_Array := Env.Nested_Regions;
   begin
      pragma Assert (Scope'Length = 2);
      for Item in Scope'Range loop
         declare
            X : constant Regions.Entity_Access_Array :=
              Scope (Item).Immediate_Visible (Standard);
         begin
            pragma Assert (Item - X'Length = 1);
            Ada.Wide_Wide_Text_IO.Put_Line
              (Integer'Wide_Wide_Image (X'Length));
         end;
      end loop;
   end;
end Regions.Run;
