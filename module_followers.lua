-- module_followers.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2015-2024 KyrosKrane Sylvanblade
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
APR.NextOrdering = APR.NextOrdering + 5

-- These are the status strings that are printed to indicate whether it's off or on
-- @TODO: Remember to add these localized strings to the localization file!
this.hidden_msg = L[ThisModule .. "_hidden"]
this.shown_msg = L[ThisModule .. "_shown"]

-- This Boolean tells us whether this module works in Classic.
this.WorksInClassic = false

-- This Boolean tells us whether to disable this module during combat. This can be deleted if it's false.
this.DisableInCombat = false

local function CancelStaticPopup(WhichType)
	-- logic stolen from Blizz's StaticPopup.lua
	for index = 1, STATICPOPUP_NUMDIALOGS, 1 do
		local frame = _G["StaticPopup"..index];
		if ( frame:IsShown() and (frame.which == WhichType) ) then
			frame:Hide();
			local OnCancel = StaticPopupDialogs[frame.which].OnCancel;
			if ( OnCancel ) then
				OnCancel(frame, frame.data, "override");
			end
		end
	end
end -- function CancelStaticPopup()

local function AcceptStaticPopup(WhichType)
	-- logic stolen from Blizz's StaticPopup.lua
	for index = 1, STATICPOPUP_NUMDIALOGS, 1 do
		local frame = _G["StaticPopup"..index];
		if ( frame:IsShown() and (frame.which == WhichType) ) then
			frame:Hide();
			local OnAccept = StaticPopupDialogs[frame.which].OnAccept;
			if ( OnAccept ) then
				OnAccept(frame, frame.data);
			end
		end
	end
end -- function AcceptStaticPopup()

-- This function causes the popup to show when triggered.
this.ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))

	-- Mark that the dialog is shown.
	APR.DB.HideFollowers = APR.SHOW_DIALOG

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
this.HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm ) .. ", ForceHide is " .. MakeString(ForceHide))

	-- Mark that the dialog is hidden.
	APR.DB.HideFollowers = APR.HIDE_DIALOG

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()


-- This function executes before the addon has fully loaded. Use it to initialize any settings this module needs.
-- This function can be safely deleted if not used by this module.
this.PreloadFunc = function()
	DebugPrint("followers module loaded")
end

local SkippedPopups = {
	CONFIRM_FOLLOWER_UPGRADE = 1,
	CONFIRM_FOLLOWER_ABILITY_UPGRADE = 1,
	CONFIRM_FOLLOWER_TEMPORARY_ABILITY = 1,
	CONFIRM_FOLLOWER_EQUIPMENT = 1,
}

local function CheckPopup(upgradeType)
	DebugPrint("in followers CheckPopup, upgradeType is " .. MakeString(upgradeType))

	if not SkippedPopups[upgradeType] then return end

	DebugPrint("in followers CheckPopup, auto confirming")
	AcceptStaticPopup(upgradeType)

end

-- Now capture the events that this module has to handle
-- This block can be deleted if you don't use events.
if not APR.IsClassic or this.WorksInClassic then

	hooksecurefunc("StaticPopup_Show", CheckPopup)

end -- WoW Classic check
