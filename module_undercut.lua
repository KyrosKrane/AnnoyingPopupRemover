-- module_undercut.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2020-2024 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This file defines a module that APR can handle. Each module is one setting or popup.

-- This module removes the help tip popup telling you that you no longer need to undercut when posting items on the AH.

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
local ThisModule = "undercut"

-- Set up the module
APR.Modules[ThisModule] = {}
local this = APR.Modules[ThisModule]

-- the name of the variable in APR.DB and its default value
this.DBName = "HideUndercut"
this.DBDefaultValue = APR.SHOW_DIALOG

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


-- This function handles the function that shows the AH help tooltip.
local function ControlAHUndercutPopup()
	-- if the AH addon isn't loaded, just bail out
	if not _G["AuctionHouseFrame"] then
		DebugPrint("in '" .. ThisModule .. "' ControlAHUndercutPopup(), AH is not loaded, nothing to do")
		return
	end
	if APR.DB.HideUndercut then
		-- Replace with a blank function
		DebugPrint("in '" .. ThisModule .. "' ControlAHUndercutPopup(), replacing ShowHelpTip with dummy")
		_G["AuctionHouseFrame"].CommoditiesSellFrame.ShowHelpTip = function() end
		_G["AuctionHouseFrame"].ItemSellFrame.ShowHelpTip = function() end
	else
		-- Restore the default function
		DebugPrint("in '" .. ThisModule .. "' ControlAHUndercutPopup(), restoring default ShowHelpTip")
		_G["AuctionHouseFrame"].CommoditiesSellFrame.ShowHelpTip = APR.StoredDialogs["C_ShowHelpTip"]
		_G["AuctionHouseFrame"].ItemSellFrame.ShowHelpTip = APR.StoredDialogs["I_ShowHelpTip"]
	end
end


-- This function causes the popup to show when triggered.
this.ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))

	-- Mark that the popup is shown.
	APR.DB.HideUndercut = APR.SHOW_DIALOG

	-- Show it immediately in case the AH is already open
	ControlAHUndercutPopup()

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
this.HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm ) .. ", ForceHide is " .. MakeString(ForceHide))

	-- Mark that the popup is hidden.
	APR.DB.HideUndercut = APR.HIDE_DIALOG

	-- Hide it immediately in case the AH is already open
	ControlAHUndercutPopup()

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()


local function LoadWithAH()
	-- Store the default help tip function
	-- Note that unlike the other dialogs, this one is always stored.
	-- This isn't strictly a dialog, but thanks to lua's flexibility, we can stuff it in here just the same!
	APR.StoredDialogs["C_ShowHelpTip"] = _G["AuctionHouseFrame"].CommoditiesSellFrame.ShowHelpTip
	APR.StoredDialogs["I_ShowHelpTip"] = _G["AuctionHouseFrame"].ItemSellFrame.ShowHelpTip

	-- Hook the AH to always call our function when it's shown
	DebugPrint("in APR.Modules['" .. ThisModule .. "'] LoadWithAH, hooking SetAmount.")
	hooksecurefunc(_G["AuctionHouseFrame"].ItemSellFrame.PriceInput, "SetAmount", ControlAHUndercutPopup)
end


-- Now capture the events that this module has to handle
if not APR.IsClassic or this.WorksInClassic then
	EventUtil.ContinueOnAddOnLoaded("Blizzard_AuctionHouseUI", LoadWithAH)
end -- WoW Classic check
