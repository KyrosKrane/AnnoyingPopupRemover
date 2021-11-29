-- module_equip.lua
-- Written by fuba (fuba82 on CurseForge) and updated by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2020 fuba and KyrosKrane Sylvanblade
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

-- the name of the variable in APR.DB and its default value
APR.Modules[ThisModule].DBName = "HideEquip"
APR.Modules[ThisModule].DBDefaultValue = APR.SHOW_DIALOG

-- This is the config setup for AceConfig
APR.Modules[ThisModule].config = {
	name = L["Hide the confirmation pop-up when equipping a bind-on-equip item"],
	type = "toggle",
	set = function(info,val) APR:HandleAceSettingsChange(val, info) end,
	get = function(info) return APR.DB.HideEquip end,
	descStyle = "inline",
	width = "full",
} -- config

-- Set the order based on the file inclusion order in the TOC
APR.Modules[ThisModule].config.order = APR.NextOrdering
APR.NextOrdering = APR.NextOrdering + 10

-- These are the status strings that are printed to indicate whether it's off or on
APR.Modules[ThisModule].hidden_msg = L[ThisModule .. "_hidden"]
APR.Modules[ThisModule].shown_msg = L[ThisModule .. "_shown"]

-- This Boolean tells us whether this module works in Classic.
APR.Modules[ThisModule].WorksInClassic = true


-- This function causes the popup to show when triggered.
APR.Modules[ThisModule].ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))

	if APR.DB.HideEquip then
		-- Re-enable the dialog that pops to confirm equipping BoE gear yourself.
		StaticPopupDialogs["EQUIP_BIND"] = APR.StoredDialogs["EQUIP_BIND"]
		APR.StoredDialogs["EQUIP_BIND"] = nil

		-- Mark that the dialog is shown.
		APR.DB.HideEquip = APR.SHOW_DIALOG

	-- else already shown, nothing to do.
	end

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
APR.Modules[ThisModule].HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm ) .. ", ForceHide is " .. MakeString(ForceHide))

	if not APR.DB.HideEquip or ForceHide then
		-- Disable the dialog that pops to confirm equipping BoE gear yourself.
		APR.StoredDialogs["EQUIP_BIND"] = StaticPopupDialogs["EQUIP_BIND"]
		StaticPopupDialogs["EQUIP_BIND"] = nil

		-- Mark that the dialog is hidden.
		APR.DB.HideEquip = APR.HIDE_DIALOG

	-- else already hidden, nothing to do.
    end

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()


-- This function executes before the addon has fully loaded. Use it to initialize any settings this module needs.
-- This function can be safely deleted if not used by this module.
APR.Modules[ThisModule].PreloadFunc = function()
end


-- Now capture the events that this module has to handle

if not APR.IsClassic or APR.Modules[ThisModule].WorksInClassic then
	-- Equipping a BoE item triggers this event.
	function APR.Events:EQUIP_BIND_CONFIRM(slot, ...)

		if APR.DebugMode then
			DebugPrint("In APR.Events:EQUIP_BIND_CONFIRM")
			DebugPrint("Slot is " .. slot)
			APR.Utilities.PrintVarArgs(...)
		end -- if APR.DebugMode

		-- If the user didn't ask us to hide this popup, just return.
		if not APR.DB.HideEquip then
			DebugPrint("HideEquip off, not auto confirming")
			return
		end

		if slot then
			DebugPrint("Slot is valid.")
			EquipPendingItem(slot)
		end
	end -- APR.Events:EQUIP_BIND_CONFIRM()
end -- WoW Classic check
