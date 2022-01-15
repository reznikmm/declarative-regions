--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Regions.Contexts.Environments.Package_Nodes;

package body Regions.Contexts.Environments.Nodes is

   type Entity_Access is access all Regions.Entities.Entity'Class;

   ---------------
   -- Empty_Map --
   ---------------

   function Empty_Map (Self : access Environment_Node) return Node_Maps.Map is
   begin
      return Node_Maps.Empty_Map (Self.Version'Access);
   end Empty_Map;

   ----------------
   -- Get_Entity --
   ----------------

   function Get_Entity
     (Self : in out Environment_Node;
      Name : Selected_Entity_Name)
      return Regions.Entities.Entity_Access
   is
      Cached : Entity_Maps.Cursor := Self.Cache.Find (Name);
      Cursor : Node_Maps.Cursor;
      --  Node   : Entity_Node_Access;
      Item   : Entity_Access;
      Result : Regions.Entities.Entity_Access;
   begin
      if Entity_Maps.Has_Element (Cached) then
         return Entity_Maps.Element (Cached);
      elsif Self.Nodes.Contains (Name) then
         --  Node := Self.Nodes.Element (Name);
         Item := new Package_Nodes.Package_Entity'
           (Env  => Self'Unchecked_Access,
            Name => Name);

         Result := Regions.Entities.Entity_Access (Item);

         Self.Cache.Insert (Name, Result);

         return Result;
      else
         return null;
      end if;
   end Get_Entity;

   ----------------
   -- Rerference --
   ----------------

   overriding procedure Rerference (Self : in out Environment_Node) is
   begin
      Self.Counter := Self.Counter + 1;
   end Rerference;

   -----------------
   -- Unreference --
   -----------------

   overriding procedure Unreference
     (Self : in out Environment_Node;
      Last : out Boolean) is
   begin
      Last := Self.Counter <= 1;

      if Last then
         Self.Counter := 0;
      else
         Self.Counter := Self.Counter - 1;
      end if;
   end Unreference;

end Regions.Contexts.Environments.Nodes;
