--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0
-------------------------------------------------------------

private with Regions.Contexts;

package Regions.Entities.Roots is
   pragma Preelaborate;

   type Root_Entity is new Entity with private;

   function Create
     (Env      : Environment_Access;
      Standard : Symbol) return Entity'Class with Inline;

private

   type Root_Entity is new Entity with record
      Standard : Symbol;
   end record;

   overriding function Has_Region (Self : Root_Entity) return Boolean
     is (False);
   --  To pretend that root region doesn't have a corresponding entity

   overriding function Immediate_Visible
     (Self   : Root_Entity;
      Symbol : Regions.Symbol) return Entity_Access_Array is
       (if Symbol = Self.Standard
        then (1 => Get_Entity
                     (Self.Env,
                      Context.New_Selected_Name
                        (Context.Root_Name, Context.New_Entity_Name (Symbol))))
        else (1 .. 0 => null));

end Regions.Entities.Roots;
