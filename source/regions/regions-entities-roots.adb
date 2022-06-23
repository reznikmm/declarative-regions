package body Regions.Entities.Roots is

   ------------
   -- Create --
   ------------

   function Create
     (Env      : Environment_Access;
      Standard : Symbol) return Entity'Class is
   begin
      return Result : Root_Entity (Env) do
         Result.Standard := Standard;
      end return;
   end Create;

end Regions.Entities.Roots;
