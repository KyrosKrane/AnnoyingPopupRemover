-- module_gossip.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2023 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This file defines a module that APR can handle. Each module is one setting or popup.

-- This module auto confirms a number of gossip popups that share a common static popup and event.

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
local ThisModule = "gossip"

-- Set up the module
APR.Modules[ThisModule] = {}

-- the name of the variable in APR.DB and its default value
APR.Modules[ThisModule].DBName = "HideGossip"
APR.Modules[ThisModule].DBDefaultValue = APR.HIDE_DIALOG

-- This is the config setup for AceConfig
APR.Modules[ThisModule].config = {
	name = L["Hide the confirmation pop-up for various NPC chats (English clients only)"],
	type = "toggle",
	set = function(info, val) APR:HandleAceSettingsChange(val, info) end,
	get = function(info) return APR.DB.HideGossip end,
	descStyle = "inline",
	width = "full",
} -- config

-- Set the order based on the file inclusion order in the TOC
APR.Modules[ThisModule].config.order = APR.NextOrdering
APR.NextOrdering = APR.NextOrdering + 10

-- These are the status strings that are printed to indicate whether it's off or on
-- @TODO: Remember to add these localized strings to the localization file!
APR.Modules[ThisModule].hidden_msg = L[ThisModule .. "_hidden"]
APR.Modules[ThisModule].shown_msg = L[ThisModule .. "_shown"]

-- This Boolean tells us whether this module works in Classic.
APR.Modules[ThisModule].WorksInClassic = false
-- Although the Darkmoon Faire exists in classic and has a similar popup, I tested this in Retail only. 
-- In Retail, it uses the Player Interaction Manager, which doesn't exist in Classic.
-- Given that Blizz is likely to bring these code updates to Classic at some point, I'm disinclined to take a toon into classic and figure out the right events to make it work there.

-- This Boolean tells us whether to disable this module during combat. This can be deleted if it's false.
APR.Modules[ThisModule].DisableInCombat = true -- Since this module is designed to handle multiple popups, I'm going to leave this as true to be safe.


-- Since the gossip StaticPopup is shared among many chats, most of which we don't handle, we can't just nuke the entire popup. Instead, we just instantly confirm when it pops up for our selected events.

-- This function causes the popup to show when triggered.
APR.Modules[ThisModule].ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))

	-- Mark that the dialog is shown.
	APR.DB.HideGossip = APR.SHOW_DIALOG

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
APR.Modules[ThisModule].HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm ) .. ", ForceHide is " .. MakeString(ForceHide))

	-- Mark that the dialog is hidden.
	APR.DB.HideGossip = APR.HIDE_DIALOG

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()


-- This function executes before the addon has fully loaded. Use it to initialize any settings this module needs.
-- This function can be safely deleted if not used by this module.
APR.Modules[ThisModule].PreloadFunc = function()
end


-- List the gossip text strings that should be auto confirmed.
local GossipConfirmTextList = {}
-- format: GossipConfirmTextList["Blizzard text"] = "Name for use in APR"
GossipConfirmTextList[L["Travel to the faire staging area will cost:"]] = "Darkmoon Faire" -- NOTE, this is not localized in Blizzard's lua code.


local function ConfirmGossip_DF(gossipID)
	DebugPrint(string.format("In ConfirmGossip_DF(), Executing C_PlayerInteractionManager commands using type %d", Enum.PlayerInteractionType.Gossip))
	StaticPopupDialogs["GOSSIP_CONFIRM"]:OnAccept(gossipID)

	-- Direct command for retail
	-- C_GossipInfo.SelectOption(gossipID, "", true)

	-- Direct command for Classic:
	-- SelectGossipOption(data, "", true) -- need to figure out if data is just the gossipID again.

	-- @TODO: figure out whether the OnAccept() call works as expected in Classic.
end


-- Now capture the events that this module has to handle

if not APR.IsClassic or APR.Modules[ThisModule].WorksInClassic then

	function APR.Events:GOSSIP_CONFIRM(gossipID, text, cost)

		DebugPrint("In APR.Events:GOSSIP_CONFIRM")

		DebugPrint("gossipID is " .. gossipID)
		DebugPrint("text is " .. text)
		DebugPrint("cost is " .. cost)

		-- If the user didn't ask us to hide this popup, just return.
		if not APR.DB.HideGossip then
			DebugPrint("HideGossip off, not auto confirming")
			return
		end

		-- Loop through the static popup dialogs to find the one that matches what we need.
		for i = 1, 9 do
			local sp_name = "StaticPopup" .. i

			if _G[sp_name] and _G[sp_name].text and _G[sp_name].text.text_arg1 and GossipConfirmTextList[_G[sp_name].text.text_arg1] then
				DebugPrint(string.format("Found matching popup, index %d, type %s", i, GossipConfirmTextList[_G[sp_name].text.text_arg1]))

				ConfirmGossip_DF(gossipID)
				return
			end
		end

		DebugPrint("Did not find matching popup")

	end -- APR.Events:GOSSIP_CONFIRM()

end  -- WoW Classic check
