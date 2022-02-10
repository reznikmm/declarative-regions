--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Unchecked_Deallocation;

with Regions.Contexts.Environments.Nodes;

package body Regions.Contexts.Environments is

   procedure Free is new Ada.Unchecked_Deallocation
     (Regions.Contexts.Environments.Nodes.Environment_Node'Class,
      Environment_Node_Access);

   type Region_Cursor is new Regions.Entity_Cursor with record
      Item   : Selected_Entity_Name_Lists.Cursor;
   end record;

   type Region_Iterator is
     new Regions.Entity_Iterator_Interfaces.Forward_Iterator with record
      Data : Environment_Node_Access;
   end record;

   overriding function First (Self : Region_Iterator)
     return Regions.Entity_Cursor_Class;

   overriding function Next
     (Self   : Region_Iterator;
      Cursor : Regions.Entity_Cursor_Class)
        return Regions.Entity_Cursor_Class;

   ------------
   -- Adjust --
   ------------

   procedure Adjust (Self : in out Environment) is
   begin
      Self.Data.Reference;
   end Adjust;

   --------------
   -- Finalize --
   --------------

   procedure Finalize (Self : in out Environment) is
      Last : Boolean;
   begin
      Self.Data.Unreference (Last);

      if Last then
         Free (Self.Data);
      end if;
   end Finalize;

   -----------
   -- First --
   -----------

   overriding function First (Self : Region_Iterator)
     return Regions.Entity_Cursor_Class
   is
      Cursor : constant Selected_Entity_Name_Lists.Cursor :=
        Self.Data.Nested.Iterate.First;
   begin
      if Selected_Entity_Name_Lists.Has_Element (Cursor) then
         return Region_Cursor'
           (Entity => Self.Data.Get_Entity (Self.Data.Nested (Cursor)),
            Left   => Self.Data.Nested.Length - 1,
            Item   => Cursor);
      else
         return Region_Cursor'(null, 0, Cursor);
      end if;
   end First;

   --------------------
   -- Nested_Regions --
   --------------------

   function Nested_Regions (Self : Environment'Class)
     return Regions.Entity_Iterator_Interfaces.Forward_Iterator'Class
   is
   begin
      return Region_Iterator'(Data => Self.Data);
   end Nested_Regions;

   ----------
   -- Next --
   ----------

   overriding function Next
     (Self   : Region_Iterator;
      Cursor : Regions.Entity_Cursor_Class)
      return Regions.Entity_Cursor_Class
   is
      Next : constant Selected_Entity_Name_Lists.Cursor :=
        Self.Data.Nested.Iterate.Next (Region_Cursor (Cursor).Item);
   begin
      if Selected_Entity_Name_Lists.Has_Element (Next) then
         return Region_Cursor'
           (Entity => Self.Data.Get_Entity (Self.Data.Nested (Next)),
            Left   => Self.Data.Nested.Length - 1,
            Item   => Next);
      else
         return Region_Cursor'(null, 0, Selected_Entity_Name_Lists.No_Element);
      end if;
   end Next;

end Regions.Contexts.Environments;
