--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

package Regions.Entities.Fixed_Point_Types is

   pragma Preelaborate;

   type Fixed_Point_Type_Entity is new Entity with private;

   function Create
     (Env  : Environment_Access;
      Name : Regions.Contexts.Selected_Entity_Name) return Entity'Class
        with Inline;

private

   type Fixed_Point_Type_Entity is new Entity with null record;

   overriding function Kind
     (Self : Fixed_Point_Type_Entity) return Entity_Kind
       is (A_Fixed_Point_Type);

   overriding function Has_Region
     (Self : Fixed_Point_Type_Entity) return Boolean is (False);

   overriding function Is_Overloadable
     (Self : Fixed_Point_Type_Entity) return Boolean is (False);

   overriding function Immediate_Visible
     (Self   : Fixed_Point_Type_Entity;
      Symbol : Regions.Symbol) return Entity_Access_Array is (1 .. 0 => <>);

   function Create
     (Env  : Environment_Access;
      Name : Regions.Contexts.Selected_Entity_Name) return Entity'Class is
      (Fixed_Point_Type_Entity'(Env, Name));

end Regions.Entities.Fixed_Point_Types;
