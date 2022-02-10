--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

package Regions.Entities is
   pragma Pure;

   type Entity is limited interface;

   function Is_Assigned (Self : access Entity'Class) return Boolean
     is (Self /= null);

   not overriding function Is_Package (Self : Entity) return Boolean
     is abstract;

   type Entity_Access is access all Entity'Class
     with Storage_Size => 0;

end Regions.Entities;
