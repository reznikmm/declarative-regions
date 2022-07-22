--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0
-------------------------------------------------------------

with Regions.Contexts;

package Regions.Entities is
   pragma Preelaborate;

   type Entity (<>) is abstract tagged limited private;

   function Assigned (Self : access Entity'Class) return Boolean
     is (Self /= null);
   --  Check if Self /= null

   not overriding function Has_Region (Self : Entity) return Boolean
     is abstract;
   --  Check if the entity has a corresponding declarative region

   not overriding function Is_Overloadable (Self : Entity) return Boolean
     is abstract;
   --  Check if overloading is allowed for the entity

   not overriding function Immediate_Visible
     (Self   : Entity;
      Symbol : Regions.Symbol) return Entity_Access_Array is abstract;
   --  For entity wihout declarative region (e.g. enumeration type) return an
   --  empty array. Otherwise, return array of entities in the corresponding
   --  region for the given symbol in order of their declaration.

   function Region (Self : in out Entity'Class) return Region_Access
     with Pre => Self.Has_Region;

   type Entity_Kind is
     (A_Subtype,
      An_Enumeration_Literal,
      An_Enumeration_Type,
      A_Signed_Integer_Type,
      A_Floating_Point_Type,
      A_Fixed_Point_Type,
      An_Array_Type,
      A_Package);

   not overriding function Kind (Self : Entity) return Entity_Kind
     is abstract;

   function Selected_Name (Self : Entity'Class)
     return Regions.Contexts.Selected_Entity_Name;

   procedure Initialize;

private

   type Embedded_Region is new Regions.Region with null record;

   overriding procedure Insert
     (Self   : in out Embedded_Region;
      Symbol : Regions.Symbol;
      Parent : Regions.Contexts.Selected_Entity_Name;
      Name   : out Regions.Contexts.Selected_Entity_Name);

   type Entity (Env : not null Environment_Access) is abstract tagged limited
   record
      Region : aliased Embedded_Region := (Entity => Entity'Unchecked_Access);
      Name   : Regions.Contexts.Selected_Entity_Name;
   end record;

   not overriding procedure Insert
     (Self   : in out Entity;
      Symbol : Regions.Symbol;
      Parent : Regions.Contexts.Selected_Entity_Name;
      Name   : out Regions.Contexts.Selected_Entity_Name);
   --  I want it to be abstract

   not overriding function Clone (Self : Entity) return Entity'Class is
      (raise Program_Error);

   function Region (Self : in out Entity'Class) return Region_Access is
      (Self.Region'Unchecked_Access);

   function Selected_Name (Self : Entity'Class)
     return Regions.Contexts.Selected_Entity_Name is (Self.Name);

end Regions.Entities;
