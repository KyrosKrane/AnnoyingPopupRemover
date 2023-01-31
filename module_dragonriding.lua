-- module_dragonriding.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2015-2023 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This file defines a module that APR can handle. Each module is one setting or popup.
-- This module removes the confirmation popup when selecing a dragonriding talent.

DEFAULT_CHAT_FRAME:AddMessage("at top of dragonriding raw load")


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
local ThisModule = "dragonriding"

-- Set up the module
APR.Modules[ThisModule] = {}

-- the name of the variable in APR.DB and its default value
APR.Modules[ThisModule].DBName = "HideDragonriding"
APR.Modules[ThisModule].DBDefaultValue = APR.HIDE_DIALOG

-- This is the config setup for AceConfig
APR.Modules[ThisModule].config = {
	name = L["Hide the confirmation pop-up when selecting a dragonriding talent"],
	type = "toggle",
	set = function(info, val) APR:HandleAceSettingsChange(val, info) end,
	get = function(info) return APR.DB.HideDragonriding end,
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


-- This function causes the popup to show when triggered.
APR.Modules[ThisModule].ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))

	-- code here

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
APR.Modules[ThisModule].HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm ) .. ", ForceHide is " .. MakeString(ForceHide))

	-- code here

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()


-- This function executes before the addon has fully loaded. Use it to initialize any settings this module needs.
-- This function can be safely deleted if not used by this module.
APR.Modules[ThisModule].PreloadFunc = function()
	DebugPrint("in dragonriding PreloadFunc")
end


if not APR.IsClassic or APR.Modules[ThisModule].WorksInClassic then

	-- This uses the event registry
	-- https://wowpedia.fandom.com/wiki/EventRegistry
	-- callback name is "TalentButton.OnClick"

    -- This same callback is triggered for talents and other stuff. Have to narrow it down to just dragonriding talents.
	-- Second parameter in the callback is a table. Based on that, I used the spellID to identify each talent and make an approved list.
	-- Doesn't seem to be any specific flag saying "this is dragonriding" so I'm just hardcoding the list.
	local DragonridingSpellIDs = {
				377920,
		393999,	377938,	377964,
				378967,
			378409,	384824,
				377939,
				378970,
				377921,
			381870,	381871,
		377922,	377940,	377967,
	}

	-- Invert the values for easier lookups
	local DRSID_Keys = {}
	for k,v in pairs(DragonridingSpellIDs) do
		DRSID_Keys[v] = true
    end

	local function ProcessTalentClick(n, TalentDetails, button)
		DebugPrint("In ProcessTalentClick")

		-- purely for debugging
		if false then
			if APR.DebugMode then
				APR.Utilities.PrintVarArgs( { n, TalentDetails, button } )
			end -- if APR.DebugMode
        end

		-- If the user didn't ask us to hide this popup, just return.
		if not APR.DB.HideDragonriding then
			DebugPrint("HideDragonriding off, not auto confirming")
			return
        end

		-- Make sure it's a valid dragonriding talent.
		if not TalentDetails then
            DebugPrint("No TalentDetails parameter; bailing out.")
			return
		elseif not TalentDetails.definitionInfo then
            DebugPrint("No definitionInfo key in TalentDetails; bailing out.")
			return
		elseif not TalentDetails.definitionInfo.spellID then
            DebugPrint("No spellID key in TalentDetails.definitionInfo; bailing out.")
			return
		elseif not DRSID_Keys[TalentDetails.definitionInfo.spellID] then
			DebugPrint("spellID not in approved dragonriding talents, bailing out.")
			return
		end

		DebugPrint("HideDragonriding on, and talent is confirmed as dragonriding.")
	end -- ProcessTalentClick()


	EventRegistry:RegisterCallback("TalentButton.OnClick", ProcessTalentClick)

end -- WoW Classic check
