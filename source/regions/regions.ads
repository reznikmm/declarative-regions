--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

limited with Regions.Entities;
limited with Regions.Environments;
limited with Regions.Contexts;

package Regions is
   pragma Preelaborate;

   type Symbol is mod 2 ** 32;
   --  First 16#11_0000# symbols are reserved for characters

   type Symbol_Array is array (Positive range <>) of Symbol;

   type Entity_Access is access all Regions.Entities.Entity'Class;
   type Entity_Access_Array is array (Positive range <>) of Entity_Access;

   type Environment_Access is
     access all Regions.Environments.Environment'Class;

   type Snapshot_Access is access all Regions.Environments.Snapshot'Class;

   type Context_Access is access all Regions.Contexts.Context'Class
     with Storage_Size => 0;

   type Region is abstract tagged limited private;

   type Region_Access is access all Region'Class;
   type Region_Access_Array is array (Positive range <>) of Region_Access;

   not overriding function Immediate_Visible
     (Self   : Region;
      Symbol : Regions.Symbol) return Entity_Access_Array;
   --  Return array of entities in the region for given symbol in order of
   --  their declaration.

   not overriding function Corresponding_Entity
     (Self : Region) return Entity_Access;
   --  Return Entity corresponding to the region or null if region isn't an
   --  entity.

   procedure Initialize;

private

   type Change_Count is mod 2 ** 32;

   Version : aliased Change_Count := 1;
   --  Environment map version

   --  type Region (Entity : Entity_Access := null) is
   --    abstract tagged limited null record;
   type Region is abstract tagged limited record
      Entity : Entity_Access;
   end record;

   not overriding procedure Insert
     (Self   : in out Region;
      Symbol : Regions.Symbol;
      Name   : Regions.Contexts.Selected_Entity_Name);
   --  Insert Name with given Symbol into the Region.
   --  I want it to be abstract :(

   function Get_Entity
     (Env  : Environment_Access;
      Name : Regions.Contexts.Selected_Entity_Name) return Entity_Access;

   function Get_For_Update
     (Env  : Environment_Access;
      Name : Regions.Contexts.Selected_Entity_Name) return Entity_Access;

   function Get_Entities
     (Env   : Environment_Access;
      Names : Regions.Contexts.Selected_Entity_Name_Array)
      return Entity_Access_Array;

   Clone : access function (Self : Regions.Entities.Entity'Class)
     return Entity_Access;

end Regions;
