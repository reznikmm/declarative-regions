--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0
-------------------------------------------------------------

private with Ada.Containers;
private with Ada.Unchecked_Deallocation;

private with Regions.Entities;
private with Regions.Shared_Hashed_Maps;
private with Regions.Shared_Lists;
with Regions.Contexts;

package Regions.Environments is
   pragma Preelaborate;

   type Environment (Context : Context_Access) is tagged limited private;

   function Nested_Regions (Self : Environment'Class)
     return Regions.Region_Access_Array;

private

   procedure Free is new Ada.Unchecked_Deallocation
     (Regions.Entities.Entity'Class, Entity_Access);

   package Entity_Maps is new Regions.Shared_Hashed_Maps
     (Regions.Contexts.Selected_Entity_Name,
      Entity_Access,
      Ada.Containers.Hash_Type,
      Change_Count,
      Regions.Contexts.Hash,
      Regions.Contexts."=",
      "=",
      Free);

   package Entity_Name_Lists is new Regions.Shared_Lists
     (Regions.Contexts.Selected_Entity_Name,
      Regions.Contexts."=");

   Version : aliased Change_Count := 1;

   type Environment (Context : Context_Access) is
   tagged limited record
      Entity_Map : Entity_Maps.Map :=
        Entity_Maps.Empty_Map (Version'Unchecked_Access);
      --  A map from selected entity name to corresponding Entity object
      Nested     : Entity_Name_Lists.List;
      --  Selected entity name list for each nested region
   end record;

end Regions.Environments;
