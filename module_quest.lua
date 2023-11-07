-- module_quest.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2023 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This file defines a module that APR can handle. Each module is one setting or popup.

-- This module hides the confirmation dialog when abandoning a quest.

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
local ThisModule = "quest"

-- Set up the module
APR.Modules[ThisModule] = {}

-- the name of the variable in APR.DB and its default value
APR.Modules[ThisModule].DBName = "HideAbandonQuest"
APR.Modules[ThisModule].DBDefaultValue = APR.HIDE_DIALOG

-- This is the config setup for AceConfig
APR.Modules[ThisModule].config = {
	name = "/apr " .. ThisModule,
	desc = L["quest_config"],
	type = "toggle",
	set = function(info, val) APR:HandleAceSettingsChange(val, info) end,
	get = function(info) return APR.DB.HideAbandonQuest end,
	descStyle = "inline",
	width = "full",
} -- config

-- The module's category determines where it goes in the options list
APR.Modules[ThisModule].Category = "GameInterface"

-- Set the order based on the file inclusion order in the TOC
APR.Modules[ThisModule].config.order = APR.Categories[APR.Modules[ThisModule].Category].order + APR.NextOrdering
APR.NextOrdering = APR.NextOrdering + 5

-- These are the status strings that are printed to indicate whether it's off or on
APR.Modules[ThisModule].hidden_msg = L[ThisModule .. "_hidden"]
APR.Modules[ThisModule].shown_msg = L[ThisModule .. "_shown"]

-- This Boolean tells us whether this module works in Classic.
APR.Modules[ThisModule].WorksInClassic = true

-- This Boolean tells us whether to disable this module during combat. This can be deleted if it's false.
APR.Modules[ThisModule].DisableInCombat = false


-- This function causes the popup to show when triggered.
APR.Modules[ThisModule].ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))

	APR.DB.HideAbandonQuest = APR.SHOW_DIALOG

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
APR.Modules[ThisModule].HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm ) .. ", ForceHide is " .. MakeString(ForceHide))

	APR.DB.HideAbandonQuest = APR.HIDE_DIALOG

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()


-- This is how you abandon quests on retail...
local function APR_Abandon_Quest()
	DebugPrint("in APR_Abandon_Quest")
	if APR.DB.HideAbandonQuest == APR.SHOW_DIALOG then return end

	-- These lines adapted from Interface/FrameXML/QuestMapFrame.lua, function QuestMapQuestOptions_AbandonQuest()
	StaticPopup_Hide("ABANDON_QUEST")
	StaticPopup_Hide("ABANDON_QUEST_WITH_ITEMS")

	-- These lines adapted from Interface/FrameXML/StaticPopup.lua, section StaticPopupDialogs["ABANDON_QUEST"]
	C_QuestLog.AbandonQuest()
	if (QuestLogPopupDetailFrame:IsShown()) then
		HideUIPanel(QuestLogPopupDetailFrame)
	end
	PlaySound(SOUNDKIT.IG_QUEST_LOG_ABANDON_QUEST)
end


-- ... and this is how you abandon quests on classic.
local function APR_Abandon_Quest_Classic()
	DebugPrint("in APR_Abandon_Quest_Classic")
	if APR.DB.HideAbandonQuest == APR.SHOW_DIALOG then return end

	-- These lines adapted from Interface_Vanilla/FrameXML/QuestLogFrame.xml, Button name="QuestLogFrameAbandonButton", OnClick.
	StaticPopup_Hide("ABANDON_QUEST")
	StaticPopup_Hide("ABANDON_QUEST_WITH_ITEMS")

	-- These lines adapted from Interface/FrameXML/StaticPopup.lua, section StaticPopupDialogs["ABANDON_QUEST"]
	AbandonQuest()
	PlaySound(SOUNDKIT.IG_QUEST_LOG_ABANDON_QUEST)
end

-- This function executes before the addon has fully loaded. Use it to initialize any settings this module needs.
APR.Modules[ThisModule].PreloadFunc = function()
	if QuestMapQuestOptions_AbandonQuest then
		DebugPrint("in APR.Modules['" .. ThisModule .. "'].PreloadFunc, hooking with retail style")
		hooksecurefunc("QuestMapQuestOptions_AbandonQuest", APR_Abandon_Quest)
	else
		DebugPrint("in APR.Modules['" .. ThisModule .. "'].PreloadFunc, hooking with classic style")
		QuestLogFrameAbandonButton:HookScript("OnClick", APR_Abandon_Quest_Classic)
	end
end
