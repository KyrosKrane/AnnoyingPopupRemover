-- module_equip_refund.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2021 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This file defines a module that APR can handle. Each module is one setting or popup.

-- This module removes the popup when equipping a vendor-bought item that can still be returned for a refund.

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
local ThisModule = "refund"

-- Set up the module
APR.Modules[ThisModule] = {}

-- the name of the variable in APR.DB and its default value
APR.Modules[ThisModule].DBName = "HideRefund"
APR.Modules[ThisModule].DBDefaultValue = APR.HIDE_DIALOG

-- This is the config setup for AceConfig
APR.Modules[ThisModule].config = {
	name = L["refund_config"],
	type = "toggle",
	set = function(info,val) APR:HandleAceSettingsChange(val, info) end,
	get = function(info) return APR.DB.HideRefund end,
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
APR.Modules[ThisModule].WorksInClassic = false

-- This Boolean tells us whether to disable this module during combat.
APR.Modules[ThisModule].DisableInCombat = true


-- This function causes the popup to show when triggered.
APR.Modules[ThisModule].ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))

	if APR.DB.HideRefund then
		-- Re-enable the dialog that pops to confirm equipping BoE gear yourself.
		StaticPopupDialogs["EQUIP_BIND_REFUNDABLE"] = APR.StoredDialogs["EQUIP_BIND_REFUNDABLE"]
		APR.StoredDialogs["EQUIP_BIND_REFUNDABLE"] = nil

		-- Mark that the dialog is shown.
		APR.DB.HideRefund = APR.SHOW_DIALOG

	-- else already shown, nothing to do.
	end

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
APR.Modules[ThisModule].HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm ) .. ", ForceHide is " .. MakeString(ForceHide))

	if not APR.DB.HideRefund or ForceHide then
		-- Disable the dialog that pops to confirm equipping BoE gear yourself.
		APR.StoredDialogs["EQUIP_BIND_REFUNDABLE"] = StaticPopupDialogs["EQUIP_BIND_REFUNDABLE"]
		StaticPopupDialogs["EQUIP_BIND_REFUNDABLE"] = nil

		-- Mark that the dialog is hidden.
		APR.DB.HideRefund = APR.HIDE_DIALOG

	-- else already hidden, nothing to do.
	end

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()


-- Now capture the events that this module has to handle

if not APR.IsClassic or APR.Modules[ThisModule].WorksInClassic then
	-- Equipping a vendor-refundable item triggers this event.
	function APR.Events:EQUIP_BIND_REFUNDABLE_CONFIRM(slot, ...)

		if APR.DebugMode then
			DebugPrint("In APR.Events:EQUIP_BIND_REFUNDABLE_CONFIRM")
			DebugPrint("Slot is " .. slot)
			APR.Utilities.PrintVarArgs(...)
		end -- if APR.DebugMode

		-- If the user didn't ask us to hide this popup, just return.
		if not APR.DB.HideRefund then
			DebugPrint("HideRefund off, not auto confirming")
			return
		end

		if slot then
			DebugPrint("Slot is valid.")
			EquipPendingItem(slot)
		end
	end -- APR.Events:EQUIP_BIND_REFUNDABLE_CONFIRM()
end -- WoW Classic check
