-- module_followers.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2015-2025 KyrosKrane Sylvanblade
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
local ThisModule = "followers"

-- Set up the module
APR.Modules[ThisModule] = {}
local this = APR.Modules[ThisModule]

-- the name of the variable in APR.DB and its default value
this.DBName = "HideFollowers"
this.DBDefaultValue = APR.HIDE_DIALOG

-- The module's category determines where it goes in the options list
this.Category = "GameInterface"

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

	-- Mark that the dialog should be shown.
	APR.DB.HideFollowers = APR.SHOW_DIALOG

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
this.HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm ) .. ", ForceHide is " .. MakeString(ForceHide))

	-- Mark that the dialog should be hidden.
	APR.DB.HideFollowers = APR.HIDE_DIALOG

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()


-- This is a list of the popups we want to handle using this module.
local SkippedPopups = {
	CONFIRM_FOLLOWER_UPGRADE = 1,
	CONFIRM_FOLLOWER_ABILITY_UPGRADE = 1,
	CONFIRM_FOLLOWER_TEMPORARY_ABILITY = 1,
	CONFIRM_FOLLOWER_EQUIPMENT = 1,
} -- SkippedPopups


-- This function is called whenever a static popup is shown, and determines whether to auto accept it.
local function CheckPopup(upgradeType)
	DebugPrint("in followers CheckPopup, upgradeType is " .. MakeString(upgradeType))

	if not SkippedPopups[upgradeType] then return end
	if APR.DB.HideFollowers ~= APR.HIDE_DIALOG then
		DebugPrint("in followers CheckPopup, HideFollowers is off")
		return
	end

	DebugPrint("in followers CheckPopup, auto confirming")
	APR.SP.Accept(upgradeType)
end -- CheckPopup()


-- Hooks the static popup function so we can check whether we want to suppress that popup.
local function LoadWithGarrison()
	hooksecurefunc("StaticPopup_Show", CheckPopup)

	-- There's a restriction in Blizzard's code for the static popup handler that causes a lua error if you pick up a piece of follower equipment and try to drop it directly onto the equipment slot.
	-- Specifically, C_Garrison.CastItemSpellOnFollowerAbility() is forbidden to addons. It's the handler that's called if you pick up an item and drop it on the equipment slot directly.
	-- Instead, you have to right click the item and THEN click the spell targeting cursor on the equipment slot.
	-- This override stops the lua error from happening, at the cost of removing the ability to equip items by dropping them on the toon.

	-- The code here is adapted from (as of the time of this writing) Blizzard_GarrisonTemplates\Blizzard_GarrisonSharedTemplates.lua in the definition of StaticPopupDialogs["CONFIRM_FOLLOWER_EQUIPMENT"].
	StaticPopupDialogs["CONFIRM_FOLLOWER_EQUIPMENT"].OnAccept = function(self)
		if (self.data.source == "spell") then
			DebugPrint("in CONFIRM_FOLLOWER_EQUIPMENT OnAccept, Auto approving follower spell.")
			C_Garrison.CastSpellOnFollowerAbility(self.data.followerID, self.data.abilityID);
		elseif (self.data.source == "item") then
			-- In the default UI, if you pick up an item and click it on a follower, this branch is executed. But this function throws an error if called from an addon.
			-- So, don't call it. :)
			DebugPrint("in CONFIRM_FOLLOWER_EQUIPMENT OnAccept, Follower item use detected and blocked.")
			-- C_Garrison.CastItemSpellOnFollowerAbility(self.data.followerID, self.data.abilityID);
		end
	end -- StaticPopupDialogs["CONFIRM_FOLLOWER_EQUIPMENT"].OnAccept()
end -- LoadWithGarrison()


-- Now capture the events that this module has to handle
if not APR.IsClassic or this.WorksInClassic then
	EventUtil.ContinueOnAddOnLoaded("Blizzard_GarrisonTemplates", LoadWithGarrison)
end -- WoW Classic check
