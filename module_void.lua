-- module_void.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2015-2020 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This file defines a module that APR can handle. Each module is one setting or popup.

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
local ThisModule = "void"

-- Set up the module
APR.Modules[ThisModule] = {}

-- the name of the variable in APR.DB and its default value
APR.Modules[ThisModule].DBName = "HideVoid";
APR.Modules[ThisModule].DBDefaultValue = APR.HIDE_DIALOG

-- This is the config setup for AceConfig
APR.Modules[ThisModule].config = {
	name = L["Hide the confirmation pop-up when depositing modified items into void storage"],
	type = "toggle",
	set = function(info,val) APR:HandleAceSettingsChange(val, info) end,
	get = function(info) return APR.DB.HideVoid end,
	descStyle = "inline",
	width = "full",
	order = 130,
} -- config

-- These are the status strings that are printed to indicate whether it's off or on
APR.Modules[ThisModule].hidden_msg = L[ThisModule .. "_hidden"];
APR.Modules[ThisModule].shown_msg = L[ThisModule .. "_shown"];

-- This Boolean tells us whether this module works in Classic.
APR.Modules[ThisModule].WorksInClassic = false;


APR.Modules[ThisModule].ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['void''].ShowPopup, printconfirm is " .. MakeString(printconfirm))
	if APR.IsClassic then
		DebugPrint("in APR.Modules['void''].ShowPopup, Classic detected, aborting")
		return
	end
	DebugPrint("in APR.Modules['void''].ShowPopup, before showing, HideVoid is " .. MakeString(APR.DB.HideVoid))
	if APR.DB.HideVoid then
		-- Re-enable the dialog for putting tradable or modified items into void storage.
		StaticPopupDialogs["VOID_DEPOSIT_CONFIRM"] = APR.StoredDialogs["VOID_DEPOSIT_CONFIRM"]
		APR.StoredDialogs["VOID_DEPOSIT_CONFIRM"] = nil

		-- Mark that the dialog is shown.
		APR.DB.HideVoid = APR.SHOW_DIALOG

	-- else already shown, nothing to do.
	end

	DebugPrint("in APR.Modules['void''].ShowPopup, after showing, HideVoid is " .. MakeString(APR.DB.HideVoid))
	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


APR.Modules[ThisModule].HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['void'].HidePopup, printconfirm is " .. MakeString(printconfirm) .. ", ForceHide is " .. MakeString(ForceHide))
	if IsClassic then
		DebugPrint("in APR.Modules['void''].HidePopup, Classic detected, aborting")
		return
	end
	DebugPrint("in APR.Modules['void''].HidePopup, before hiding, HideVoid is " .. MakeString(APR.DB.HideVoid))
	if not APR.DB.HideVoid or ForceHide then
		-- Disable the dialog for putting tradable or modified items into void storage.
		APR.StoredDialogs["VOID_DEPOSIT_CONFIRM"] = StaticPopupDialogs["VOID_DEPOSIT_CONFIRM"]
		StaticPopupDialogs["VOID_DEPOSIT_CONFIRM"] = nil

		-- Mark that the dialog is hidden.
		APR.DB.HideVoid = APR.HIDE_DIALOG

	-- else already hidden, nothing to do.
	end

	DebugPrint("in APR.Modules['void''].HidePopup, after hiding, HideVoid is " .. MakeString(APR.DB.HideVoid))
	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()


-- This function executes before the addon has fully loaded. Use it to initialize any settings this module needs.
-- This function can be safely deleted if not used.
APR.Modules[ThisModule].PreloadFunc = function()
		-- Force the default Void Storage frame to load so we can override it
		local isloaded, reason = LoadAddOn("Blizzard_VoidStorageUI")
		DebugPrint("Blizzard_VoidStorageUI isloaded is " .. MakeString(isloaded))
		DebugPrint("Blizzard_VoidStorageUI reason is " .. MakeString(reason))
end


-- Now capture the events that this module has to handle

if not APR.IsClassic or APR.Modules[ThisModule].WorksInClassic then
	-- Depositing an item that's modified (gemmed, enchanted, or transmogged) or a BOP item still tradable in group triggers this event.
	function APR.Events:VOID_DEPOSIT_WARNING(...)
		if APR.DebugMode then
			DebugPrint("In APR.Events:VOID_DEPOSIT_WARNING")
			APR.Utilities.PrintVarArgs(...)
		end -- if APR.DebugMode

		-- Document the incoming parameters.
		local slot, itemLink = ...
		DebugPrint("slot is " .. slot)

		-- If the user didn't ask us to hide this popup, just return.
		if not APR.DB.HideVoid then
			DebugPrint("HideVoid off, not auto confirming")
			return
		end
		
		DebugPrint("HideVoid on, auto confirming")

		-- prior to this event firing, the game triggers "VOID_STORAGE_DEPOSIT_UPDATE", which disables the transfer button and normally pops up the dialog.
		-- So, we simulate clicking OK with the UpdateTransferButton, and pass "nil" to indicate the warning dialog isn't showing.
		VoidStorage_UpdateTransferButton(nil)
	end -- APR.Events:VOID_DEPOSIT_WARNING()
end -- WoW Classic check
