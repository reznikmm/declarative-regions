--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Unchecked_Deallocation;

package body Regions.Contexts.Environments is

   procedure Free is new Ada.Unchecked_Deallocation
     (Environment_Interface'Class, Environment_Interface_Access);

   ------------
   -- Adjust --
   ------------

   overriding procedure Adjust (Self : in out Environment) is
   begin
      Self.Data.Rerference;
   end Adjust;

   --------------
   -- Finalize --
   --------------

   overriding procedure Finalize (Self : in out Environment) is
      Last : Boolean;
   begin
      Self.Data.Unreference (Last);

      if Last then
         Free (Self.Data);
      end if;
   end Finalize;

end Regions.Contexts.Environments;
