--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Regions.Contexts.Environments.Nodes;
with Regions.Contexts.Environments.Package_Nodes;

package body Regions.Contexts.Environments.Factories is

   type Environment_Node_Access is access all
     Regions.Contexts.Environments.Nodes.Environment_Node;

   type Package_Node_Access is access all
     Regions.Contexts.Environments.Package_Nodes.Package_Node;

   -------------------
   -- Append_Entity --
   -------------------

   overriding procedure Append_Entity
     (Self   : access Factory;
      Region : in out Regions.Region'Class;
      Symbol : Regions.Symbols.Symbol;
      Entity : Regions.Entities.Entity_Access)
   is
      Name : constant Selected_Entity_Name :=
        Nodes.Base_Entity'Class (Entity.all).Name;

      Reg  : Nodes.Base_Entity'Class renames Nodes.Base_Entity'Class (Region);
      Env  : constant Environments.Environment_Node_Access := Reg.Env;
      Node : constant Nodes.Entity_Node_Access := Env.Nodes.Element (Reg.Name);
      Pkg  : constant Package_Node_Access := Package_Node_Access (Node);
      List : Selected_Entity_Name_Lists.List;
   begin
      pragma Assert (Env = Nodes.Base_Entity'Class (Entity.all).Env);

      if Pkg.Names.Contains (Symbol) then
         List := Pkg.Names.Element (Symbol);
      end if;

      List.Prepend (Name);
      Pkg.Names.Insert (Symbol, List);
   end Append_Entity;

   --------------------
   -- Create_Package --
   --------------------

   overriding function Create_Package
     (Self        : access Factory;
      Environment : Regions.Environments.Environment;
      Name        : Regions.Contexts.Selected_Entity_Name)
      return Regions.Entities.Packages.Package_Access
   is
      Env  : constant Environments.Environment_Node_Access :=
        Environment.Data;
      Node : constant Package_Node_Access :=
        new Regions.Contexts.Environments.Package_Nodes.Package_Node;
   begin
      Env.Nodes.Insert (Name, Environments.Nodes.Entity_Node_Access (Node));

      return Regions.Entities.Packages.Package_Access (Env.Get_Entity (Name));
   end Create_Package;

   ------------------
   -- Enter_Region --
   ------------------

   overriding function Enter_Region
     (Self        : access Factory;
      Environment : Regions.Environments.Environment;
      Region      : not null Regions.Entities.Packages.Package_Access)
        return Regions.Environments.Environment
   is
      Reg : Nodes.Base_Entity'Class renames
        Nodes.Base_Entity'Class (Region.all);

      Env : constant Environments.Environment_Node_Access :=
        Environment.Data;

      Node : constant Environments.Environment_Node_Access := new
        Regions.Contexts.Environments.Nodes.Environment_Node'
          (Context => Self.Context,
           Counter => 1,
           Nodes   => Env.Nodes,
           Cache   => Nodes.Entity_Maps.Empty_Map,
           Nested  => Env.Nested);
   begin
      Node.Nested.Prepend (Reg.Name);
      --  Shell we copy Region to Env???

      return (Ada.Finalization.Controlled with Data => Node);
   end Enter_Region;

   ----------------------
   -- Root_Environment --
   ----------------------

   overriding function Root_Environment (Self : access Factory)
     return Regions.Environments.Environment
   is
      Name        : constant Selected_Entity_Name := Self.Context.Root_Name;

      Environment : constant Environment_Node_Access := new
        Regions.Contexts.Environments.Nodes.Environment_Node (Self.Context);

      Node        : constant Package_Node_Access :=
        new Regions.Contexts.Environments.Package_Nodes.Package_Node;
      --  A pseudo-package to keep Standard in it.
   begin
      Environment.Nodes.Insert (Name, Nodes.Entity_Node_Access (Node));

      return (Ada.Finalization.Controlled with
                Data => Environments.Environment_Node_Access (Environment));
   end Root_Environment;

end Regions.Contexts.Environments.Factories;
