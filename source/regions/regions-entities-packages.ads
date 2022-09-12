--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

package Regions.Entities.Packages is

   pragma Preelaborate;

   type Package_Entity is new Entity with private;

   function Create
     (Env  : Environment_Access;
      Name : Regions.Contexts.Selected_Entity_Name) return Entity'Class
        with Inline;

private

   type Package_Entity is new Entity_With_Region with null record;

   overriding function Kind (Self : Package_Entity) return Entity_Kind
     is (A_Package);

   overriding function Is_Overloadable (Self : Package_Entity) return Boolean
     is (False);

   overriding function Clone (Self : Package_Entity) return Entity'Class;

end Regions.Entities.Packages;
