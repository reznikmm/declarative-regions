with Regions;
with Regions.Symbols;

package Regions.Tests is

   procedure Test_Standard;
   --  Create an empty Standard package and put into an empty environment.
   --  Find a region with Standard symbol.

   procedure Symbol_Exists
     (Region : Regions.Region'Class;
      Symbol : Regions.Symbols.Symbol;
      Expect : Boolean);
   --  Check if Region contains the Symbol.

end Regions.Tests;
