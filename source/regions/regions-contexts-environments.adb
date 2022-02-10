--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Unchecked_Deallocation;

with Regions.Contexts.Environments.Nodes;

package body Regions.Contexts.Environments is

   procedure Free is new Ada.Unchecked_Deallocation
     (Regions.Contexts.Environments.Nodes.Environment_Node'Class,
      Environment_Node_Access);

   ------------
   -- Adjust --
   ------------

   procedure Adjust (Self : in out Environment) is
   begin
      Self.Data.Reference;
   end Adjust;

   --------------
   -- Finalize --
   --------------

   procedure Finalize (Self : in out Environment) is
      Last : Boolean;
   begin
      Self.Data.Unreference (Last);

      if Last then
         Free (Self.Data);
      end if;
   end Finalize;

end Regions.Contexts.Environments;
