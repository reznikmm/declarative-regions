--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Regions.Contexts;
with Regions.Entities.Enumeration_Literals;
with Regions.Entities;
with Regions.Environments.Factory;

procedure Regions.Create_Enum is
   use all type Regions.Entities.Entity_Kind;
   Context : aliased Regions.Contexts.Context;
   Env : Regions.Environments.Environment (Context'Unchecked_Access);

   Standard   : constant Regions.Symbol := 16#11_0001#;
   Bool       : constant Regions.Symbol := 16#11_0002#;
   Bool_False : constant Regions.Symbol := 16#11_0003#;
   Bool_True  : constant Regions.Symbol := 16#11_0004#;
begin
   Regions.Initialize;
   Regions.Environments.Factory.Initialize (Env, Standard);
   Regions.Environments.Factory.Create_Package (Env, Standard);
   Regions.Environments.Factory.Create_Enumeration_Type
     (Env, Bool, (Bool_False, Bool_True));

   declare
      Scope : constant Regions.Region_Access_Array := Env.Nested_Regions;
      Tipe  : constant Regions.Entity_Access_Array :=
        Scope (1).Immediate_Visible (Bool);
      False : constant Regions.Entity_Access_Array :=
        Scope (1).Immediate_Visible (Bool_False);
   begin
      pragma Assert (Scope'Length = 2);  --  <root>, Standard
      pragma Assert (Tipe'Length = 1);  --  Standard has Bool
      pragma Assert (False'Length = 1);  --  Standard has Bool_False
      pragma Assert (False (1).Kind = An_Enumeration_Literal);
      pragma Assert
        (Regions.Entities.Enumeration_Literals.Enumeration_Literal_Entity
           (False (1).all).Enumeration_Type = Tipe (1));
   end;
end Regions.Create_Enum;
