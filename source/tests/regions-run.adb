--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Wide_Wide_Text_IO;
with Regions.Environments.Factory;

procedure Regions.Run is
   Env : Regions.Environments.Environment;
begin
   Regions.Environments.Factory.Initialize (Env);
   Ada.Wide_Wide_Text_IO.Put_Line ("Hello!");
end Regions.Run;
