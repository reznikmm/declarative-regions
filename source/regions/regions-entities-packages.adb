--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

package body Regions.Entities.Packages is

   -----------
   -- Clone --
   -----------

   overriding function Clone (Self : Package_Entity) return Entity'Class is
   begin
      return Result : Package_Entity :=
        (Env    => Self.Env,
         Name   => Self.Name,
         Names  => Self.Names,
         Region => (Entity => null))
      do
         Result.Region.Entity := Result'Unchecked_Access;
      end return;
   end Clone;

   ------------
   -- Create --
   ------------

   function Create
     (Env  : Environment_Access;
      Name : Regions.Contexts.Selected_Entity_Name) return Entity'Class is
   begin
      return Result : Package_Entity (Env) do
         Result.Name := Name;
         Result.Region.Entity := Result'Unchecked_Access;
      end return;
   end Create;

end Regions.Entities.Packages;
