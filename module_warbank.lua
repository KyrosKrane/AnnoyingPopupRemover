-- module_warbank.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2025 KyrosKrane Sylvanblade
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

-- Note the lowercase naming of modules. Makes it easier to pass status and settings around.
-- This is also the value used in slash commands to toggle settings. For the user, it's case insensitive.
-- This value should always be lowercase only in this file.
local ThisModule = "warbank"

-- Set up the module
APR.Modules[ThisModule] = {}
local this = APR.Modules[ThisModule]

-- the name of the variable in APR.DB and its default value
this.DBName = "HideWarbankDeposit"
this.DBDefaultValue = APR.HIDE_DIALOG

-- The module's category determines where it goes in the options list
this.Category = "Items"

-- This is the config setup for AceConfig
this.config = {
	-- With the standardization that came with the localization and options revamp, these are now typically identical for all modules.
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
APR.NextOrdering = APR.NextOrdering + 1

-- These are the status strings that are printed to indicate whether it's off or on
this.hidden_msg = L[ThisModule .. "_hidden"]
this.shown_msg = L[ThisModule .. "_shown"]

-- This Boolean tells us whether this module works in Classic.
this.WorksInClassic = false

-- This Boolean tells us whether to disable this module during combat. This can be deleted if it's false.
this.DisableInCombat = false


-- This function causes the popup to show when triggered.
this.ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))

	-- Mark that the dialog should be hidden.
	APR.DB.HideWarbankDeposit = APR.SHOW_DIALOG

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
this.HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm ) .. ", ForceHide is " .. MakeString(ForceHide))

	-- Mark that the dialog should be hidden.
	APR.DB.HideWarbankDeposit = APR.HIDE_DIALOG

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()


local function CheckWarbankDeposit(which, text_arg1, text_arg2, data, insertedFrame, customOnHideScript)
	-- Make sure it's the right dialog.
	if "ACCOUNT_BANK_DEPOSIT_NO_REFUND_CONFIRM" ~= which then return end
	DebugPrint("In CheckWarbankDeposit, dialog type matches")

	if APR.DB.HideWarbankDeposit == APR.HIDE_DIALOG then
		DebugPrint("In CheckWarbankDeposit, hiding the popup")
		APR.SP.Accept("ACCOUNT_BANK_DEPOSIT_NO_REFUND_CONFIRM")
	else
		DebugPrint("In CheckWarbankDeposit, NOT hiding the popup")
	end
end

-- check when a popup is shown if it's the one we want
hooksecurefunc("StaticPopup_Show", CheckWarbankDeposit)

