--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0
-------------------------------------------------------------

private with Regions.Contexts;

package Regions.Entities.Enumeration_Literals is

   pragma Preelaborate;

   type Enumeration_Literal_Entity is new Entity with private;

   function Create
     (Env  : Environment_Access;
      Tipe : Regions.Contexts.Selected_Entity_Name)
        return Entity'Class with Inline;

   function Enumeration_Type (Self : Enumeration_Literal_Entity)
     return Entity_Access;

private

   type Enumeration_Literal_Entity is new Entity with record
      Tipe : Regions.Contexts.Selected_Entity_Name;
   end record;

   overriding function Kind
     (Self : Enumeration_Literal_Entity) return Entity_Kind
       is (An_Enumeration_Literal);

   overriding function Has_Region
     (Self : Enumeration_Literal_Entity) return Boolean is (False);

   overriding function Is_Overloadable
     (Self : Enumeration_Literal_Entity) return Boolean is (True);

   overriding function Immediate_Visible
     (Self   : Enumeration_Literal_Entity;
      Symbol : Regions.Symbol) return Entity_Access_Array is (1 .. 0 => <>);

   function Create
     (Env  : Environment_Access;
      Tipe : Regions.Contexts.Selected_Entity_Name)
        return Entity'Class is
          (Enumeration_Literal_Entity'(Env => Env,
                                       Tipe   => Tipe,
                                       others => <>));

   function Enumeration_Type (Self : Enumeration_Literal_Entity)
     return Entity_Access is (Get_Entity (Self.Env, Self.Tipe));

end Regions.Entities.Enumeration_Literals;
