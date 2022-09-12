--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

package body Regions.Environments is

   --------------------
   -- Nested_Regions --
   --------------------

   function Nested_Regions
     (Self : Environment'Class) return Regions.Region_Access_Array
   is
   begin
      return Result : Region_Access_Array (1 .. Self.Nested.Length) do
         for J in Self.Nested.Iterate loop
            declare
               Entity : constant Entity_Access :=
                 Self.Entity_Map.Element (Self.Nested (J));
            begin
               Result (Entity_Name_Lists.To_Index (J)) := Entity.Region;
            end;
         end loop;
      end return;
   end Nested_Regions;

end Regions.Environments;
