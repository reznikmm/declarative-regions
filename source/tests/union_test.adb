with Regions.Shared_Hashed_Maps;

procedure Union_Test is
   type Hash_Type is mod 2 ** 64;

   function Hash (X : Hash_Type) return Hash_Type is (X);

   package Maps is new Regions.Shared_Hashed_Maps
     (Hash_Type, Integer, Hash_Type, Hash_Type, Hash, "=", "=");

   Version : aliased Hash_Type := 1;

   L, R, X : Maps.Map := Maps.Empty_Map (Version'Access);
begin
   --  L.Length = 0 and R.Length = 0, L.Hash = R.Hash
   L.Insert (8#00_11_22#, 1);
   --  L.Length = 0 and R.Length /= 0, L in R, reuse R
   L.Insert (8#00_00_26#, 1);
   --  L.Length = 0 and R.Length /= 0, L in R, L changed in R, reuse R
   L.Insert (8#00_00_27#, 1);
   --  L.Length = 0 and R.Length /= 0, L in R, L changed in R, no-reuse R
   L.Insert (8#00_00_30#, 1);
   --  L.Mask = R.Mask, reuse L
   L.Insert (8#00_00_31#, 1);
   L.Insert (8#00_01_31#, 1);
   --  L.Mask = R.Mask, reuse R
   L.Insert (8#00_00_32#, 1);
   L.Insert (8#00_01_32#, 1);
   --  L.Mask = (L.Mask or R.Mask), reuse L
   L.Insert (8#00_00_33#, 1);
   L.Insert (8#00_01_33#, 1);
   --  L.Mask = (L.Mask or R.Mask), no-reuse L
   L.Insert (8#00_00_34#, 1);
   L.Insert (8#00_01_34#, 1);
   --  L.Mask /= R.Mask
   L.Insert (8#00_00_35#, 1);
   R := L;
   Version := Version + 1;
   --  L.Length = 0 and R.Length = 0, L.Hash /= R.Hash, L_Bit /= R_Bit
   L.Insert (8#00_11_23#, 2);
   --  L.Length = 0 and R.Length = 0, L.Hash /= R.Hash, L_Bit = R_Bit
   L.Insert (8#11_00_24#, 2);
   --  L.Length = 0 and R.Length /= 0, No L in R
   L.Insert (8#00_00_25#, 2);
   L.Insert (8#00_00_30#, 2);
   L.Insert (8#00_00_31#, 2);
   L.Insert (8#00_01_31#, 2);
   L.Insert (8#00_02_33#, 2);
   L.Insert (8#00_02_34#, 2);
   L.Insert (8#00_01_35#, 2);
   Version := Version + 1;

   R.Insert (8#00_11_22#, 3);
   R.Insert (8#00_12_23#, 3);
   R.Insert (8#12_00_24#, 3);
   R.Insert (8#00_01_25#, 3);
   R.Insert (8#00_02_25#, 3);
   R.Insert (8#00_01_26#, 3);
   R.Insert (8#00_00_27#, 3);
   R.Insert (8#00_01_27#, 3);
   R.Insert (8#00_01_30#, 3);
   R.Insert (8#00_00_32#, 3);
   R.Insert (8#00_01_32#, 3);
   R.Insert (8#00_00_34#, 3);
   R.Insert (8#00_02_35#, 3);
   X := Maps.Union (L, R);

   pragma Assert (X.Element (8#00_11_22#) = 3);
   pragma Assert (X.Element (8#00_11_23#) = 2);
   pragma Assert (X.Element (8#00_12_23#) = 3);
   pragma Assert (X.Element (8#11_00_24#) = 2);
   pragma Assert (X.Element (8#12_00_24#) = 3);
   pragma Assert (X.Element (8#00_00_25#) = 2);
   pragma Assert (X.Element (8#00_01_25#) = 3);
   pragma Assert (X.Element (8#00_02_25#) = 3);
   pragma Assert (X.Element (8#00_00_26#) = 1);
   pragma Assert (X.Element (8#00_01_26#) = 3);
   pragma Assert (X.Element (8#00_00_27#) = 3);
   pragma Assert (X.Element (8#00_01_27#) = 3);
   pragma Assert (X.Element (8#00_00_30#) = 2);
   pragma Assert (X.Element (8#00_01_30#) = 3);
   pragma Assert (X.Element (8#00_00_31#) = 2);
   pragma Assert (X.Element (8#00_01_31#) = 2);
   pragma Assert (X.Element (8#00_00_32#) = 3);
   pragma Assert (X.Element (8#00_01_32#) = 3);
   pragma Assert (X.Element (8#00_00_33#) = 1);
   pragma Assert (X.Element (8#00_01_33#) = 1);
   pragma Assert (X.Element (8#00_02_33#) = 2);
   pragma Assert (X.Element (8#00_00_34#) = 3);
   pragma Assert (X.Element (8#00_01_34#) = 1);
   pragma Assert (X.Element (8#00_02_34#) = 2);
   pragma Assert (X.Element (8#00_00_35#) = 1);
   pragma Assert (X.Element (8#00_01_35#) = 2);
   pragma Assert (X.Element (8#00_02_35#) = 3);
end Union_Test;
