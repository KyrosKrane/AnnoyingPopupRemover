-- Localization_frFR.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Translations by Machou on Github.
-- Copyright (c) 2023 KyrosKrane Sylvanblade & Machou
-- Licensed under the MIT License, as per the included file.

-- This file sets up French localization and text strings for the addon.

-- Grab the WoW-defined addon folder name and storage table for our addon
local addonName, APR = ...

-- Bail out if it's the wrong language.
if not "frFR" == APR.locale then return end

-- Get a handle to the localization table for easier reading
local L = APR.L


-- Status printing
L["Debug mode is now on."] = "FRENCH Debug mode is now on."
L["Debug mode is now off."] = "FRENCH Debug mode is now off."

