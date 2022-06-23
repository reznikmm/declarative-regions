--  SPDX-FileCopyrightText: 2022 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0
-------------------------------------------------------------

function Regions.Environments.Get_Entity
  (Self : Environment'Class;
   Name : Natural) return Entity_Access with Inline;
pragma Preelaborate (Regions.Environments.Get_Entity);
