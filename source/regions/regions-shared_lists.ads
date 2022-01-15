with Ada.Finalization;
with Ada.Iterator_Interfaces;

generic
   type Element_Type is private;
   with function "=" (Left, Right : Element_Type) return Boolean is <>;

   with procedure Destroy (Value : in out Element_Type) is null;

package Regions.Shared_Lists is
   pragma Preelaborate;

   type List is tagged private
     with
       Constant_Indexing => Constant_Indexing,
       Default_Iterator  => Iterate,
       Iterator_Element  => Element_Type;

   function "=" (Left, Right : List) return Boolean;
   function Is_Empty (Self : List) return Boolean with Inline;
   function Length (Self : List) return Natural with Inline;
   function Empty_List return List with Inline;
   function First_Element (Self : List) return Element_Type
     with Pre => not Self.Is_Empty, Inline;

   procedure Prepend
     (Self : in out List;
      Item : Element_Type) with Inline;

   type Cursor is private;

   function Has_Element (Self : Cursor) return Boolean with Inline;
   --  Check if the cursor points to any element

   package Iterator_Interfaces is new Ada.Iterator_Interfaces
      (Cursor, Has_Element);

   type Forward_Iterator is new Iterator_Interfaces.Forward_Iterator
     with private;

   function Iterate (Self : List'Class) return Forward_Iterator with Inline;
   --  Iterate over all elements in the map

   function Constant_Indexing
     (Self     : List;
      Position : Cursor) return Element_Type
     with Pre => Has_Element (Position), Inline;

   No_Element : constant Cursor;

private

   type List_Node;

   type List_Node_Access is access all List_Node;

   type List_Node is record
      Next    : List_Node_Access;
      Counter : Natural;
      Data    : Element_Type;
   end record;

   type List is new Ada.Finalization.Controlled with record
      Head   : List_Node_Access;
      Length : Natural := 0;
   end record;

   overriding procedure Adjust (Self : in out List);

   overriding procedure Finalize (Self : in out List);

   type Cursor is record
      Item : List_Node_Access;
   end record;

   type Forward_Iterator is new Iterator_Interfaces.Forward_Iterator
   with record
      First : Cursor;
   end record;

   overriding function First (Self : Forward_Iterator) return Cursor;

   overriding function Next
     (Self     : Forward_Iterator;
      Position : Cursor) return Cursor;

   No_Element : constant Cursor := (Item => null);

end Regions.Shared_Lists;
