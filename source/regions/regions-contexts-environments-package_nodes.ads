--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Regions.Contexts.Environments.Nodes;
with Regions.Shared_Hashed_Maps;
with Regions.Shared_Lists;

private
package Regions.Contexts.Environments.Package_Nodes is
   pragma Preelaborate;

   function Hash
     (Value : Regions.Symbols.Symbol) return Ada.Containers.Hash_Type
       is (Ada.Containers.Hash_Type'Mod (Value));

   type List_Change_Count is mod 2 ** 32;

   package Name_List_Maps is new Regions.Shared_Hashed_Maps
     (Regions.Symbols.Symbol,
      Selected_Entity_Name_Lists.List,
      Ada.Containers.Hash_Type,
      List_Change_Count,
      Hash,
      Regions.Symbols."=",
      Selected_Entity_Name_Lists."=");

   type Package_Node;

   function Empty_Map (Self : access Package_Node)
     return Name_List_Maps.Map;

   type Package_Node is new Nodes.Entity_Node with record
      Version : aliased List_Change_Count := 0;
      Names   : Name_List_Maps.Map :=
        Empty_Map (Package_Node'Unchecked_Access);
   end record;

   type Package_Entity is new Environments.Nodes.Base_Entity
     and Regions.Entities.Packages.Package_Entity
       with null record;

   overriding function Is_Package (Self : Package_Entity) return Boolean
     is (True);

   overriding function Immediate_Visible_Backward
     (Self   : Package_Entity;
      Symbol : Symbols.Symbol)
        return Entities.Entity_Iterator'Class;

   overriding function Immediate_Visible
     (Self   : Package_Entity;
      Symbol : Symbols.Symbol)
        return Entities.Entity_Iterator'Class;

end Regions.Contexts.Environments.Package_Nodes;
