--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0
-------------------------------------------------------------

package body Regions.Entities is

   function Clone (Self : Entity'Class) return Entity_Access is
      (new Entity'Class'(Self.Clone));

   procedure Set_Name
     (Self : in out Regions.Entities.Entity'Class;
      Name : Regions.Contexts.Selected_Entity_Name);

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      Regions.Clone := Clone'Access;
      Regions.Set_Name := Set_Name'Access;
   end Initialize;

   ------------
   -- Insert --
   ------------

   not overriding procedure Insert
     (Self   : in out Entity;
      Symbol : Regions.Symbol;
      Parent : Regions.Contexts.Selected_Entity_Name;
      Name   : out Regions.Contexts.Selected_Entity_Name) is
   begin
      raise Program_Error;  --  Should be overrided
   end Insert;

   ------------
   -- Insert --
   ------------

   overriding procedure Insert
     (Self   : in out Embedded_Region;
      Symbol : Regions.Symbol;
      Parent : Regions.Contexts.Selected_Entity_Name;
      Name   : out Regions.Contexts.Selected_Entity_Name)
   is
   begin
      Self.Entity.Insert (Symbol, Parent, Name);
   end Insert;

   --------------
   -- Set_Name --
   --------------

   procedure Set_Name
     (Self : in out Regions.Entities.Entity'Class;
      Name : Regions.Contexts.Selected_Entity_Name) is
   begin
      Self.Name := Name;
   end Set_Name;
end Regions.Entities;
