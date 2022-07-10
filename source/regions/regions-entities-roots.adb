--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

pragma Warnings (Off);
with Regions.Environments;
pragma Warnings (On);

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
      Parent : Regions.Contexts.Selected_Entity_Name;
      Name   : out Regions.Contexts.Selected_Entity_Name)
   is
      use type Regions.Contexts.Selected_Entity_Name;
   begin
      if Symbol = Self.Standard then
         pragma Assert (Parent = Self.Env.Context.Root_Name);

         Name := Self.Env.Context.New_Selected_Name
           (Parent,
            Self.Env.Context.New_Entity_Name (Symbol));
      else
         raise Program_Error;
      end if;
   end Insert;

end Regions.Entities.Roots;
