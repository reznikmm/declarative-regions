--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Regions.Entities.Packages;
with Regions.Environments;
with Regions.Factories;

package Regions.Contexts.Environments.Factories is
   pragma Preelaborate;

   type Factory (Context : access Regions.Contexts.Context) is
     new Regions.Factories.Factory with private;

private

   type Factory (Context : access Regions.Contexts.Context)
     is new Regions.Factories.Factory with
      record
         null;
      end record;

   overriding function Root_Environment (Self : access Factory)
     return Regions.Environments.Environment;

   overriding function Enter_Region
     (Self        : access Factory;
      Environment : Regions.Environments.Environment;
      Region      : not null Regions.Entities.Packages.Package_Access)
        return Regions.Environments.Environment;

   overriding function Create_Package
     (Self        : access Factory;
      Environment : Regions.Environments.Environment;
      Name        : Regions.Contexts.Selected_Entity_Name)
       return Regions.Entities.Packages.Package_Access;

   overriding procedure Append_Entity
     (Self   : access Factory;
      Region : in out Regions.Region'Class;
      Symbol : Regions.Symbols.Symbol;
      Entity : Regions.Entities.Entity_Access);

end Regions.Contexts.Environments.Factories;
