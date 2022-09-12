--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Regions.Contexts;
pragma Warnings (Off);
with Regions.Environments;
pragma Warnings (On);

package Regions.Entities.Roots is
   pragma Preelaborate;

   type Root_Entity is new Entity with private;

   function Create
     (Env      : Environment_Access;
      Standard : Symbol) return Entity'Class with Inline;

private

   type Root_Entity is new Entity with record
      Region : aliased Embedded_Region :=
        (Entity => Root_Entity'Unchecked_Access);

      Standard : Symbol;
   end record;

   overriding function Kind (Self : Root_Entity) return Entity_Kind
     is (A_Package);   --  ???

   overriding function Has_Region (Self : Root_Entity) return Boolean
     is (True);
   --  ??? root region doesn't have a corresponding entity

   overriding function Region (Self : in out Root_Entity) return Region_Access
     is (Self.Region'Unchecked_Access);

   overriding function Is_Overloadable (Self : Root_Entity) return Boolean
     is (False);

   overriding procedure Insert
     (Self   : in out Root_Entity;
      Symbol : Regions.Symbol;
      Name   : Regions.Contexts.Selected_Entity_Name);

   overriding function Immediate_Visible
     (Self   : Root_Entity;
      Symbol : Regions.Symbol) return Entity_Access_Array is
       (if Symbol = Self.Standard
        then (1 => Get_Entity
                     (Self.Env,
                      Self.Env.Context.New_Selected_Name
                        (Self.Env.Context.Root_Name,
                         Self.Env.Context.New_Entity_Name (Symbol))))
        else (1 .. 0 => null));

end Regions.Entities.Roots;
