--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Iterator_Interfaces;

package Regions.Entities is
   pragma Pure;

   type Entity is limited interface;

   function Is_Assigned (Self : access Entity'Class) return Boolean
     is (Self /= null);

   not overriding function Is_Package (Self : Entity) return Boolean
     is abstract;

   type Entity_Access is access all Entity'Class
     with Storage_Size => 0;

   type Entity_Cursor
     (Entity : access Entities.Entity'Class;
      Left   : Natural)  --  How many entities left to iterate
       is abstract tagged null record
         with Implicit_Dereference => Entity;

   subtype Entity_Cursor_Class is Entity_Cursor'Class;

   function Has_Element (Self : Entity_Cursor_Class) return Boolean is
     (Self.Entity /= null);

   package Entity_Iterator_Interfaces is new Ada.Iterator_Interfaces
     (Entity_Cursor_Class, Has_Element);

   type Entity_Iterator is limited interface and
     Entity_Iterator_Interfaces.Forward_Iterator;

end Regions.Entities;
