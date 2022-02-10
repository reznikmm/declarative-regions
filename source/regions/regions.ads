--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Iterator_Interfaces;

limited with Regions.Entities;
limited with Regions.Symbols;

package Regions is
   pragma Pure;

   type Region is limited interface;

   type Entity_Cursor is abstract tagged record
      Entity : access Entities.Entity'Class;
      Left   : Natural;  --  How many entities left to iterate
   end record;

   subtype Entity_Cursor_Class is Entity_Cursor'Class;

   function Has_Element (Self : Entity_Cursor_Class) return Boolean is
     (Self.Entity /= null);

   package Entity_Iterator_Interfaces is new Ada.Iterator_Interfaces
     (Entity_Cursor_Class, Has_Element);

   --  type Entity_Iterator is limited interface and
   --    Entity_Iterator_Interfaces.Forward_Iterator;

   not overriding function Immediate_Visible_Backward
     (Self   : Region;
      Symbol : Symbols.Symbol)
        return Entity_Iterator_Interfaces.Forward_Iterator'Class is abstract;

   not overriding function Immediate_Visible
     (Self   : Region;
      Symbol : Symbols.Symbol)
        return Entity_Iterator_Interfaces.Forward_Iterator'Class is abstract;

end Regions;
