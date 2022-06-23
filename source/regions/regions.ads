--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0
-------------------------------------------------------------

limited with Regions.Entities;
limited with Regions.Environments;
limited private with Regions.Contexts;

package Regions is
   pragma Preelaborate;

   type Symbol is mod 2 ** 32;

   type Entity_Access is access all Regions.Entities.Entity'Class;
   type Entity_Access_Array is array (Positive range <>) of Entity_Access;

   type Environment_Access is
     access all Regions.Environments.Environment'Class;

   type Region is tagged limited private;

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

private

   type Profile_Id is new Natural;
   type Entity_Name is new Natural;
   type Selected_Entity_Name is new Natural;
   type Change_Count is mod 2 ** 32;

   No_Profile : constant Profile_Id := 0;
   --  To create an non-overloadable entity (without any profile)
   Root_Entity : Selected_Entity_Name := 1;
   --  An artifical entity containing standard package

   type Region (Entity : Entity_Access := null) is tagged limited null record;

   function Get_Entity
     (Env  : Environment_Access;
      Name : Selected_Entity_Name) return Entity_Access;

   type Context_Access is access all Regions.Contexts.Context'Class
     with Storage_Size => 0;

   Context : Context_Access;

end Regions;
