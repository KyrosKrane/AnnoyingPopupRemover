-- module_craftingorder.lua
-- Written by fuba (fuba82 on CurseForge) and KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2023 fuba and KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: v16.0.5-release

-- This file defines a module that APR can handle. Each module is one setting or popup.
-- This module removes the confirmation popup when you are about to fill a Crafting Order that includes some of your own reagents.


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
local ThisModule = "craftingorder"

-- Set up the module
APR.Modules[ThisModule] = {}

-- the name of the variable in APR.DB and its default value
APR.Modules[ThisModule].DBName = "HideCraftingOrder"
APR.Modules[ThisModule].DBDefaultValue = APR.HIDE_DIALOG

-- This is the config setup for AceConfig
APR.Modules[ThisModule].config = {
	name = L["Hide the confirmation pop-up when Craft a Crafting Order that includes some of your own reagents."],
	type = "toggle",
	set = function(info, val) APR:HandleAceSettingsChange(val, info) end,
	get = function(info) return APR.DB.HideCraftingOrder end,
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
-- Weirdly, this works fine in combat! No errors.
APR.Modules[ThisModule].DisableInCombat = false


-- This function causes the popup to show when triggered.
APR.Modules[ThisModule].ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))

	APR.DB.HideCraftingOrder = APR.SHOW_DIALOG

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
APR.Modules[ThisModule].HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" ..
	ThisModule ..
	"'].HidePopup, printconfirm is " .. MakeString(printconfirm) .. ", ForceHide is " .. MakeString(ForceHide))

	APR.DB.HideCraftingOrder = APR.HIDE_DIALOG

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()


if not APR.IsClassic or APR.Modules[ThisModule].WorksInClassic then
	-- When the user clicks the "Craft" Button, the confirmation dialog is shown. The parameters to the ShowPopup function have the callback to actually Craft the Crafting Order.

	-- This function attempts to actually Craft the Crafting Order
	local function ConfirmCraftOrderWithOwnReagents(customData, insertedFrame)
		DebugPrint("In ConfirmCraftOrderWithOwnMaterial")
		-- for debugging only
		if false then
			APR.Utilities.DumpTable(customData)
		end

		if not APR.DB.HideCraftingOrder then
			DebugPrint("HideCraftingOrder off")
			return
		end

		if ProfessionsFrame and ProfessionsFrame.OrdersPage and ProfessionsFrame.OrdersPage:IsShown() and type(customData) == "table" and (customData.text and type(customData.text) == "string" and #customData.text > 0) then
			if customData.text == CRAFTING_ORDERS_OWN_REAGENTS_CONFIRMATION then -- CRAFTING_ORDERS_OWN_REAGENTS_CONFIRMATION = "You are about to fill a Crafting Order that includes some of your own reagents. Are you sure?"
				DebugPrint("Start Crafting Order")

				-- Execute the callback that actually starts Crafting the Crafting Order
				customData.callback()

				-- hide the now-redundant confirmation popup.
				StaticPopup_Hide("GENERIC_CONFIRMATION")
			else
				DebugPrint("Popup for Crafting Order that includes some of your own reagents not found")
			end
		end
	end -- function ConfirmCraftOrderWithOwnReagents()

	-- Start Crafting the Crafting Order when the confirmation dialog is displayed.
	hooksecurefunc("StaticPopup_ShowCustomGenericConfirmation", ConfirmCraftOrderWithOwnReagents)
end -- WoW Classic check
