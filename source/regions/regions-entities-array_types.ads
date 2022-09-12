--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

private with Regions.Contexts;
private with Regions.Environments;

package Regions.Entities.Array_Types is

   pragma Preelaborate;

   type Array_Type_Entity is new Entity with private;

   function Create
     (Env     : Environment_Access;
      Name    : Regions.Contexts.Selected_Entity_Name;
      Indexes : Regions.Contexts.Selected_Entity_Name_Array)
        return Entity'Class with Inline;

   procedure Set_Element
     (Self    : in out Array_Type_Entity;
      Element : Regions.Contexts.Selected_Entity_Name);

   function Indexes (Self : Array_Type_Entity) return Entity_Access_Array;

   function Element (Self : Array_Type_Entity) return Entity_Access;

private

   type Array_Type_Entity
     (Env    : not null Environment_Access;
      Length : Positive) is new Entity (Env) with
   record
      Index   : Regions.Contexts.Selected_Entity_Name_Array (1 .. Length);
      Element : Regions.Contexts.Selected_Entity_Name;
   end record;

   overriding function Kind
     (Self : Array_Type_Entity) return Entity_Kind
       is (An_Array_Type);

   overriding function Has_Region
     (Self : Array_Type_Entity) return Boolean is (False);
   --  Only anonymous nested region is expected (access definition)

   overriding function Is_Overloadable
     (Self : Array_Type_Entity) return Boolean is (False);

   overriding function Immediate_Visible
     (Self   : Array_Type_Entity;
      Symbol : Regions.Symbol) return Entity_Access_Array is (1 .. 0 => <>);

   function Create
     (Env     : Environment_Access;
      Name    : Regions.Contexts.Selected_Entity_Name;
      Indexes : Regions.Contexts.Selected_Entity_Name_Array)
        return Entity'Class is
          (Array_Type_Entity'
            (Env     => Env,
             Length  => Indexes'Length,
             Index   => Indexes,
             Element => Env.Context.Root_Name,  --  some meaningless default
             Name    => Name));

   function Indexes (Self : Array_Type_Entity)
     return Entity_Access_Array is (Get_Entities (Self.Env, Self.Index));

   function Element (Self : Array_Type_Entity)
     return Entity_Access is (Get_Entity (Self.Env, Self.Element));

end Regions.Entities.Array_Types;
