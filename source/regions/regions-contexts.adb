pragma Ada_2012;
package body Regions.Contexts is
   pragma Warnings (Off);
   ----------------------
   -- Append_Parameter --
   ----------------------

   procedure Append_Parameter
     (Self      : in out Context; Origin : Profile_Id;
      Type_Name :        Selected_Entity_Name; Result : out Profile_Id)
   is
   begin
      pragma Compile_Time_Warning
        (Standard.True, "Append_Parameter unimplemented");
   end Append_Parameter;

   ----------------------
   -- Append_Parameter --
   ----------------------

   procedure Append_Parameter
     (Self   : in out Context; Origin : Profile_Id; Subprogram : Profile_Id;
      Result :    out Profile_Id)
   is
   begin
      pragma Compile_Time_Warning
        (Standard.True, "Append_Parameter unimplemented");
   end Append_Parameter;

   ----------------------------
   -- Empty_Function_Profile --
   ----------------------------

   procedure Empty_Function_Profile
     (Self   : in out Context; Return_Type : Selected_Entity_Name;
      Result :    out Profile_Id)
   is
   begin
      pragma Compile_Time_Warning
        (Standard.True, "Empty_Function_Profile unimplemented");
   end Empty_Function_Profile;

   ----------------------------
   -- Empty_Function_Profile --
   ----------------------------

   procedure Empty_Function_Profile
     (Self   : in out Context; Return_Profile : Profile_Id;
      Result :    out Profile_Id)
   is
   begin
      pragma Compile_Time_Warning
        (Standard.True, "Empty_Function_Profile unimplemented");
   end Empty_Function_Profile;

   -----------------------------
   -- Empty_Procedure_Profile --
   -----------------------------

   function Empty_Procedure_Profile (Self : Context) return Profile_Id is
   begin
      pragma Compile_Time_Warning
        (Standard.True, "Empty_Procedure_Profile unimplemented");
      return
        raise Program_Error
          with "Unimplemented function Empty_Procedure_Profile";
   end Empty_Procedure_Profile;

   ----------
   -- Hash --
   ----------

   function Hash (Value : Profile_Key) return Ada.Containers.Hash_Type is
   begin
      pragma Compile_Time_Warning (Standard.True, "Hash unimplemented");
      return raise Program_Error with "Unimplemented function Hash";
   end Hash;

   ----------
   -- Hash --
   ----------

   function Hash (Value : Entity_Name_Key) return Ada.Containers.Hash_Type is
   begin
      pragma Compile_Time_Warning (Standard.True, "Hash unimplemented");
      return raise Program_Error with "Unimplemented function Hash";
   end Hash;

   ----------
   -- Hash --
   ----------

   function Hash
     (Value : Selected_Entity_Name_Key) return Ada.Containers.Hash_Type
   is
   begin
      pragma Compile_Time_Warning (Standard.True, "Hash unimplemented");
      return raise Program_Error with "Unimplemented function Hash";
   end Hash;

   ---------------------
   -- New_Entity_Name --
   ---------------------

   procedure New_Entity_Name
     (Self   : in out Context; Symbol : Regions.Symbols.Symbol;
      Result :    out Entity_Name)
   is
   begin
      pragma Compile_Time_Warning
        (Standard.True, "New_Entity_Name unimplemented");
   end New_Entity_Name;

   ---------------------
   -- New_Entity_Name --
   ---------------------

   procedure New_Entity_Name
     (Self    : in out Context; Symbol : Regions.Symbols.Symbol;
      Profile :        Profile_Id; Result : out Entity_Name)
   is
   begin
      pragma Compile_Time_Warning
        (Standard.True, "New_Entity_Name unimplemented");
   end New_Entity_Name;

   -----------------------
   -- New_Selected_Name --
   -----------------------

   procedure New_Selected_Name
     (Self     : in out Context; Prefix : Selected_Entity_Name;
      Selector :        Entity_Name; Result : out Selected_Entity_Name)
   is
   begin
      pragma Compile_Time_Warning
        (Standard.True, "New_Selected_Name unimplemented");
   end New_Selected_Name;

   ---------------
   -- Root_Name --
   ---------------

   function Root_Name (Self : Context) return Selected_Entity_Name is
   begin
      pragma Compile_Time_Warning (Standard.True, "Root_Name unimplemented");
      return raise Program_Error with "Unimplemented function Root_Name";
   end Root_Name;

end Regions.Contexts;
