-- module_enchanting.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2015-2021 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@



--#########################################
-- WARNING            WARNING            WARNING
-- WARNING            WARNING            WARNING
--#########################################

--#########################################
-- @TODO: The key function for this module is protected. This module will not work.
--#########################################

-- This file defines a module DOES NOT WORK.
-- The key function is protected by Blizzard.
-- I'm only adding this to the repository to remind myself
-- that I already tried it, and it DOES NOT WORK.

--#########################################
-- WARNING            WARNING            WARNING
-- WARNING            WARNING            WARNING
--#########################################


-- Grab the WoW-defined addon folder name and storage table for our addon
local addonName, APR = ...

-- Upvalues for readability
local DebugPrint = APR.Utilities.DebugPrint
local ChatPrint = APR.Utilities.ChatPrint
local MakeString = APR.Utilities.MakeString
local L = APR.L


--#########################################
--# Module settings
--#########################################

-- Note the lowercase naming of modules. Makes it easier to pass status and settings around
local ThisModule = "enchant"

-- Set up the module
APR.Modules[ThisModule] = {}
local this = APR.Modules[ThisModule]

-- the name of the variable in APR.DB and its default value
this.DBName = "HideEnchant"
this.DBDefaultValue = APR.HIDE_DIALOG

-- The module's category determines where it goes in the options list
this.Category = "Items"

-- This is the config setup for AceConfig
this.config = {
	name = L["Hide the confirmation pop-up when enchanting an item that already has an enchant"],
	type = "toggle",
	set = function(info,val) APR:HandleAceSettingsChange(val, info) end,
	get = function(info) return APR.DB[this.DBName] end,
	descStyle = "inline",
	width = "full",
	order = APR.Categories[this.Category].order + APR.NextOrdering,
} -- config

-- Update the ordering for the next file to be loaded
APR.NextOrdering = APR.NextOrdering + 1

-- These are the status strings that are printed to indicate whether it's off or on
-- Defined in the localization file
this.hidden_msg = L[ThisModule .. "_hidden"]
this.shown_msg = L[ThisModule .. "_shown"]

-- This Boolean tells us whether this module works in Classic.
this.WorksInClassic = true


-- This function causes the popup to show when triggered.
this.ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))

	if APR.DB.HideEnchant then
		-- Re-enable the dialog that pops to confirm equipping BoE gear yourself.
		StaticPopupDialogs["REPLACE_ENCHANT"] = APR.StoredDialogs["REPLACE_ENCHANT"]
		APR.StoredDialogs["REPLACE_ENCHANT"] = nil

		-- Mark that the dialog is shown.
		APR.DB.HideEnchant = APR.SHOW_DIALOG

	-- else already shown, nothing to do.
	end

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
this.HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm ) .. ", ForceHide is " .. MakeString(ForceHide))

	if not APR.DB.HideEnchant or ForceHide then
		-- Disable the dialog that pops to confirm equipping BoE gear yourself.
		APR.StoredDialogs["REPLACE_ENCHANT"] = StaticPopupDialogs["REPLACE_ENCHANT"]
		StaticPopupDialogs["REPLACE_ENCHANT"] = nil

		-- Mark that the dialog is hidden.
		APR.DB.HideEnchant = APR.HIDE_DIALOG

	-- else already hidden, nothing to do.
	end

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()


-- Now capture the events that this module has to handle

if not APR.IsClassic or this.WorksInClassic then
	function APR.Events:REPLACE_ENCHANT(OldText, NewText)

		if APR.DebugMode then
			DebugPrint("In APR.Events:REPLACE_ENCHANT")
		end -- if APR.DebugMode

		-- If the user didn't ask us to hide this popup, just return.
		if not APR.DB.HideEnchant then
			DebugPrint("HideEnchant off, not auto confirming REPLACE_ENCHANT")
			return
		end

		DebugPrint("Auto confirming REPLACE_ENCHANT.")
		-- @TODO: This function is protected. This module will not work.
		C_Item.ReplaceEnchant()
	end -- APR.Events:REPLACE_ENCHANT()
end -- WoW Classic check
