--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0
-------------------------------------------------------------

with Regions.Entities.Roots;
with Regions.Contexts;

package body Regions.Environments.Factory is

   type Context_Access is access all Regions.Contexts.Context'Class;

   --------------------
   -- Create_Package --
   --------------------

   procedure Create_Package
     (Self   : in out Environment;
      Symbol : Regions.Symbol) is
   begin
      null;
   end Create_Package;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
     (Self     : in out Environment;
      Standard : Symbol)
   is
      Root : Entity_Access :=
        new Regions.Entities.Entity'Class'
          (Regions.Entities.Roots.Create (Self'Unchecked_Access, Standard));
   begin
      if Context = null then
         declare
            Object : constant Context_Access := new Regions.Contexts.Context;
         begin
            Context := Regions.Context_Access (Object);
         end;
      end if;

      Self.Entity_Map.Insert (Context.Root_Name, Root);
   end Initialize;

end Regions.Environments.Factory;
