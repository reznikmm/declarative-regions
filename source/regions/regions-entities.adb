--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0
-------------------------------------------------------------

with Regions.Contexts;

package body Regions.Entities is

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

end Regions.Entities;
