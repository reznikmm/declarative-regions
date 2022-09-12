--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

package body Regions.Entities is

   function Clone (Self : Entity'Class) return Entity_Access is
      (new Entity'Class'(Self.Clone));

   -----------------------
   -- Immediate_Visible --
   -----------------------

   overriding function Immediate_Visible
     (Self   : Entity_With_Region;
      Symbol : Regions.Symbol) return Entity_Access_Array is
   begin
      if Self.Names.Contains (Symbol) then
         declare
            List  : constant Entity_Name_Lists.List :=
              Self.Names.Element (Symbol);
            Index : Natural := List.Length;
         begin
            return Result : Entity_Access_Array (1 .. List.Length) do
               for Item of List loop
                  Result (Index) := Get_Entity (Self.Env, Item);
                  Index := Index - 1;
               end loop;
            end return;
         end;
      else
         return (1 .. 0 => null);
      end if;
   end Immediate_Visible;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      Regions.Clone := Clone'Access;
   end Initialize;

   ------------
   -- Insert --
   ------------

   not overriding procedure Insert
     (Self   : in out Entity;
      Symbol : Regions.Symbol;
      Name   : Regions.Contexts.Selected_Entity_Name) is
   begin
      raise Program_Error;  --  Should be overrided
   end Insert;

   ------------
   -- Insert --
   ------------

   overriding procedure Insert
     (Self   : in out Embedded_Region;
      Symbol : Regions.Symbol;
      Name   : Regions.Contexts.Selected_Entity_Name) is
   begin
      Self.Entity.Insert (Symbol, Name);
   end Insert;

   ------------
   -- Insert --
   ------------

   overriding procedure Insert
     (Self   : in out Entity_With_Region;
      Symbol : Regions.Symbol;
      Name   : Regions.Contexts.Selected_Entity_Name)
   is
      List : Entity_Name_Lists.List;
   begin
      if Self.Names.Contains (Symbol) then
         List := Self.Names.Element (Symbol);
      end if;

      List.Prepend (Name);
      Self.Names.Insert (Symbol, List);
   end Insert;

end Regions.Entities;
