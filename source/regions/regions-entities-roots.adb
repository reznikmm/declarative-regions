pragma Warnings (Off);
with Regions.Environments;
pragma Warnings (On);

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

   ------------
   -- Insert --
   ------------

   overriding procedure Insert
     (Self   : in out Root_Entity;
      Symbol : Regions.Symbol;
      Entity : Entity_Access;
      Name   : out Regions.Contexts.Selected_Entity_Name) is
   begin
      if Symbol = Self.Standard then
         Name := Self.Env.Context.New_Selected_Name
           (Self.Env.Context.Root_Name,
            Self.Env.Context.New_Entity_Name (Symbol));
      else
         raise Program_Error;
      end if;
   end Insert;

end Regions.Entities.Roots;
