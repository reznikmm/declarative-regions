--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0
-------------------------------------------------------------

with Regions.Contexts;
with Regions.Entities;
with Regions.Environments.Internal;

package body Regions is

   --------------------------
   -- Corresponding_Entity --
   --------------------------

   not overriding function Corresponding_Entity
     (Self : Region) return Entity_Access
   is
   begin
      return (if Self.Entity.Assigned and then Self.Entity.Has_Region
              then Self.Entity else null);
   end Corresponding_Entity;

   ----------------
   -- Get_Entity --
   ----------------

   function Get_Entity
     (Env  : Environment_Access;
      Name : Regions.Contexts.Selected_Entity_Name) return Entity_Access is
        (Regions.Environments.Internal.Get_Entity (Env.all, Name));

   function Get_For_Update
     (Env  : Environment_Access;
      Name : Regions.Contexts.Selected_Entity_Name) return Entity_Access is
        (Regions.Environments.Internal.Get_For_Update (Env.all, Name));

   -----------------------
   -- Immediate_Visible --
   -----------------------

   not overriding function Immediate_Visible
     (Self   : Region;
      Symbol : Regions.Symbol) return Entity_Access_Array
   is
   begin
      if Self.Entity.Assigned then
         return Self.Entity.Immediate_Visible (Symbol);
      else
         return (1 .. 0 => null);
      end if;
   end Immediate_Visible;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      Regions.Entities.Initialize;
   end Initialize;

   ------------
   -- Insert --
   ------------

   not overriding procedure Insert
     (Self   : in out Region;
      Symbol : Regions.Symbol;
      Parent : Regions.Contexts.Selected_Entity_Name;
      Name   : out Regions.Contexts.Selected_Entity_Name) is
   begin
      raise Program_Error;  --  Should be overrided
   end Insert;

end Regions;
