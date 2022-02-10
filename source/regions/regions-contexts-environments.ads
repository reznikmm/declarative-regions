--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

private with Ada.Finalization;
private with Regions.Shared_Lists;
limited private with Regions.Contexts.Environments.Nodes;

package Regions.Contexts.Environments is

   pragma Preelaborate;

   type Environment is tagged private;

   --  function Use_Visible
   --  function Directly_Visible

   function Nested_Regions (Self : Environment'Class)
     return Regions.Entity_Iterator_Interfaces.Forward_Iterator'Class;

private

   type Environment_Node_Access is
     access all Regions.Contexts.Environments.Nodes.Environment_Node'Class;

   type Environment is new Ada.Finalization.Controlled with record
      Data : Environment_Node_Access;
   end record;

   overriding procedure Adjust (Self : in out Environment);

   overriding procedure Finalize (Self : in out Environment);

   package Selected_Entity_Name_Lists is
     new Regions.Shared_Lists (Selected_Entity_Name);

end Regions.Contexts.Environments;
