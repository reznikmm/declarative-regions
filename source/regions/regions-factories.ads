--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Regions.Contexts;
with Regions.Entities.Packages;
with Regions.Environments;

package Regions.Factories is
   pragma Preelaborate;

   type Factory is limited interface;

   ------------------
   --  Environment --
   ------------------

   not overriding function Root_Environment (Self : access Factory)
     return Regions.Environments.Environment is abstract;
   --  Create a root environment that contains an empty standard package

   not overriding function Enter_Region
     (Self        : access Factory;
      Environment : Regions.Environments.Environment;
      Region      : not null Regions.Entities.Packages.Package_Access)
        return Regions.Environments.Environment is abstract;

   not overriding function Create_Package
     (Self        : access Factory;
      Environment : Regions.Environments.Environment;
      Name        : Regions.Contexts.Selected_Entity_Name)
       return Regions.Entities.Packages.Package_Access is abstract;

   not overriding procedure Append_Entity
     (Self   : access Factory;
      Region : in out Regions.Region'Class;
      Symbol : Regions.Symbols.Symbol;
      Entity : Regions.Entities.Entity_Access) is abstract;

end Regions.Factories;
