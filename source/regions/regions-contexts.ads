--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

private with Ada.Containers.Hashed_Maps;

with Regions.Symbols;

package Regions.Contexts is
   pragma Preelaborate;

   type Context is tagged limited private;

   type Entity_Name is private;
   type Selected_Entity_Name is private;
   type Profile_Id is private;

   -----------------------
   --  Profile creation --
   -----------------------

   function Empty_Procedure_Profile (Self : Context) return Profile_Id;
   --  Return profile for a procedure without arguments

   procedure Empty_Function_Profile
     (Self        : in out Context;
      Return_Type : Selected_Entity_Name;
      Result      : out Profile_Id);
   --  Return profile for a function without arguments returning a given type

   procedure Empty_Function_Profile
     (Self           : in out Context;
      Return_Profile : Profile_Id;
      Result         : out Profile_Id);
   --  Return profile for a function without arguments returning an access
   --  to subprogram

   procedure Append_Parameter
     (Self      : in out Context;
      Origin    : Profile_Id;
      Type_Name : Selected_Entity_Name;
      --  Mode|Access???
      Result    : out Profile_Id);

   procedure Append_Parameter
     (Self       : in out Context;
      Origin     : Profile_Id;
      Subprogram : Profile_Id;
      Result     : out Profile_Id);

   ---------------------------
   --  Entity_Name creation --
   ---------------------------

   procedure New_Entity_Name
     (Self   : in out Context;
      Symbol : Regions.Symbols.Symbol;
      Result : out Entity_Name);

   procedure New_Entity_Name
     (Self    : in out Context;
      Symbol  : Regions.Symbols.Symbol;
      Profile : Profile_Id;
      Result  : out Entity_Name);

   ------------------------------------
   --  Selected_Entity_Name creation --
   ------------------------------------

   function Root_Name (Self : Context) return Selected_Entity_Name;
   --  Return Name of Standard's parent region

   procedure New_Selected_Name
     (Self     : in out Context;
      Prefix   : Selected_Entity_Name;
      Selector : Entity_Name;
      Result   : out Selected_Entity_Name);

private

   type Profile_Id is new Natural;
   type Entity_Name is new Natural;
   type Selected_Entity_Name is new Natural;

   No_Profile : constant Profile_Id := 0;
   --  To create an entity name without any profile

   type Profile_Kind is
     (Root_Data,
      Root_Code,
      Parameter_Data,
      Parameter_Code);

   type Profile_Key (Kind : Profile_Kind := Profile_Kind'First) is record
      case Kind is
         when Root_Data =>
            Root_Data : Selected_Entity_Name;
         when Root_Code =>
            Root_Code : Profile_Id;
         when Parameter_Data | Parameter_Code =>

            Parent    : Profile_Id;

            case Kind is
               when Regions.Contexts.Root_Data |
                    Regions.Contexts.Root_Code =>
                  null;
               when Parameter_Data =>
                  Parameter_Data : Selected_Entity_Name;
               when Parameter_Code =>
                  Parameter_Code : Profile_Id;
            end case;
      end case;
   end record;

   function Hash (Value : Profile_Key) return Ada.Containers.Hash_Type;

   package Profile_Maps is new Ada.Containers.Hashed_Maps
     (Profile_Key,
      Profile_Id,
      Hash,
      "=");

   type Entity_Name_Key is record
      Symbol  : Regions.Symbols.Symbol;
      Profile : Profile_Id;
   end record;

   function Hash (Value : Entity_Name_Key) return Ada.Containers.Hash_Type;

   package Entity_Name_Maps is new Ada.Containers.Hashed_Maps
     (Entity_Name_Key,
      Entity_Name,
      Hash,
      "=");

   type Selected_Entity_Name_Key is record
      Prefix   : Selected_Entity_Name;
      Selector : Entity_Name;
   end record;

   function Hash (Value : Selected_Entity_Name_Key)
     return Ada.Containers.Hash_Type;

   package Selected_Entity_Name_Maps is new Ada.Containers.Hashed_Maps
     (Selected_Entity_Name_Key,
      Selected_Entity_Name,
      Hash,
      "=");

   type Change_Count is mod 2**32;

   type Context is tagged limited record
      Profiles : Profile_Maps.Map;
      Names    : Entity_Name_Maps.Map;
      Selected : Selected_Entity_Name_Maps.Map;
      Version  : aliased Change_Count := 0;

      Last_Name     : Entity_Name := 0;
      Last_Selected : Selected_Entity_Name := 0;
      Last_Profile  : Profile_Id := 1;  --  Reserve Empty_Procedure_Profile
   end record;

end Regions.Contexts;
