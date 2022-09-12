--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Regions.Contexts;

private with Ada.Containers;
private with Regions.Shared_Lists;
private with Regions.Shared_Hashed_Maps;

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

   --  not overriding  <-- ERROR on GCC 12 :(
   function Region (Self : in out Entity) return Region_Access
     with Pre'Class => Entity'Class (Self).Has_Region;

   type Entity_Kind is
     (A_Subtype,
      An_Exception,
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
      Name   : Regions.Contexts.Selected_Entity_Name);

   type Entity (Env : not null Environment_Access) is abstract tagged limited
   record
      Name : Regions.Contexts.Selected_Entity_Name;
   end record;

   not overriding procedure Insert
     (Self   : in out Entity;
      Symbol : Regions.Symbol;
      Name   : Regions.Contexts.Selected_Entity_Name);
   --  I want it to be abstract

   not overriding function Clone (Self : Entity) return Entity'Class is
      (raise Program_Error);

   not overriding function Region (Self : in out Entity) return Region_Access
     is (null);

   function Selected_Name (Self : Entity'Class)
     return Regions.Contexts.Selected_Entity_Name is (Self.Name);

   package Entity_Name_Lists is new Regions.Shared_Lists
     (Regions.Contexts.Selected_Entity_Name,
      Regions.Contexts."=");

   function Hash (Value : Regions.Symbol) return Ada.Containers.Hash_Type is
     (Ada.Containers.Hash_Type'Mod (Value));

   package Name_Maps is new Regions.Shared_Hashed_Maps
     (Regions.Symbol,
      Entity_Name_Lists.List,
      Ada.Containers.Hash_Type,
      Change_Count,
      Hash,
      "=",
      Entity_Name_Lists."=");

   Region_Version : aliased Change_Count := 0;
   --  Move this to env/context???

   type Entity_With_Region is abstract new Entity with record
      Region : aliased Embedded_Region :=
        (Entity => Entity_With_Region'Unchecked_Access);

      Names  : Name_Maps.Map := Name_Maps.Empty_Map (Region_Version'Access);
   end record;

   overriding function Has_Region (Self : Entity_With_Region) return Boolean
     is (True);

   overriding function Region (Self : in out Entity_With_Region)
     return Region_Access
       is (Self.Region'Unchecked_Access);

   overriding function Immediate_Visible
     (Self   : Entity_With_Region;
      Symbol : Regions.Symbol) return Entity_Access_Array;

   overriding procedure Insert
     (Self   : in out Entity_With_Region;
      Symbol : Regions.Symbol;
      Name   : Regions.Contexts.Selected_Entity_Name);

end Regions.Entities;
