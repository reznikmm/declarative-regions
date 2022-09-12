--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
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

   ------------------
   -- Get_Entities --
   ------------------

   function Get_Entities
     (Env   : Environment_Access;
      Names : Regions.Contexts.Selected_Entity_Name_Array)
      return Entity_Access_Array is
   begin
      return Result : Entity_Access_Array (Names'Range) do
         for J in Result'Range loop
            Result (J) := Get_Entity (Env, Names (J));
         end loop;
      end return;
   end Get_Entities;

   --------------------
   -- Get_For_Update --
   --------------------

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
      Name   : Regions.Contexts.Selected_Entity_Name) is
   begin
      raise Program_Error;  --  Should be overrided
   end Insert;

end Regions;
