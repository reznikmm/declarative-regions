--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

package Regions.Entities.Floating_Point_Types is

   pragma Preelaborate;

   type Floating_Point_Type_Entity is new Entity with private;

   function Create
     (Env  : Environment_Access;
      Name : Regions.Contexts.Selected_Entity_Name) return Entity'Class
        with Inline;

private

   type Floating_Point_Type_Entity is new Entity with null record;

   overriding function Kind
     (Self : Floating_Point_Type_Entity) return Entity_Kind
       is (A_Floating_Point_Type);

   overriding function Has_Region
     (Self : Floating_Point_Type_Entity) return Boolean is (False);

   overriding function Is_Overloadable
     (Self : Floating_Point_Type_Entity) return Boolean is (False);

   overriding function Immediate_Visible
     (Self   : Floating_Point_Type_Entity;
      Symbol : Regions.Symbol) return Entity_Access_Array is (1 .. 0 => <>);

   function Create
     (Env  : Environment_Access;
      Name : Regions.Contexts.Selected_Entity_Name) return Entity'Class is
      (Floating_Point_Type_Entity'(Env, Name));

end Regions.Entities.Floating_Point_Types;
