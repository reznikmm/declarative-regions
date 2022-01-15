--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

private with Ada.Finalization;

package Regions.Contexts.Environments is

   pragma Preelaborate;

   type Environment is tagged private;

   --  function Use_Visible
   --  function Directly_Visible

private

   type Environment_Interface is limited interface;

   not overriding procedure Rerference
     (Self : in out Environment_Interface) is abstract;

   not overriding procedure Unreference
     (Self : in out Environment_Interface;
      Last : out Boolean) is abstract;

   type Environment_Interface_Access is
     access all Environment_Interface'Class;

   type Environment is new Ada.Finalization.Controlled with record
      Data : Environment_Interface_Access;
   end record;

   overriding procedure Adjust (Self : in out Environment);

   overriding procedure Finalize (Self : in out Environment);

end Regions.Contexts.Environments;
