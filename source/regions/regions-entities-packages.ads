--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0
-------------------------------------------------------------

with Ada.Containers;
with Regions.Shared_Hashed_Maps;
with Regions.Shared_Lists;

package Regions.Entities.Packages is

   pragma Preelaborate;

   type Package_Entity is new Entity with private;

   function Create
     (Env    : Environment_Access;
      Symbol : Regions.Symbol) return Entity'Class with Inline;

private

   package Entity_Name_Lists is new Regions.Shared_Lists
     (Selected_Entity_Name);

   function Hash (Value : Regions.Symbol) return Ada.Containers.Hash_Type is
     (Ada.Containers.Hash_Type'Mod (Value));

   package Entity_Maps is new Regions.Shared_Hashed_Maps
     (Regions.Symbol,
      Entity_Name_Lists.List,
      Ada.Containers.Hash_Type,
      Change_Count,
      Hash,
      "=",
      "=");

   type Package_Entity is new Entity with record
      Symbol : Regions.Symbol;
   end record;

   overriding function Has_Region (Self : Package_Entity) return Boolean
     is (True);

   overriding function Immediate_Visible
     (Self   : Package_Entity;
      Symbol : Regions.Symbol) return Entity_Access_Array;

end Regions.Entities.Packages;
