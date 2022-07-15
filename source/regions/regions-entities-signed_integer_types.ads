--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0
-------------------------------------------------------------

package Regions.Entities.Signed_Integer_Types is

   pragma Preelaborate;

   type Signed_Integer_Type_Entity is new Entity with private;

   function Create (Env : Environment_Access) return Entity'Class with Inline;

private

   type Signed_Integer_Type_Entity is new Entity with null record;

   overriding function Kind
     (Self : Signed_Integer_Type_Entity) return Entity_Kind
       is (A_Signed_Integer_Type);

   overriding function Has_Region
     (Self : Signed_Integer_Type_Entity) return Boolean is (False);

   overriding function Is_Overloadable
     (Self : Signed_Integer_Type_Entity) return Boolean is (False);

   overriding function Immediate_Visible
     (Self   : Signed_Integer_Type_Entity;
      Symbol : Regions.Symbol) return Entity_Access_Array is (1 .. 0 => <>);

   function Create (Env : Environment_Access) return Entity'Class is
      (Signed_Integer_Type_Entity'(Env => Env, others => <>));

end Regions.Entities.Signed_Integer_Types;
