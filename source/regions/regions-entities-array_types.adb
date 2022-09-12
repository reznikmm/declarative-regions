--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

package body Regions.Entities.Array_Types is

   -----------------
   -- Set_Element --
   -----------------

   procedure Set_Element
     (Self    : in out Array_Type_Entity;
      Element : Regions.Contexts.Selected_Entity_Name) is
   begin
      Self.Element := Element;
   end Set_Element;

end Regions.Entities.Array_Types;
