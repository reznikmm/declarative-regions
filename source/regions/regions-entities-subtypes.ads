--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

private with Regions.Contexts;

package Regions.Entities.Subtypes is

   pragma Preelaborate;

   type Subtype_Entity is new Entity with private;

   function Create
     (Env          : Environment_Access;
      Name         : Regions.Contexts.Selected_Entity_Name;
      Subtype_Mark : Regions.Contexts.Selected_Entity_Name)
      return Entity'Class with Inline;

   function Subtype_Mark (Self : Subtype_Entity) return Entity_Access;

private

   type Subtype_Entity is new Entity with record
      Subtype_Mark : Regions.Contexts.Selected_Entity_Name;
   end record;

   overriding function Kind
     (Self : Subtype_Entity) return Entity_Kind is (A_Subtype);

   overriding function Has_Region
     (Self : Subtype_Entity) return Boolean is (False);

   overriding function Is_Overloadable
     (Self : Subtype_Entity) return Boolean is (False);

   overriding function Immediate_Visible
     (Self   : Subtype_Entity;
      Symbol : Regions.Symbol) return Entity_Access_Array is (1 .. 0 => <>);

   function Create
     (Env          : Environment_Access;
      Name         : Regions.Contexts.Selected_Entity_Name;
      Subtype_Mark : Regions.Contexts.Selected_Entity_Name)
      return Entity'Class is
        (Subtype_Entity'(Env          => Env,
                         Name         => Name,
                         Subtype_Mark => Subtype_Mark));

   function Subtype_Mark (Self : Subtype_Entity)
     return Entity_Access is (Get_Entity (Self.Env, Self.Subtype_Mark));

end Regions.Entities.Subtypes;
