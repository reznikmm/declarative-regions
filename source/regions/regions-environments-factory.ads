--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0
-------------------------------------------------------------

package Regions.Environments.Factory is

   procedure Initialize
     (Self     : in out Environment;
      Standard : Symbol);
   --  Reset Environment to an empty

   procedure Create_Package
     (Self   : in out Environment;
      Symbol : Regions.Symbol);
   --  Create an empty package and enter its declarative region

end Regions.Environments.Factory;
