--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0
-------------------------------------------------------------

with Ada.Containers;
with Regions.Contexts;
with Regions.Shared_Hashed_Maps;
with Regions.Shared_Lists;

package Regions.Entities.Packages is

   pragma Preelaborate;

   type Package_Entity is new Entity with private;

   function Create (Env : Environment_Access) return Entity'Class with Inline;

private

   package Entity_Name_Lists is new Regions.Shared_Lists
     (Regions.Contexts.Selected_Entity_Name,
      Regions.Contexts."=");

   function Hash (Value : Regions.Symbol) return Ada.Containers.Hash_Type is
     (Ada.Containers.Hash_Type'Mod (Value));

   package Name_Maps is new Regions.Shared_Hashed_Maps
     (Regions.Symbol,
      Entity_Name_Lists.List,
      Ada.Containers.Hash_Type,
      Change_Count,
      Hash,
      "=",
      Entity_Name_Lists."=");

   Package_Version : aliased Change_Count := 0;

   type Package_Entity is new Entity with record
      Names  : Name_Maps.Map := Name_Maps.Empty_Map (Package_Version'Access);
   end record;

   overriding function Kind (Self : Package_Entity) return Entity_Kind
     is (A_Package);

   overriding function Has_Region (Self : Package_Entity) return Boolean
     is (True);

   overriding function Is_Overloadable (Self : Package_Entity) return Boolean
     is (False);

   overriding function Immediate_Visible
     (Self   : Package_Entity;
      Symbol : Regions.Symbol) return Entity_Access_Array;

   overriding procedure Insert
     (Self   : in out Package_Entity;
      Symbol : Regions.Symbol;
      Parent : Regions.Contexts.Selected_Entity_Name;
      Name   : out Regions.Contexts.Selected_Entity_Name);

   overriding function Clone (Self : Package_Entity) return Entity'Class;

end Regions.Entities.Packages;
