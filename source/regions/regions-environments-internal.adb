--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0
-------------------------------------------------------------

package body Regions.Environments.Internal is

   ----------------
   -- Get_Entity --
   ----------------

   function Get_Entity
     (Self : Environment'Class;
      Name : Regions.Contexts.Selected_Entity_Name)
      return Entity_Access is
   begin
      return Self.Entity_Map.Element (Name);
   end Get_Entity;

   --------------------
   -- Get_For_Update --
   --------------------

   function Get_For_Update
     (Self : in out Environment'Class;
      Name : Regions.Contexts.Selected_Entity_Name)
      return Entity_Access is
   begin
      if Self.Entity_Map.Is_Shared (Name) then
         return Result : Entity_Access := Self.Entity_Map.Element (Name) do
            Result := Regions.Clone (Result.all);
            Self.Entity_Map.Insert (Name, Result);
         end return;
      else
         return Self.Entity_Map.Element (Name);
      end if;
   end Get_For_Update;

end Regions.Environments.Internal;
