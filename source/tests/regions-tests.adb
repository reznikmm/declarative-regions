
with Regions.Contexts;
with Regions.Entities.Packages;
with Regions.Environments.Factories;

package body Regions.Tests is

   procedure Symbol_Exists
     (Region : Regions.Region'Class;
      Symbol : Regions.Symbols.Symbol;
      Expect : Boolean)
   is
      Has_Symbol : Boolean := False;
   begin
      for X in Region.Immediate_Visible_Backward (Symbol) loop
         Has_Symbol := True;
      end loop;

      pragma Assert (Expect = Has_Symbol);
   end Symbol_Exists;


   -------------------
   -- Test_Standard --
   -------------------

   procedure Test_Standard is
      Ctx : aliased Regions.Contexts.Context;
      F   : aliased Regions.Environments.Factories.Factory
        (Ctx'Unchecked_Access);

      Standard_Symbol : constant := 1;

      Root               : constant Regions.Environments.Environment :=
        F.Root_Environment;
      Standard_Package   : Regions.Entities.Packages.Package_Access;
      Standard_Name      : Regions.Contexts.Entity_Name;
      Standard_Full_Name : Regions.Contexts.Selected_Entity_Name;
   begin
      Ctx.New_Entity_Name (Standard_Symbol, Standard_Name);
      Ctx.New_Selected_Name (Ctx.Root_Name, Standard_Name, Standard_Full_Name);
      Standard_Package := F.Create_Package (Root, Standard_Full_Name);
      pragma Assert (Standard_Package.Is_Assigned);

      --  Append Standard package to the first region in root
      F.Append_Entity
        (Regions.Region'Class (Root.Nested_Regions.First.Entity.all),
         Standard_Symbol,
         Regions.Entities.Entity_Access (Standard_Package));

      declare
         First : Boolean := True;
         Env   : constant Regions.Environments.Environment :=
           F.Enter_Region (Root, Standard_Package);
      begin
         for Cursor in Env.Nested_Regions loop
            declare
               Region : Regions.Region'Class renames
                 Regions.Region'Class (Cursor.Entity.all);
            begin
               Symbol_Exists (Region, Standard_Symbol, not First);

               if First then
                  pragma Assert (Cursor.Left = 1, "two regions expected");
                  First := False;
               end if;
            end;
         end loop;
      end;
   end Test_Standard;

end Regions.Tests;
