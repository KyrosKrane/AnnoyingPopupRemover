-- module_housing.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2015-2026 KyrosKrane Sylvanblade
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

-- Stole these three from Blizz code... :D
local COPPER_PER_SILVER = 100;
local SILVER_PER_GOLD = 100;
local COPPER_PER_GOLD = COPPER_PER_SILVER * SILVER_PER_GOLD;

-- Set the max gold amount to approve (for display), and its conversion to copper (for code)
local MAX_GOLD_COST_TO_APPROVE = 3000
local MAX_COPPER_COST_TO_APPROVE = MAX_GOLD_COST_TO_APPROVE * COPPER_PER_GOLD


-- Note the lowercase naming of modules. Makes it easier to pass status and settings around.
-- This is also the value used in slash commands to toggle settings. For the user, it's case insensitive.
-- This value should always be lowercase only in this file.
local ThisModule = "expensive"

-- Set up the module
APR.Modules[ThisModule] = {}
local this = APR.Modules[ThisModule]

-- the name of the variable in APR.DB and its default value
this.DBName = "HideHousing"
this.DBDefaultValue = APR.HIDE_DIALOG

-- The module's category determines where it goes in the options list
this.Category = "Vendoring"

-- This is the config setup for AceConfig
this.config = {
	-- With the standardization that came with the localization and options revamp, these are now typically identical for all modules.
	name = L[ThisModule .. "_name"]:gsub("SUBSTITUTE_ME_LATER", BreakUpLargeNumbers(MAX_GOLD_COST_TO_APPROVE)),
	desc = L[ThisModule .. "_config"]:gsub("SUBSTITUTE_ME_LATER", BreakUpLargeNumbers(MAX_GOLD_COST_TO_APPROVE)),
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
this.hidden_msg = L[ThisModule .. "_hidden"]:gsub("SUBSTITUTE_ME_LATER", BreakUpLargeNumbers(MAX_GOLD_COST_TO_APPROVE))
this.shown_msg = L[ThisModule .. "_shown"]:gsub("SUBSTITUTE_ME_LATER", BreakUpLargeNumbers(MAX_GOLD_COST_TO_APPROVE))

-- This Boolean tells us whether this module works in Classic.
this.WorksInClassic = false

-- This Boolean tells us whether to disable this module during combat. This can be deleted if it's false.
this.DisableInCombat = false


-- This function causes the popup to show when triggered.
this.ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))

	-- Mark that the dialog is shown.
	APR.DB.HideHousing = APR.SHOW_DIALOG

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
this.HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm ) .. ", ForceHide is " .. MakeString(ForceHide))

	-- Mark that the dialog is hidden.
	APR.DB.HideHousing = APR.HIDE_DIALOG

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()

local function CheckVendorCostAndApprove(SPU_NAME, text_arg1, text_arg2, data, ...)
	DebugPrint("In CheckVendorCostAndApprove")

	-- If the user didn't ask us to hide this popup, just return.
	if not APR.DB.HideHousing then
		DebugPrint("HideHousing off, not auto confirming")
		return false
	end

	-- The game's code gets the item cost directly from the merchant frame, so we're going to do the same.
	local Purchase_Cost = MerchantFrame.price * MerchantFrame.count


	if Purchase_Cost > MAX_COPPER_COST_TO_APPROVE then
		DebugPrint("Item costs", Purchase_Cost, ", max approval amount is", MAX_COPPER_COST_TO_APPROVE, ", not auto confirming")
		return false
	end

	-- Approve the purchase.
	DebugPrint("Item costs", Purchase_Cost, ", max approval amount is", MAX_COPPER_COST_TO_APPROVE, ", buy it!")
	return true
end


-- Now capture the events that this module has to handle
-- This block can be deleted if you don't use events.
if not APR.IsClassic or this.WorksInClassic then
	-- Add the list of popups that should be auto-closed when this module is enabled.
	APR.AutoClose["CONFIRM_HIGH_COST_ITEM"] = CheckVendorCostAndApprove
end -- WoW Classic check
