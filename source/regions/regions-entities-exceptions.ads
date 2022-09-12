--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

package Regions.Entities.Exceptions is

   pragma Preelaborate;

   type Exception_Entity is new Entity with private;

   function Create
     (Env  : Environment_Access;
      Name : Regions.Contexts.Selected_Entity_Name) return Entity'Class
     with Inline;

private

   type Exception_Entity is new Entity with null record;

   overriding function Kind
     (Self : Exception_Entity) return Entity_Kind
       is (An_Exception);

   overriding function Has_Region
     (Self : Exception_Entity) return Boolean is (False);

   overriding function Is_Overloadable
     (Self : Exception_Entity) return Boolean is (False);

   overriding function Immediate_Visible
     (Self   : Exception_Entity;
      Symbol : Regions.Symbol) return Entity_Access_Array is (1 .. 0 => <>);

   function Create
     (Env  : Environment_Access;
      Name : Regions.Contexts.Selected_Entity_Name) return Entity'Class is
        (Exception_Entity'(Env, Name));

end Regions.Entities.Exceptions;
