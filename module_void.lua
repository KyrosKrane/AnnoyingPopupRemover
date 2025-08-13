-- module_void.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2015-2020 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This file defines a module that APR can handle. Each module is one setting or popup.

-- This module removes the popup when depositing a gemmed or enchanted item into Void storage.

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
local ThisModule = "void"

-- Set up the module
APR.Modules[ThisModule] = {}
local this = APR.Modules[ThisModule]

-- the name of the variable in APR.DB and its default value
this.DBName = "HideVoid"
this.DBDefaultValue = APR.HIDE_DIALOG

-- The module's category determines where it goes in the options list
this.Category = "NPCInteraction"

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
this.WorksInClassic = false


this.ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, before showing, HideVoid is " .. MakeString(APR.DB.HideVoid))
	if APR.DB.HideVoid then
		-- Mark that the dialog is shown.
		APR.DB.HideVoid = APR.SHOW_DIALOG

	-- else already shown, nothing to do.
	end

	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, after showing, HideVoid is " .. MakeString(APR.DB.HideVoid))
	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


this.HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm) .. ", ForceHide is " .. MakeString(ForceHide))
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, before hiding, HideVoid is " .. MakeString(APR.DB.HideVoid))
	if not APR.DB.HideVoid or ForceHide then
		-- Mark that the dialog is hidden.
		APR.DB.HideVoid = APR.HIDE_DIALOG

	-- else already hidden, nothing to do.
	end

	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, after hiding, HideVoid is " .. MakeString(APR.DB.HideVoid))
	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()


-- This function actually handles the process of hiding the static popup and enabling the void storage's deposit button.
local function HideVoidPopup(VoidStorageFrame, event, ...)
	-- Make sure we only handle one event.
	if event ~= "VOID_DEPOSIT_WARNING" then return end

	-- If the user didn't ask us to hide this popup, just return.
	if not APR.DB.HideVoid then
		DebugPrint("HideVoid off, not auto confirming")
		return
	end

	DebugPrint("HideVoid on, auto confirming")

	-- First, we hide the actual popup.
	APR.SP.Hide("VOID_DEPOSIT_CONFIRM");

	-- prior to this event firing, the game triggers "VOID_STORAGE_DEPOSIT_UPDATE", which disables the transfer button and normally pops up the dialog.
	-- So, we simulate clicking OK with the UpdateTransferButton, and pass "nil" to indicate the warning dialog isn't showing.
	VoidStorage_UpdateTransferButton(nil)
end -- HideVoidPopup()


-- This function just hooks the void storage frame's event handler when that addon is loaded.
local function LoadWithVoid()
	DebugPrint("In LoadWithVoid(), hooking the function VoidStorageFrame's OnEvent handler")
	VoidStorageFrame:HookScript("OnEvent", HideVoidPopup)
end -- LoadWithVoid()


-- Now capture the events that this module has to handle

if not APR.IsClassic or this.WorksInClassic then
	EventUtil.ContinueOnAddOnLoaded("Blizzard_VoidStorageUI", LoadWithVoid)
end -- WoW Classic check
