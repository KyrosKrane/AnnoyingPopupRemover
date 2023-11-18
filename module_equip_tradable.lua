-- module_equip_tradable.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2015-2022 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This file defines a module that APR can handle. Each module is one setting or popup.

-- This module removes the popup when equipping an item looted in a group, and the item is still tradable.

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
local ThisModule = "trade"

-- Set up the module
APR.Modules[ThisModule] = {}
local this = APR.Modules[ThisModule]

-- the name of the variable in APR.DB and its default value
this.DBName = "HideEquipTrade"
this.DBDefaultValue = APR.HIDE_DIALOG

-- The module's category determines where it goes in the options list
this.Category = "Items"

-- This is the config setup for AceConfig
this.config = {
	name = L[ThisModule .. "_name"],
	desc = L[ThisModule .. "_config"],
	type = "toggle",
	set = function(info, val) APR:HandleAceSettingsChange(val, info) end,
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
this.WorksInClassic = false

-- This Boolean tells us whether to disable this module during combat.
this.DisableInCombat = true


-- This function causes the popup to show when triggered.
this.ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))

	if APR.DB.HideEquipTrade then
		-- Re-enable the dialog that pops to confirm equipping BoE gear yourself.
		StaticPopupDialogs["EQUIP_BIND_TRADEABLE"] = APR.StoredDialogs["EQUIP_BIND_TRADEABLE"]
		APR.StoredDialogs["EQUIP_BIND_TRADEABLE"] = nil

		-- Mark that the dialog is shown.
		APR.DB.HideEquipTrade = APR.SHOW_DIALOG

		-- else already shown, nothing to do.
	end

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
this.HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm ) .. ", ForceHide is " .. MakeString(ForceHide))

	if not APR.DB.HideEquipTrade or ForceHide then
		-- Disable the dialog that pops to confirm equipping BoE gear yourself.
		APR.StoredDialogs["EQUIP_BIND_TRADEABLE"] = StaticPopupDialogs["EQUIP_BIND_TRADEABLE"]
		StaticPopupDialogs["EQUIP_BIND_TRADEABLE"] = nil

		-- Mark that the dialog is hidden.
		APR.DB.HideEquipTrade = APR.HIDE_DIALOG

		-- else already hidden, nothing to do.
	end
	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()


-- Now capture the events that this module has to handle

if not APR.IsClassic or this.WorksInClassic then
	-- Equipping a group-looted item that is still tradable triggers this event.
	function APR.Events:EQUIP_BIND_TRADEABLE_CONFIRM(slot, ...)

		if APR.DebugMode then
			DebugPrint("In APR.Events:EQUIP_BIND_TRADEABLE_CONFIRM")
			DebugPrint("Slot is " .. slot)
			APR.Utilities.PrintVarArgs(...)
		end -- if APR.DebugMode

		-- If the user didn't ask us to hide this popup, just return.
		if not APR.DB.HideEquipTrade then
			DebugPrint("HideEquipTrade off, not auto confirming")
			return
		end

		if slot then
			DebugPrint("Slot is valid.")
			EquipPendingItem(slot)
		end
	end -- APR.Events:EQUIP_BIND_TRADEABLE_CONFIRM()
end -- WoW Classic check
