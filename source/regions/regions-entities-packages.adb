--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0
-------------------------------------------------------------

package body Regions.Entities.Packages is

   ------------
   -- Create --
   ------------

   function Create
     (Env    : Environment_Access;
      Symbol : Regions.Symbol) return Entity'Class
   is
      pragma Unreferenced (Symbol);
   begin
      return Result : Package_Entity (Env) do
         null;
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

end Regions.Entities.Packages;
