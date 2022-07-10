--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0
-------------------------------------------------------------

package Regions.Entities.Enumeration_Types is

   pragma Preelaborate;

   type Enumeration_Type_Entity is new Entity with private;

   function Create (Env : Environment_Access) return Entity'Class with Inline;

private

   type Enumeration_Type_Entity is new Entity with null record;

   overriding function Kind
     (Self : Enumeration_Type_Entity) return Entity_Kind
       is (An_Enumeration_Type);

   overriding function Has_Region
     (Self : Enumeration_Type_Entity) return Boolean is (False);

   overriding function Is_Overloadable
     (Self : Enumeration_Type_Entity) return Boolean is (True);

   overriding function Immediate_Visible
     (Self   : Enumeration_Type_Entity;
      Symbol : Regions.Symbol) return Entity_Access_Array is (1 .. 0 => <>);

   function Create (Env : Environment_Access) return Entity'Class is
      (Enumeration_Type_Entity'(Env => Env, others => <>));

end Regions.Entities.Enumeration_Types;
