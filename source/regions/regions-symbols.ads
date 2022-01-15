--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

package Regions.Symbols is
   pragma Pure;

   type Symbol is mod 2 ** 32;
   --  Symbol is case-insensitive representation of identifiers, operators
   --  and character literals

end Regions.Symbols;
