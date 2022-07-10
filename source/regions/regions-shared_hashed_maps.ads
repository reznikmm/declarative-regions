with Ada.Finalization;
with Ada.Iterator_Interfaces;

generic
   type Key_Type is private;
   type Element_Type is private;
   type Hash_Type is mod <>;
   type Change_Count is mod <>;

   with function Hash (Key : Key_Type) return Hash_Type;
   with function Equivalent_Keys (Left, Right : Key_Type) return Boolean;
   with function "=" (Left, Right : Element_Type) return Boolean is <>;

   with procedure Destroy (Value : in out Element_Type) is null;

package Regions.Shared_Hashed_Maps is
   pragma Preelaborate;

   type Map is tagged private
     with Constant_Indexing => Constant_Indexing,
       Variable_Indexing => Variable_Indexing,
       Default_Iterator => Iterate,
       Iterator_Element => Element_Type;

   function "=" (Left : Map; Right : Map) return Boolean;
   --  Compare two maps. This is fast ifone was copied from another.

   function Empty_Map (Active : not null access Change_Count) return Map;
   --  Return an empty map object

   procedure Insert
     (Self : in out Map;
      Key  : Key_Type;
      Item : Element_Type);
   --  Insert (or replace) an item with given Key into the map

   function Contains (Self : Map; Key : Key_Type) return Boolean;
   --  Check if the map contain given key

   function Element (Self : Map; Key : Key_Type) return Element_Type;
   --  Return item by key

   function Is_Shared (Self : Map; Key : Key_Type) return Boolean;
   --  with Pre => Self.Contains (Key)
   --  Return True if Self.Insert (Key, ...) witll create a copy of value

   function Union (Left, Right : Map'Class) return Map;
   --  Merge all elements of Left and Right. For elements presented in both
   --  maps, keep an element with greater change count.

   type Cursor is private;

   function Has_Element (Self : Cursor) return Boolean;
   --  Check if the cursor points to any element

   package Iterator_Interfaces is new Ada.Iterator_Interfaces
      (Cursor, Has_Element);

   type Forward_Iterator is new Iterator_Interfaces.Forward_Iterator
     with private;

   function Iterate (Self : Map'Class) return Forward_Iterator;
   --  Iterate over all elements in the map

   function Key (Self : Cursor) return Key_Type;
   --  Return key correponding to the cursor

   function To_Element (Self : Cursor) return Element_Type;
   --  Return Element pointed by the cursor

   type Constant_Reference (Element : access constant Element_Type) is
     null record
       with Implicit_Dereference => Element;

   function Constant_Indexing
     (Self     : Map;
      Position : Cursor) return Constant_Reference;

   type Variable_Reference (Element : access Element_Type) is null record
     with Implicit_Dereference => Element;

   function Variable_Indexing
     (Self     : in out Map;
      Position : Cursor) return Variable_Reference;

   No_Element : constant Cursor;

private

   Slit_Bits : constant := 6;
   Branches  : constant := 2 ** 6;

   type Unsigned_64 is mod 2 ** Branches;
   subtype Bit_Count is Natural range 0 .. Branches;
   subtype Bit_Index is Natural range 0 .. Branches - 1;
   type Node;

   type Node_Access is access all Node;
   type Node_Access_Array is array (Bit_Count range <>) of Node_Access;

   type Node (Length : Bit_Count) is record
      Version : Change_Count;  --  Parent.Vertion >= Child.Version
      Counter : Natural;       --  Parent.Count?

      case Length is
         when 0 =>
            Hash : Hash_Type;  --  Hash (Key)
            Key  : Key_Type;
            Item : aliased Element_Type;
         when 1 .. Branches =>
            Mask  : Unsigned_64;
            Child : Node_Access_Array (1 .. Length);
      end case;
   end record;

   type Map is new Ada.Finalization.Controlled with record
      Active : not null access Change_Count;
      Root   : Node_Access;
   end record;

   overriding procedure Adjust (Self : in out Map);

   overriding procedure Finalize (Self : in out Map);

   subtype Tree_Depth is Bit_Count range 0 .. Hash_Type'Size / Slit_Bits + 1;

   type Cursor (Length : Tree_Depth := 1) is record
      Path : Node_Access_Array (1 .. Length);
   end record;

   type Forward_Iterator is new Iterator_Interfaces.Forward_Iterator
     with record
      First : Cursor;
   end record;

   overriding function First (Self : Forward_Iterator) return Cursor;

   overriding function Next
     (Self     : Forward_Iterator;
      Position : Cursor) return Cursor;

   No_Element : constant Cursor := (Length => 0, others => <>);

end Regions.Shared_Hashed_Maps;
