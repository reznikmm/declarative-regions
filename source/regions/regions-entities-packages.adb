--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0
-------------------------------------------------------------

pragma Warnings (Off);
with Regions.Environments;
pragma Warnings (On);

package body Regions.Entities.Packages is

   -----------
   -- Clone --
   -----------

   overriding function Clone (Self : Package_Entity) return Entity'Class is
   begin
      return Result : Package_Entity :=
        (Env    => Self.Env,
         Name   => Self.Name,
         Names  => Self.Names,
         Region => (Entity => null))
      do
         Result.Region.Entity := Result'Unchecked_Access;
      end return;
   end Clone;

   ------------
   -- Create --
   ------------

   function Create (Env : Environment_Access) return Entity'Class is
   begin
      return Result : Package_Entity (Env) do
         Result.Region.Entity := Result'Unchecked_Access;
      end return;
   end Create;

   -----------------------
   -- Immediate_Visible --
   -----------------------

   overriding function Immediate_Visible
     (Self   : Package_Entity;
      Symbol : Regions.Symbol)
      return Entity_Access_Array
   is
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

   ------------
   -- Insert --
   ------------

   overriding procedure Insert
     (Self   : in out Package_Entity;
      Symbol : Regions.Symbol;
      Parent : Regions.Contexts.Selected_Entity_Name;
      Name   : out Regions.Contexts.Selected_Entity_Name)
   is
      List : Entity_Name_Lists.List;
   begin
      Name := Self.Env.Context.New_Selected_Name
        (Parent, Self.Env.Context.New_Entity_Name (Symbol));

      if Self.Names.Contains (Symbol) then
         List := Self.Names.Element (Symbol);
      end if;

      List.Prepend (Name);
      Self.Names.Insert (Symbol, List);
   end Insert;

end Regions.Entities.Packages;
