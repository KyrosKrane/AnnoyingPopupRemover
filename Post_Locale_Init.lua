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
-- APR.Categories[100] = L["Items"]
-- APR.Categories[200] = L["Vendoring"]
-- APR.Categories[300] = L["NPC Interaction"]
-- APR.Categories[400] = L["Game Interface"]
-- APR.Categories[500] = L["Addon Options"]



APR.Categories = {
	Items = {
		name = L["ItemsHeader"],
		type = "header",
		order = 100,
	}, -- Items

	Vendoring = {
		name = L["VendoringHeader"],
		type = "header",
		order = 200,
	}, -- Vendoring

	NPCInteraction = {
		name = L["NPCInteractionHeader"],
		type = "header",
		order = 300,
	}, -- NPCInteraction

	GameInterface = {
		name = L["GameInterfaceHeader"],
		type = "header",
		order = 400,
	}, -- GameInterface

	AddonOptions = {
		name = L["AddonOptionsHeader"],
		type = "header",
		order = 600,
	}, -- AddonOptions
}
