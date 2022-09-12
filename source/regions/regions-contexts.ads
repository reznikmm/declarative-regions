--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Containers.Hashed_Maps;

package Regions.Contexts is
   pragma Preelaborate;

   type Profile_Id is private;
   type Entity_Name is private;
   type Selected_Entity_Name is private;

   type Selected_Entity_Name_Array is
     array (Positive range <>) of Selected_Entity_Name;

   No_Profile : constant Profile_Id;
   --  To create an non-overloadable entity (without any profile)

   function Hash (List : Selected_Entity_Name) return Ada.Containers.Hash_Type;

   type Context is tagged limited private;

   -----------------------
   --  Profile creation --
   -----------------------

   function Empty_Procedure_Profile (Self : Context) return Profile_Id;
   --  Return profile for a procedure without arguments

   function Empty_Function_Profile
     (Self        : in out Context;
      Return_Type : Selected_Entity_Name) return Profile_Id;
   --  Return profile for a function without arguments returning a given type

   function Empty_Function_Profile
     (Self           : in out Context;
      Return_Profile : Profile_Id) return Profile_Id;
   --  Return profile for a function without arguments returning an access
   --  to subprogram

   function Append_Parameter
     (Self      : in out Context;
      Origin    : Profile_Id;
      Type_Name : Selected_Entity_Name) return Profile_Id;
      --  Mode|Access???

   function Append_Parameter
     (Self       : in out Context;
      Origin     : Profile_Id;
      Subprogram : Profile_Id) return Profile_Id;

   ---------------------------
   --  Entity_Name creation --
   ---------------------------

   function New_Entity_Name
     (Self   : in out Context;
      Symbol : Regions.Symbol) return Entity_Name;

   function New_Entity_Name
     (Self    : in out Context;
      Symbol  : Regions.Symbol;
      Profile : Profile_Id) return Entity_Name;

   ------------------------------------
   --  Selected_Entity_Name creation --
   ------------------------------------

   function Root_Name (Self : Context) return Selected_Entity_Name;
   --  Return Name of an artifical entity containing Standard package

   function New_Selected_Name
     (Self     : in out Context;
      Prefix   : Selected_Entity_Name;
      Selector : Entity_Name) return Selected_Entity_Name;

private

   type Profile_Id is new Natural;
   type Entity_Name is new Natural;
   type Selected_Entity_Name is new Natural;

   No_Profile : constant Profile_Id := 0;
   --  To create an non-overloadable entity (without any profile)

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
      Symbol  : Regions.Symbol;
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
      Last_Selected : Selected_Entity_Name := Root_Name (Context);
      Last_Profile  : Profile_Id := Empty_Procedure_Profile (Context);
   end record;

   function Hash (List : Selected_Entity_Name) return Ada.Containers.Hash_Type
     is (Ada.Containers.Hash_Type'Mod (List));

end Regions.Contexts;
