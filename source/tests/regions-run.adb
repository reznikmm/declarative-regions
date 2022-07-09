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

   Standard   : constant Regions.Symbol := 1;
   Ada_Symbol : constant Regions.Symbol := 2;
begin
   Regions.Initialize;
   Regions.Environments.Factory.Initialize (Env, Standard);
   Regions.Environments.Factory.Create_Package (Env, Standard);

   --  Check two regions (<root>, Standard). Check only <root> has Standard
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
         end;
      end loop;
   end;

   --  Make snapshot, create Ada in Standard, restore Snapshot, check no Ada
   declare
      Snapshot : constant Regions.Snapshot_Access :=
        Regions.Environments.Factory.Make_Snapshot (Env);
   begin
      Regions.Environments.Factory.Create_Package (Env, Ada_Symbol);

      declare
         Scope : constant Regions.Region_Access_Array := Env.Nested_Regions;
         X : constant Regions.Entity_Access_Array :=
           Scope (2).Immediate_Visible (Ada_Symbol);
      begin
         pragma Assert (Scope'Length = 3);  --  <root>, Standard, Ada
         pragma Assert (X'Length = 1);  --  Standard has Ada
      end;

      Regions.Environments.Factory.Leave_Region (Env);

      declare
         Scope : constant Regions.Region_Access_Array := Env.Nested_Regions;
         X : constant Regions.Entity_Access_Array :=
           Scope (1).Immediate_Visible (Ada_Symbol);
      begin
         pragma Assert (Scope'Length = 2);  --  <root>, Standard
         pragma Assert (X'Length = 1);  --  Standard has Ada
      end;

      Regions.Environments.Factory.Load_Snapshot (Env, Snapshot.all);

      declare
         Scope : constant Regions.Region_Access_Array := Env.Nested_Regions;
         X : constant Regions.Entity_Access_Array :=
           Scope (2).Immediate_Visible (Ada_Symbol);
      begin
         pragma Assert (Scope'Length = 2);  --  <root>, Standard
         pragma Assert (X'Length = 0);  --  No Ada in Standard
      end;
   end;

   Ada.Wide_Wide_Text_IO.Put_Line ("Ok");
end Regions.Run;
