--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

limited with Regions.Entities;
limited with Regions.Symbols;

package Regions is
   pragma Pure;

   type Region is limited interface;

   not overriding function Immediate_Visible_Backward
     (Self   : Region;
      Symbol : Symbols.Symbol)
        return Entities.Entity_Iterator'Class is abstract;

   not overriding function Immediate_Visible
     (Self   : Region;
      Symbol : Symbols.Symbol)
        return Entities.Entity_Iterator'Class is abstract;

end Regions;
