-- Post_Locale_Init.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2023 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This file initializes settings that require or depend on localized strings for Annoying Popup Remover.


--#########################################
--# Parameters
--#########################################

-- Grab the WoW-defined addon folder name and storage table for our addon
local addonName, APR = ...

-- Get a handle to the localization table for easier reading
local L = APR.L


--#########################################
--# Config settings
--#########################################

-- These are the categories that modules can choose for showing their settings.
-- The order in this table matters; this is the order that the options will use in the Blizzard settings section.
APR.OrderedCategories = {
	{"Items", L["ItemsHeader"]},
	{"Vendoring", L["VendoringHeader"]},
	{"NPCInteraction", L["NPCInteractionHeader"]},
	{"GameInterface", L["GameInterfaceHeader"]},
}
