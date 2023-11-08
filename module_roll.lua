-- module_roll.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2015-2020 KyrosKrane Sylvanblade
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
	name = "/apr " .. ThisModule,
	desc = L["roll_config"],
	type = "toggle",
	set = function(info,val) APR:HandleAceSettingsChange(val, info) end,
	get = function(info) return APR.DB[this.DBName] end,
	descStyle = "inline",
	width = "full",
	order = APR.Categories[this.Category].order + APR.NextOrdering,
} -- config

-- Update the ordering for the next file to be loaded
APR.NextOrdering = APR.NextOrdering + 5

-- These are the status strings that are printed to indicate whether it's off or on
this.hidden_msg = L[ThisModule .. "_hidden"]
this.shown_msg = L[ThisModule .. "_shown"]

-- This Boolean tells us whether this module works in Classic.
this.WorksInClassic = true


this.ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))
	if APR.DB.HideRoll then
		-- Re-enable the dialog for the event that triggers when rolling on BOP items.
		StaticPopupDialogs["CONFIRM_LOOT_ROLL"] = APR.StoredDialogs["CONFIRM_LOOT_ROLL"]
		APR.StoredDialogs["CONFIRM_LOOT_ROLL"] = nil

		-- Mark that the dialog is shown.
		APR.DB.HideRoll = APR.SHOW_DIALOG

	-- else already shown, nothing to do.
	end

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


this.HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm ) .. ", ForceHide is " .. MakeString(ForceHide))
	if not APR.DB.HideRoll or ForceHide then
		-- Disable the dialog for the event that triggers when rolling on BOP items.
		APR.StoredDialogs["CONFIRM_LOOT_ROLL"] = StaticPopupDialogs["CONFIRM_LOOT_ROLL"]
		StaticPopupDialogs["CONFIRM_LOOT_ROLL"] = nil

		-- Mark that the dialog is hidden.
		APR.DB.HideRoll = APR.HIDE_DIALOG

	-- else already hidden, nothing to do.
	end

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()


-- Now capture the events that this module has to handle

if not APR.IsClassic or this.WorksInClassic then

	-- Rolling on a BOP item triggers this event.
	function APR.Events:CONFIRM_LOOT_ROLL(...)
		if APR.DebugMode then
			DebugPrint("In APR.Events:CONFIRM_LOOT_ROLL")
			APR.Utilities.PrintVarArgs(...)
		end -- if APR.DebugMode

		local id, rollType = ...

		DebugPrint("id is " .. id)
		DebugPrint("rollType is " .. rollType)

		-- If the user didn't ask us to hide this popup, just return.
		if not APR.DB.HideRoll then
			DebugPrint("HideRoll off, not auto confirming")
			return
		end

		ConfirmLootRoll(id, rollType)
	end -- APR.Events:CONFIRM_LOOT_ROLL()

end -- WoW Classic check