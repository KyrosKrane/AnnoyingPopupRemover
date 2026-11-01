-- module_roll.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2015-2025 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This file defines a module that APR can handle. Each module is one setting or popup.

-- This module removes the popup when rolling on a bind-on-pickup item.

-- Grab the WoW-defined addon folder name and storage table for our addon
local _, APR = ...

-- Upvalues for readability
local DebugPrint = APR.Utilities.DebugPrint
local MakeString = APR.Utilities.MakeString
local L = APR.L


--#########################################
--# Module settings
--#########################################

-- Note the lowercase naming of modules. Makes it easier to pass status and settings around
local ThisModule = "roll"

-- Set up the module
APR.Modules[ThisModule] = {}
local this = APR.Modules[ThisModule]

-- the name of the variable in APR.DB and its default value
this.DBName = "HideRoll"
this.DBDefaultValue = APR.HIDE_DIALOG

-- The module's category determines where it goes in the options list
this.Category = "Items"

-- This is the config setup for AceConfig
this.config = {
	name = L[ThisModule .. "_name"],
	desc = L[ThisModule .. "_config"],
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
this.hidden_msg = L[ThisModule .. "_hidden"]
this.shown_msg = L[ThisModule .. "_shown"]

-- This Boolean tells us whether this module works in Classic.
this.WorksInClassic = true


this.ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))
	-- Re-enable the dialog for the event that triggers when rolling on BOP items.
	APR.DB.HideRoll = APR.SHOW_DIALOG
	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


this.HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm ) .. ", ForceHide is " .. MakeString(ForceHide))
	-- Disable the dialog for the event that triggers when rolling on BOP items.
	APR.DB.HideRoll = APR.HIDE_DIALOG
	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()


function ValidateLootRoll()
	DebugPrint("In ValidateLootRoll()")
	-- If the user didn't ask us to hide this popup, just return.
	if not APR.DB.HideRoll then
		DebugPrint("HideRoll off, not auto confirming")
		return false
	end

	DebugPrint("HideRoll on, auto confirming next frame")
	return true, true
end

-- Now capture the events that this module has to handle

if not APR.IsClassic or this.WorksInClassic then
	-- Add the list of popups that should be auto-closed when this module is enabled.
	APR.AutoClose["CONFIRM_LOOT_ROLL"] = ValidateLootRoll
end -- WoW Classic check
