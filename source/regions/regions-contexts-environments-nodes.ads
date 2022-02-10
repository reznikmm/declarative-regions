--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Containers.Hashed_Maps;
with Ada.Unchecked_Deallocation;
with Regions.Entities;
with Regions.Shared_Hashed_Maps;

private
package Regions.Contexts.Environments.Nodes is
   pragma Preelaborate;

   type Entity_Node is tagged limited null record;

   type Entity_Node_Access is access all Entity_Node'Class;

   function Hash (List : Selected_Entity_Name) return Ada.Containers.Hash_Type
     is (Ada.Containers.Hash_Type'Mod (List));

   procedure Free is new Ada.Unchecked_Deallocation
     (Entity_Node'Class, Entity_Node_Access);

   package Node_Maps is new Regions.Shared_Hashed_Maps
     (Selected_Entity_Name,
      Entity_Node_Access,
      Ada.Containers.Hash_Type,
      Regions.Contexts.Change_Count,
      Hash,
      "=",
      "=",
      Free);

   package Entity_Maps is new Ada.Containers.Hashed_Maps
     (Selected_Entity_Name,
      Regions.Entities.Entity_Access,
      Hash,
      "=",
      Regions.Entities."=");

   type Environment_Node;

   function Empty_Map (Self : access Environment_Node) return Node_Maps.Map;

   type Environment_Node (Context : access Regions.Contexts.Context) is
     tagged limited
   record
      Counter : Natural := 1;
      Nodes   : Node_Maps.Map := Empty_Map (Environment_Node'Unchecked_Access);
      Cache   : Entity_Maps.Map;
      Nested  : Selected_Entity_Name_Lists.List;
   end record;

   function Get_Entity
     (Self : in out Environment_Node'Class;
      Name : Selected_Entity_Name) return Regions.Entities.Entity_Access;

   procedure Reference (Self : in out Environment_Node'Class);

   procedure Unreference
     (Self : in out Environment_Node'Class;
      Last : out Boolean);

   type Base_Entity (Env : not null Environment_Node_Access) is
     abstract limited new Regions.Entities.Entity with
       record
          Name : Selected_Entity_Name;
       end record;

end Regions.Contexts.Environments.Nodes;
