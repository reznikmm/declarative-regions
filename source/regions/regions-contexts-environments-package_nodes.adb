--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

package body Regions.Contexts.Environments.Package_Nodes is

   type Entity_Cursor is new Regions.Entities.Entity_Cursor with record
      List_Cursor : Selected_Entity_Name_Lists.Cursor;
   end record;

   type Entity_Iterator
     (Env  : not null Regions.Contexts.Environments.Environment_Node_Access)
   is new Regions.Entities.Entity_Iterator with record
      List : Selected_Entity_Name_Lists.List;
   end record;

   overriding function First (Self : Entity_Iterator)
     return Regions.Entities.Entity_Cursor_Class;

   overriding function Next
     (Self   : Entity_Iterator;
      Cursor : Regions.Entities.Entity_Cursor_Class)
        return Regions.Entities.Entity_Cursor_Class;

   ---------------
   -- Empty_Map --
   ---------------

   function Empty_Map (Self : access Package_Node) return Name_List_Maps.Map is
   begin
      return Name_List_Maps.Empty_Map (Self.Version'Access);
   end Empty_Map;

   -----------
   -- First --
   -----------

   overriding function First (Self : Entity_Iterator)
     return Regions.Entities.Entity_Cursor_Class
   is
      First : constant Selected_Entity_Name_Lists.Cursor :=
        Self.List.Iterate.First;
   begin
      if Selected_Entity_Name_Lists.Has_Element (First) then
         return Entity_Cursor'
           (Entity      => Self.Env.Get_Entity (Self.List (First)),
            List_Cursor => First,
            Left        => Self.List.Length);
      else
         return Result : Entity_Cursor (Entity => null, Left => 0);
      end if;
   end First;

   -----------------------
   -- Immediate_Visible --
   -----------------------

   overriding function Immediate_Visible
     (Self   : Package_Entity;
      Symbol : Symbols.Symbol)
        return Entities.Entity_Iterator'Class is (raise Program_Error);

   --------------------------------
   -- Immediate_Visible_Backward --
   --------------------------------

   overriding function Immediate_Visible_Backward
     (Self   : Package_Entity;
      Symbol : Symbols.Symbol)
        return Entities.Entity_Iterator'Class is

      Node : Package_Node renames
        Package_Node (Self.Env.Nodes.Element (Self.Name).all);
   begin
      if Node.Names.Contains (Symbol) then
         declare
            List : constant Selected_Entity_Name_Lists.List :=
              Node.Names.Element (Symbol);
         begin
            return Entity_Iterator'(Self.Env, List);
         end;
      else
         return Entity_Iterator'
           (Self.Env,
            Selected_Entity_Name_Lists.Empty_List);
      end if;
   end Immediate_Visible_Backward;

   ----------
   -- Next --
   ----------

   overriding function Next
     (Self   : Entity_Iterator;
      Cursor : Regions.Entities.Entity_Cursor_Class)
        return Regions.Entities.Entity_Cursor_Class is
   begin
      if Cursor.Left = 0 then
         return Result : Entity_Cursor (Entity => null, Left => 0);
      else
         declare
            Value : Entity_Cursor renames Entity_Cursor (Cursor);
            Next  : constant Selected_Entity_Name_Lists.Cursor :=
              Self.List.Iterate.Next (Value.List_Cursor);
         begin
            return Entity_Cursor'
              (Entity      => Self.Env.Get_Entity (Self.List (Next)),
               List_Cursor => Next,
               Left        => Cursor.Left - 1);
         end;
      end if;
   end Next;

end Regions.Contexts.Environments.Package_Nodes;
