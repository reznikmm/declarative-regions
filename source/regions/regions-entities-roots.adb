--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

package body Regions.Entities.Roots is

   ------------
   -- Create --
   ------------

   function Create
     (Env      : Environment_Access;
      Standard : Symbol) return Entity'Class is
   begin
      return Result : Root_Entity (Env) do
         Result.Standard := Standard;
      end return;
   end Create;

   ------------
   -- Insert --
   ------------

   overriding procedure Insert
     (Self   : in out Root_Entity;
      Symbol : Regions.Symbol;
      Name   : Regions.Contexts.Selected_Entity_Name) is
   begin
      if Symbol /= Self.Standard then
         raise Program_Error;
      end if;
   end Insert;

end Regions.Entities.Roots;
