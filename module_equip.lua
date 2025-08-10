-- module_equip.lua
-- Written by fuba (fuba82 on CurseForge) and updated by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2020-2024 fuba and KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This file defines a module that APR can handle. Each module is one setting or popup.

-- This module removes the popup when equipping a bind-on-equip item.

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
local ThisModule = "equip"

-- Set up the module
APR.Modules[ThisModule] = {}
local this = APR.Modules[ThisModule]

-- the name of the variable in APR.DB and its default value
this.DBName = "HideEquip"
this.DBDefaultValue = APR.SHOW_DIALOG

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
APR.NextOrdering = APR.NextOrdering + 5

-- These are the status strings that are printed to indicate whether it's off or on
this.hidden_msg = L[ThisModule .. "_hidden"]
this.shown_msg = L[ThisModule .. "_shown"]

-- This Boolean tells us whether this module works in Classic.
this.WorksInClassic = true

-- This Boolean tells us whether to disable this module during combat.
this.DisableInCombat = true



-- This function causes the popup to show when triggered.
this.ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))

	if APR.DB.HideEquip then

		-- Mark that the dialog is shown.
		APR.DB.HideEquip = APR.SHOW_DIALOG

	-- else already shown, nothing to do.
	end

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
this.HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm ) .. ", ForceHide is " .. MakeString(ForceHide))

	if not APR.DB.HideEquip or ForceHide then
		-- Mark that the dialog is hidden.
		APR.DB.HideEquip = APR.HIDE_DIALOG

	-- else already hidden, nothing to do.
	end

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()



-- Now capture the events that this module has to handle

if not APR.IsClassic or this.WorksInClassic then
	-- Equipping a BoE item triggers this event.
	-- This event exists in both classic and retail
	function APR.Events:EQUIP_BIND_CONFIRM(slot, itemLocation, ...)

		if APR.DebugMode then
			DebugPrint("In APR.Events:EQUIP_BIND_CONFIRM")
			DebugPrint("Slot is " .. slot)
			DebugPrint("itemLocation (type ItemLocationMixin) is " .. (itemLocation and "not nil" or "nil"))
			APR.Utilities.PrintVarArgs(...)
		end -- if APR.DebugMode

		-- If the user didn't ask us to hide this popup, just return.
		if not APR.DB.HideEquip then
			DebugPrint("HideEquip off, not auto confirming")
			return
		end

		-- Note that while EquipPendingItem() still takes a slot, the dialog's OnAccept handler now expects a data table, similar to the other equip modules.
		-- If I ever revise this, I also need to create a data table and pass it in.

		if slot then
			DebugPrint("Slot is valid.")
			EquipPendingItem(slot)
		end
		-- Note that EquipPendingItem() automatically hides the static popup. This command is just a failsafe.
		APR:Hide_StaticPopup("EQUIP_BIND")
	end -- APR.Events:EQUIP_BIND_CONFIRM()
end -- WoW Classic check


if not APR.IsClassic then
	-- Trying to equip a BoE item your class cannot normally use triggers this event.
	-- This event exists only in retail
	function APR.Events:CONVERT_TO_BIND_TO_ACCOUNT_CONFIRM()
		DebugPrint("In APR.Events:CONVERT_TO_BIND_TO_ACCOUNT_CONFIRM")
		-- This event should not have any args as per the documentation

		-- If the user didn't ask us to hide this popup, just return.
		if not APR.DB.HideEquip then
			DebugPrint("HideEquip off, not auto confirming")
			return
		end

		DebugPrint("Converting to BOA.")
		ConvertItemToBindToAccount()

		APR:Hide_StaticPopup("CONVERT_TO_BIND_TO_ACCOUNT_CONFIRM")
	end -- APR.Events:CONVERT_TO_BIND_TO_ACCOUNT_CONFIRM()
end -- if not classic
