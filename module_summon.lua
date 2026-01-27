-- module_summon.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2025 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This file defines how APR will skip popups when someone nearby is summoning the player.


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
local ThisModule = "summon"

-- Set up the module
APR.Modules[ThisModule] = {}
local this = APR.Modules[ThisModule]

-- the name of the variable in APR.DB and its default value
this.DBName = "HideSummons"
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
this.WorksInClassic = true

-- This Boolean tells us whether to disable this module during combat. This can be deleted if it's false.
this.DisableInCombat = false


-- This function causes the popup to show when triggered.
this.ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))

	-- Mark that the dialog should be shown.
	APR.DB.HideSummons = APR.SHOW_DIALOG

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
this.HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm ) .. ", ForceHide is " .. MakeString(ForceHide))

	-- Mark that the dialog should be hidden.
	APR.DB.HideSummons = APR.HIDE_DIALOG

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()


-- Now capture the events that this module has to handle
if not APR.IsClassic or this.WorksInClassic then

	-- This event fires when the player is receiving a summon
	function APR.Events:CONFIRM_SUMMON(summonReason, skippingStartExperience)
		DebugPrint("in CONFIRM_SUMMON, Summon received")
		if not APR.DB.HideSummons then
			DebugPrint("in CONFIRM_SUMMON, Summon hiding is turned off, bailing out.")
			return
		end

		-- Make sure the game didn't decide to show one of the special dialogs related to the starting experience.
		-- I'm assuming that a player can't be prank-summoned within the starting experience.
		-- In fact, it's a reasonable assumption that players in the starting experience areas can't summon at all.
		local dialog = APR.SP.FindVisible("CONFIRM_SUMMON")
		if not dialog then
			DebugPrint("in CONFIRM_SUMMON, no matching dialog is shown, bailing out.")
			return
		end

		local Summoner = C_SummonInfo.GetSummonConfirmSummoner()
		DebugPrint("in CONFIRM_SUMMON, Summoner is ", Summoner)

		-- This should never happen, but just to be safe...
		if not Summoner or "" == Summoner then
			DebugPrint("in CONFIRM_SUMMON, Summoner is blank or nil, bailing out.")
			return
		end

		-- Blizz is playing secret squirrel games ...
		-- If you get summoned during combat, the summoner token may be secret.
		if issecretvalue(Summoner) then
			DebugPrint("in CONFIRM_SUMMON, Summoner is secret, bailing out.")
			return
		end

		-- allow summons if the player is summoning themself.
		if UnitIsUnit(Summoner, "player") then
			DebugPrint("in CONFIRM_SUMMON, Player is summoning self, bailing out.")
			return
		end

		if UnitInRange(Summoner) then
			DebugPrint("in CONFIRM_SUMMON,", Summoner, "is in range.")
			if IsShiftKeyDown() then
				DebugPrint("in CONFIRM_SUMMON, shift key is down, not auto cancelling.")
			else
				DebugPrint("in CONFIRM_SUMMON, shift key is NOT down, auto cancelling.")
				APR.SP.Cancel("CONFIRM_SUMMON")
				ChatPrint(L["summon_announce_auto_cancel"]:format(Summoner))
			end
		else
			DebugPrint("in CONFIRM_SUMMON,", Summoner, "is NOT in range, not cancelling summon.")
		end

	end

end -- WoW Classic check
