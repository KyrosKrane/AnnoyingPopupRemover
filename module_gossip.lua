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
	set = function(info, val)
		APR:HandleAceSettingsChange(val, info)
	end,
	get = function(info)
		return APR.DB.HideGossip
	end,
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
-- Although the Darkmoon Faire exists in classic, the teleport NPC does not.
-- Pet battles and suffusion camps also don't exist in Classic.
-- If I ever implement a gossip popup that exists in Classic, I'll have to review the code below.

-- This Boolean tells us whether to disable this module during combat. This can be deleted if it's false.
APR.Modules[ThisModule].DisableInCombat = false
-- I was never able to trigger an error using these during combat. I'm assuming it's fine.

-- Since the gossip StaticPopup is shared among many chats, most of which we don't handle, we can't just nuke the entire popup.
-- Instead, we just instantly confirm when it pops up for our selected events.

-- This function causes the popup to show when triggered.
APR.Modules[ThisModule].ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))

	-- Mark that the dialog is shown.
	APR.DB.HideGossip = APR.SHOW_DIALOG

	if printconfirm then
		APR:PrintStatus(ThisModule)
	end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
APR.Modules[ThisModule].HidePopup = function(printconfirm, ForceHide)
	DebugPrint(
		"in APR.Modules['"
			.. ThisModule
			.. "'].HidePopup, printconfirm is "
			.. MakeString(printconfirm)
			.. ", ForceHide is "
			.. MakeString(ForceHide)
	)

	-- Mark that the dialog is hidden.
	APR.DB.HideGossip = APR.HIDE_DIALOG

	if printconfirm then
		APR:PrintStatus(ThisModule)
	end
end -- HidePopup()


-- List the gossip text strings that should be auto confirmed.
-- format: GossipTextList["Blizzard text"] = "Name for use in APR"
local GossipTextList = {}
-- Before I realized I could use the IDs to identify specific gossips, I tried using the text of the popup dialog.
-- It works, but it's unreliable due to localization.
-- So, while the code and infrastructure for it are still here, it shouldn't be used.
-- Use the gossipID instead.

-- Similarly track gossips by ID that should be auto confirmed.
-- format: GossipIDList[gossipID] = "Name for use in APR"
local GossipIDList = {}

-- Darkmoon Faire teleports
GossipIDList[40457] = "Darkmoon Faire Alliance" -- both alliance and horde gossips are shared across all the factional Mystic Mage NPCs
GossipIDList[40007] = "Darkmoon Faire Horde"

-- Eastern Kingdoms pet tamers
GossipIDList[41781] = "Lydia Accoste" -- Deadwind Pass
GossipIDList[40127] = "Julia Stevens" -- Elwynn Forest
GossipIDList[41437] = "Old MacDonald" -- Westfall
GossipIDList[41186] = "Eric Davidson" -- Duskwood
GossipIDList[41216] = "Bill Buckler" -- Cape of Stranglethorn
GossipIDList[39601] = "Steven Lisbane" -- Northern Stranglethorn
GossipIDList[41777] = "Everessa" -- Swamp of Sorrows
GossipIDList[41184] = "Lindsay" -- Redridge Mountains
GossipIDList[41779] = "Durin Darkhammer" -- Burning Steppes
GossipIDList[41417] = "Kortas Darkhammer" -- Searing Gorge
GossipIDList[41415] = "Deiza Plaguehorn" -- Western Plaguelands
GossipIDList[41413] = "David Kosse" -- Hinterlands

-- Kalimdor pet tamers
GossipIDList[41403] = "Zunta" -- Durotar
GossipIDList[47298] = "Crysa" -- North Barrens
GossipIDList[41182] = "Dagra the Fierce" -- North Barrens
GossipIDList[41411] = "Stone Cold Trixxy" -- Winterspring
GossipIDList[41258] = "Elena Flutterfly" -- Moonglade
GossipIDList[41250] = "Zoltan" -- Felwood
GossipIDList[40737] = "Analynn" -- Ashenvale
GossipIDList[40812] = "Zonya the Sadist" -- Stonetalon Mountains
GossipIDList[41022] = "Merda Stonehoof" -- Desolace
GossipIDList[41017] = "Traitor Gluk" -- Feralas
GossipIDList[41260] = "Cassandra Kaboom" -- South Barrens
GossipIDList[41428] = "Kela Grimtotem" -- Thousand Needles
GossipIDList[41246] = "Grazzle the Great" -- Dustwallow Marsh

-- Outland pet tamers
GossipIDList[40903] = "Morulu the Elder" -- Shattrath
GossipIDList[40903] = "Bloodknight Antari" -- Shadowmoon Valley
GossipIDList[41046] = "Nicki Tinytech" -- Hellfire Peninsula
GossipIDList[41751] = "Narrok" -- Nagrand
GossipIDList[40901] = "Ras'an" -- Zangarmarsh

-- Northrend pet tamers
GossipIDList[40769] = "Major Payne" -- Argent Tournament, Icecrown
GossipIDList[41230] = "Nearly Headless Jacob" -- Crystalsong Forest
GossipIDList[41234] = "Gutwretch" -- Zul'Drak
GossipIDList[41232] = "Okrut Dragonwaste" -- Dragonblight
GossipIDList[41228] = "Beegle Blastfuse" -- Howling Fjord

-- Cataclysm pet tamers
GossipIDList[41919] = "Obalis" -- Uldum
GossipIDList[41915] = "Brok" -- Mount Hyjal
GossipIDList[41913] = "Bordin Steadyfist" -- Deepholm
GossipIDList[41917] = "Goz Banefury" -- Twilight Highlands

-- Pandaria pet tamers
GossipIDList[41951] = "Burning Pandaren Spirit"
GossipIDList[41935] = "Flowing Pandaren Spirit"
GossipIDList[41955] = "Thundering Pandaren Spirit"
GossipIDList[41953] = "Whispering Pandaren Spirit"
GossipIDList[41824] = "Aki the Chosen"
GossipIDList[41820] = "Courageous Yon"
GossipIDList[41818] = "Farmer Nishi"
GossipIDList[41814] = "Hyuna of the Shrines"
GossipIDList[41155] = "Seeker Zusshi"
GossipIDList[41822] = "Wastewalker Shu"

-- Spawning rares and opening chests at suffusion camps
GossipIDList[108274] = "Secured Shipment Azure Span" -- loot chest
GossipIDList[109222] = "Secured Shipment Ohn'ahran Plains" -- loot chest
GossipIDList[108249] = "Suffusion Crucible" -- spawns minor rares
GossipIDList[108250] = "Suffusion Mold" -- spawns Forgemaster

-- Stable masters. This is a partial list of known IDs
GossipIDList[107788] = "Stable master 107788"
GossipIDList[36818] = "Stable master 36818"
GossipIDList[55630] = "Stable master 55630"
GossipIDList[41280] = "Stable master 41280"


-- Now capture the events that this module has to handle

if not APR.IsClassic or APR.Modules[ThisModule].WorksInClassic then
	function APR.Events:GOSSIP_CONFIRM(gossipID, text, cost)
		DebugPrint("In APR.Events:GOSSIP_CONFIRM")

		-- If the gossipID is nil or blank, then it's not a dialog we care about
		if not gossipID or "" == gossipID then
			DebugPrint("GossipID is nil or blank, not auto confirming")
			return
		end

		DebugPrint("gossipID is ", gossipID)
		DebugPrint("text is ", text)
		DebugPrint("cost is ", cost)

		-- If the user didn't ask us to hide this popup, just return.
		if not APR.DB.HideGossip then
			DebugPrint("HideGossip off, not auto confirming")
			return
		end

		-- Loop through the static popup dialogs to find the one that matches what we need.
		local found = false
		for i = 1, STATICPOPUP_NUMDIALOGS do
			local sp_name = "StaticPopup" .. i
			local dialog = _G[sp_name]

			if dialog and dialog:IsShown() then
				DebugPrint(string.format("Dialog %s is shown, validating.", sp_name))
				found = true

				local sp_text = dialog.text and dialog.text.text_arg1 or nil
				local sp_data = dialog.data

				DebugPrint(string.format("sp_data is %s, sp_text is %s", sp_data or "nil", sp_text or "nil"))

				-- Check if the dialog ID is in the list of IDs we want to skip.
				if sp_data and GossipIDList[sp_data] and sp_data == gossipID then
					DebugPrint(
						string.format(
							"Found matching popup by ID, index %d, ID %s, name is %s",
							i,
							sp_data,
							GossipIDList[sp_data]
						)
					)
					StaticPopupDialogs["GOSSIP_CONFIRM"]:OnAccept(gossipID)

					-- Check if the dialog has the specific text we want to auto approve
				elseif sp_text and GossipTextList[sp_text] then
					DebugPrint(
						string.format(
							"Found matching popup by text, index %d, text %s, name %s",
							i,
							sp_text,
							GossipTextList[sp_text]
						)
					)
					StaticPopupDialogs["GOSSIP_CONFIRM"]:OnAccept(gossipID)
				else
					DebugPrint("Auto-confirm condition not met.")
				end
			end -- if dialog shown
		end -- for each dialog

		-- Instead of calling OnAccept(), I could also call the direct commands.
		-- Direct command for retail
		-- C_GossipInfo.SelectOption(gossipID, "", true)

		-- Direct command for Classic:
		-- SelectGossipOption(data, "", true) -- need to figure out if data is just the gossipID again.

		if not found then
			DebugPrint("Did not find matching popup")
		end
	end -- APR.Events:GOSSIP_CONFIRM()
end -- WoW Classic check
