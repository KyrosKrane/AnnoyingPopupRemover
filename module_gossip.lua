-- module_gossip.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2023-2024 KyrosKrane Sylvanblade
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
local this = APR.Modules[ThisModule]

-- the name of the variable in APR.DB and its default value
this.DBName = "HideGossip"
this.DBDefaultValue = APR.HIDE_DIALOG

-- The module's category determines where it goes in the options list
this.Category = "NPCInteraction"

-- This is the config setup for AceConfig
this.config = {
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
this.hidden_msg = L[ThisModule .. "_hidden"]
this.shown_msg = L[ThisModule .. "_shown"]

-- This Boolean tells us whether this module works in Classic.
this.WorksInClassic = false
-- Although the Darkmoon Faire exists in classic, the teleport NPC does not.
-- Pet battles and suffusion camps also don't exist in Classic.
-- If I ever implement a gossip popup that exists in Classic, I'll have to review the code below.

-- This Boolean tells us whether to disable this module during combat. This can be deleted if it's false.
this.DisableInCombat = false
-- I was never able to trigger an error using these during combat. I'm assuming it's fine.

-- Since the gossip StaticPopup is shared among many chats, most of which we don't handle, we can't just nuke the entire popup.
-- Instead, we just instantly confirm when it pops up for our selected events.

-- This function causes the popup to show when triggered.
this.ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))

	-- Mark that the dialog is shown.
	APR.DB.HideGossip = APR.SHOW_DIALOG

	if printconfirm then
		APR:PrintStatus(ThisModule)
	end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
this.HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm) .. ", ForceHide is " .. MakeString(ForceHide))

	-- Mark that the dialog is hidden.
	APR.DB.HideGossip = APR.HIDE_DIALOG

	if printconfirm then
		APR:PrintStatus(ThisModule)
	end
end -- HidePopup()


-- Sometimes when auto confirming, it requires a gold cost.
-- This is the max amount (in copper pieces) to auto confirm.
local MAX_COPPER = 50000 -- 5g

-- List the gossip text strings that should be auto confirmed.
-- format: GossipTextList["Blizzard text"] = "Name for use in APR"
local GossipTextList = {}
-- Before I realized I could use the IDs to identify specific gossips, I tried using the text of the popup dialog.
-- It works, but it's unreliable due to localization.
-- So, while the code and infrastructure for it are still here, it shouldn't be used.
-- Use the gossipID instead.
-- Example:
-- GossipTextList[L["Darkmoon_travel"]] = "Darkmoon_travel"

-- Similarly track gossips by ID that should be auto confirmed.
-- format: GossipIDList[gossipID] = "Name for use in APR"
local GossipIDList = {}

-- Darkmoon Faire teleports
GossipIDList[40457] = "Darkmoon Faire Alliance" -- both alliance and horde gossips are shared across all the factional Mystic Mage NPCs
GossipIDList[40007] = "Darkmoon Faire Horde"

-- Shadowlands covenant swap
-- No idea why you get the different versions. Might be related to how high you are in the covenant paths?
GossipIDList[53870] = "Venthyr covenant"
GossipIDList[53868] = "Venthyr covenant v2"
GossipIDList[54449] = "Necrolord covenant"
GossipIDList[53984] = "Kyrian covenant"
GossipIDList[53981] = "Kyrian covenant v2"
GossipIDList[53989] = "Night fae covenant"
GossipIDList[53992] = "Night fae covenant v2"

-- 20th Anniversary event trainers
GossipIDList[123241] = "Brok (Anniversary Event)" -- Tanaris, Caverns of Time
GossipIDList[123331] = "Bordin Steadyfist (Anniversary Event)" -- Tanaris, Caverns of Time
GossipIDList[123332] = "Goz Banefury (Anniversary Event)" -- Tanaris, Caverns of Time
GossipIDList[123333] = "Grand Master Obalis (Anniversary Event)" -- Tanaris, Caverns of Time
GossipIDList[123337] = "Nicki Tinytech (Anniversary Event)" -- Tanaris, Caverns of Time
GossipIDList[123338] = "Ras'an (Anniversary Event)" -- Tanaris, Caverns of Time
GossipIDList[123339] = "Narrok (Anniversary Event)" -- Tanaris, Caverns of Time
GossipIDList[123340] = "Morulu the Elder (Anniversary Event)" -- Tanaris, Caverns of Time
GossipIDList[123341] = "Major Payne (Anniversary Event)" -- Tanaris, Caverns of Time
GossipIDList[123342] = "Nearly Headless Jacob (Anniversary Event)" -- Tanaris, Caverns of Time
GossipIDList[123343] = "Gutwretch (Anniversary Event)" -- Tanaris, Caverns of Time
--GossipIDList[123344] = "TBD (Anniversary Event)" -- Tanaris, Caverns of Time
GossipIDList[123345] = "Okrut Dragonwaste (Anniversary Event)" -- Tanaris, Caverns of Time
--GossipIDList[123346] = "TBD (Anniversary Event)" -- Tanaris, Caverns of Time
GossipIDList[123347] = "Hyuna of the Shrines (Anniversary Event)" -- Tanaris, Caverns of Time
GossipIDList[123348] = "Farmer Nishi (Anniversary Event)" -- Tanaris, Caverns of Time
GossipIDList[123349] = "Mo'ruk (Anniversary Event)" -- Tanaris, Caverns of Time
GossipIDList[123350] = "Courageous Yon (Anniversary Event)" -- Tanaris, Caverns of Time

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
GossipIDList[41753] = "Bloodknight Antari" -- Shadowmoon Valley
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
GossipIDList[41816] = "Mo'ruk"
GossipIDList[41591] = "Little Tommy Newcomer"

-- Spawning rares and opening chests at suffusion camps
GossipIDList[108274] = "Secured Shipment Azure Span" -- loot chest
GossipIDList[109222] = "Secured Shipment Ohn'ahran Plains" -- loot chest
GossipIDList[108249] = "Suffusion Crucible" -- spawns minor rares
GossipIDList[108250] = "Suffusion Mold" -- spawns Forgemaster

-- Stable masters. This is a partial list of known IDs
GossipIDList[36818] = "Stable master 36818"
GossipIDList[41280] = "Stable master 41280"
GossipIDList[41827] = "Stable master 41827"
GossipIDList[47842] = "Stable master 47842" -- Lead Rider Jerek in Krokuun
GossipIDList[48013] = "Stable master 48013" -- Zam'cha in Nazmir
GossipIDList[48409] = "Stable master 48409" -- Yash in Nazmir
GossipIDList[49479] = "Stable master 49479" -- Vasilica in Revendreth
GossipIDList[54986] = "Stable master 54986"
GossipIDList[55231] = "Stable master 55231"
GossipIDList[55630] = "Stable master 55630"
GossipIDList[107385] = "Stable master 107385"
GossipIDList[107788] = "Stable master 107788"
GossipIDList[110331] = "Stable master 110331" -- Wurallie
GossipIDList[122708] = "Stable master 122708" -- Wheat in Camp Murroch, The Ringing Deeps
GossipIDList[131400] = "Stable master 131400" -- Zexel Fingersnap in Siren Isle

-- Start of various encounters in the Dragon Soul raid
GossipIDList[40206] = "Ultraxion trash"
GossipIDList[40649] = "Warmaster Blackhorn"
GossipIDList[39999] = "Spine of Deathwing - normal"
GossipIDList[40000] = "Spine of Deathwing - heroic"
GossipIDList[40425] = "Madness of Deathwing"

-- Start of various encounters in the Siege of Orgrimmar raid
GossipIDList[42038] = "Norushen"
GossipIDList[41620] = "Galakras"
GossipIDList[41867] = "Spoils of Pandaria - Horde"
GossipIDList[41865] = "Spoils of Pandaria - Alliance"
GossipIDList[110714] = "Skip to Garrosh"

-- Start of various encounters in the Antorus raid
GossipIDList[46681] = "Eonar"

-- Start of various encounters in the Battle for Dazar'alor raid
GossipIDList[50638] = "Talk to Otoye after Jadefire Masters (Horde)"
GossipIDList[51135] = "Talk to Tancred after King Rastakhan (Alliance)"
GossipIDList[51057] = "Talk to Ensign Roberts before Mekkatorque (Alliance)"
GossipIDList[50645] = "Talk to Captain Zadari post Stormwall Blockade to start Jaina fight" -- same ID for horde LFR, horde normal, and alliance mythic. I assume it's the same for all.

-- Myrrit digs
GossipIDList[109101] = "Starting a Myrrit dig with 1 map"
GossipIDList[109604] = "Starting a Myrrit dig with 2 maps"
GossipIDList[109603] = "Starting a Myrrit dig with 3 maps"
GossipIDList[109815] = "Continuing a Myrrit dig"

-- World quests
GossipIDList[122688] = "Courier Mission: Ore Delivery - bridge end improvised springboard"
GossipIDList[123548] = "Courier Mission: Ore Delivery - improvised air control"
GossipIDList[123529] = "Courier Mission: Ore Delivery - mid bridge improvised springboard"
GossipIDList[123701] = "Courier Mission: Ore Delivery - fog machine"

-- Exit from BfA Dungeons
GossipIDList[50616] = "Freeport Exit" -- both horde and alliance
GossipIDList[48829] = "Shrine of the Storm Exit"
GossipIDList[49426] = "Underrot Exit" -- both horde and alliance
-- Motherlode, Atal'Dazar, King's Rest, Siege of Boralus (Alliance & Horde versions), and Waycrest Manor do not have a popup

-- Start of encounters in Dragonflight raids
-- @TODO: Implement after DF is no longer current
-- GossipIDList[55981] = "Vault of the Incarnates - start event for first trash clear"
-- I have this note in the same file as the Vault start, but I don't know what it's referring to.
-- 79691 bronze to start 6/15/2024


-- Now capture the events that this module has to handle

if not APR.IsClassic or this.WorksInClassic then
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

					if cost and cost > MAX_COPPER then
						DebugPrint("Cost %s exceeds max amount of %s. Not auto confirming.", cost, MAX_COPPER)
						return
					end
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

					if cost and cost > MAX_COPPER then
						DebugPrint("Cost %s exceeds max amount of %s. Not auto confirming.", cost, MAX_COPPER)
						return
					end
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
