--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

package Regions.Environments.Factory is

   procedure Initialize
     (Self     : in out Environment;
      Standard : Symbol);
   --  Reset Environment to an empty

   function Make_Snapshot (Self : Environment) return not null Snapshot_Access;
   --  Create a snapshot from the environment

   procedure Load_Snapshot
     (Self  : in out Environment;
      Value : Snapshot'Class);
   --  Discard current environment and replace it with given snapshot

   procedure With_Snapshot
     (Self  : in out Environment;
      Value : Snapshot'Class);
   --  Merge given snapshot into current environment. Don't change nested
   --  region stack

   procedure Create_Package
     (Self   : in out Environment;
      Symbol : Regions.Symbol);
   --  Create an empty package and enter its declarative region

   procedure Leave_Region (Self : in out Environment);
   --  Pop a toppest region from the nested region stack

   procedure Create_Enumeration_Type
     (Self     : in out Environment;
      Symbol   : Regions.Symbol;
      Literals : Regions.Symbol_Array);
   --  Create enumeration type and corresponding literals. No new region

   procedure Create_Signed_Integer_Type
     (Self     : in out Environment;
      Symbol   : Regions.Symbol);
   --  Create signed integer type. No new region

   procedure Create_Floating_Point_Type
     (Self   : in out Environment;
      Symbol : Regions.Symbol);
   --  Create floating point type. No new region

   procedure Create_Fixed_Point_Type
     (Self   : in out Environment;
      Symbol : Regions.Symbol);
   --  Create fixed point type. No new region

   procedure Create_Array_Type
     (Self    : in out Environment;
      Symbol  : Regions.Symbol;
      Indexes : Regions.Entity_Access_Array);
   --  Create subtype with given subtype mark. Create region

   procedure Set_Component_Type
     (Self    : in out Environment;
      Element : Regions.Entity_Access);
   --  Assign an array component type

   procedure Create_Subtype
     (Self         : in out Environment;
      Symbol       : Regions.Symbol;
      Subtype_Mark : Regions.Entity_Access);
   --  Create subtype with given subtype mark. No new region

   procedure Create_Exception
     (Self   : in out Environment;
      Symbol : Regions.Symbol);
   --  Create an exception. No new region

end Regions.Environments.Factory;
