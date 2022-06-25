--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0
-------------------------------------------------------------

with Regions.Contexts;

package body Regions.Entities is

   ------------
   -- Insert --
   ------------

   overriding procedure Insert
     (Self   : in out Embedded_Region;
      Symbol : Regions.Symbol;
      Entity : Entity_Access;
      Name   : out Regions.Contexts.Selected_Entity_Name)
   is
   begin
      Self.Entity.Insert (Symbol, Entity, Name);
   end Insert;

end Regions.Entities;
