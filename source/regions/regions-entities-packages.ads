--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

--  with Regions.Symbols;

package Regions.Entities.Packages is
   pragma Pure;

   type Package_Entity is limited interface
     and Regions.Entities.Entity
     and Regions.Region;

   type Package_Access is access all Package_Entity'Class
     with Storage_Size => 0;

   --  overriding procedure Append
   --    (Self   : in out Package_Entity;
   --     Symbol : Symbols.Symbol;
   --     Entity : Entities.Entity_Access);
   --
end Regions.Entities.Packages;
