--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Containers.Hashed_Maps;
with Ada.Unchecked_Deallocation;
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

   type Environment_Node is limited new Environment_Interface with record
      Counter : Natural := 1;
      Version : aliased Node_Maps.Change_Count := 0;
      Nodes   : Node_Maps.Map := Empty_Map (Environment_Node'Unchecked_Access);
      Cache   : Entity_Maps.Map;
   end record;

   function Get_Entity
     (Self : in out Environment_Node;
      Name : Selected_Entity_Name) return Regions.Entities.Entity_Access;

   overriding procedure Rerference (Self : in out Environment_Node);

   overriding procedure Unreference
     (Self : in out Environment_Node;
      Last : out Boolean);

   type Environment_Node_Access is access all
     Regions.Contexts.Environments.Nodes.Environment_Node
       with Storage_Size => 0;

   type Base_Entity (Env : not null Environment_Node_Access) is
     abstract limited new Regions.Entities.Entity with
       record
          Name : Selected_Entity_Name;
       end record;

end Regions.Contexts.Environments.Nodes;
