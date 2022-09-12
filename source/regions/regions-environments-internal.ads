--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Regions.Contexts;

package Regions.Environments.Internal is
   pragma Preelaborate;

   function Get_Entity
     (Self : Environment'Class;
      Name : Regions.Contexts.Selected_Entity_Name)
      return Entity_Access with Inline;

   function Get_For_Update
     (Self : in out Environment'Class;
      Name : Regions.Contexts.Selected_Entity_Name)
      return Entity_Access with Inline;
   --  Create a copy of an enity, put it into environment.

end Regions.Environments.Internal;
