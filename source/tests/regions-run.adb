--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Wide_Wide_Text_IO;

with Regions.Tests;

procedure Regions.Run is
begin
   Regions.Tests.Test_Standard;
   Ada.Wide_Wide_Text_IO.Put_Line ("Hello!");
end Regions.Run;
