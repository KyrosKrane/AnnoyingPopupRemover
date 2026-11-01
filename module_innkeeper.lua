-- module_innkeeper.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2015-2025 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This file defines a module that APR can handle. Each module is one setting or popup.

-- This module removes the popup when setting your hearthstone location at an innkeeper.

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
local ThisModule = "innkeeper"

-- Set up the module
APR.Modules[ThisModule] = {}
local this = APR.Modules[ThisModule]

-- the name of the variable in APR.DB and its default value
this.DBName = "HideInnkeeper"
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
APR.NextOrdering = APR.NextOrdering + 1

-- These are the status strings that are printed to indicate whether it's off or on
this.hidden_msg = L[ThisModule .. "_hidden"]
this.shown_msg = L[ThisModule .. "_shown"]

-- This Boolean tells us whether this module works in Classic.
this.WorksInClassic = true


-- This function causes the popup to show when triggered.
this.ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))
	-- Mark that the dialog is shown.
	APR.DB.HideInnkeeper = APR.SHOW_DIALOG
	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
this.HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm ) .. ", ForceHide is " .. MakeString(ForceHide))
	-- Mark that the dialog is hidden.
	APR.DB.HideInnkeeper = APR.HIDE_DIALOG
	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()


local function ValidateAndHideInnkeeperDialog()
	if not APR.DB.HideInnkeeper then
		DebugPrint("HideInnkeeper off, not auto confirming")
		return false
	end

	-- Note that we have to defer the approval to the next frame on game versions that have the Player Interaction Manager.
	if C_PlayerInteractionManager and C_PlayerInteractionManager.ConfirmationInteraction then
		DebugPrint("HideInnkeeper on, auto confirming next frame")
		return true, true
	else
		DebugPrint("HideInnkeeper on, auto confirming immediately")
		return true, false
	end
end

-- Now capture the events that this module has to handle

if not APR.IsClassic or this.WorksInClassic then
	APR.AutoClose["CONFIRM_BINDER"] = ValidateAndHideInnkeeperDialog
end -- WoW Classic check
