-- module_dragonriding.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2015-2023 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This file defines a module that APR can handle. Each module is one setting or popup.
-- This module removes the confirmation popup when selecing a dragonriding talent.


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

-- This Boolean tells us whether to disable this module during combat.
-- Weirdly, this works fine in combat! No errors.
APR.Modules[ThisModule].DisableInCombat = false


-- This function causes the popup to show when triggered.
APR.Modules[ThisModule].ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))

	APR.DB.HideDragonriding = APR.SHOW_DIALOG

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
APR.Modules[ThisModule].HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm ) .. ", ForceHide is " .. MakeString(ForceHide))

	APR.DB.HideDragonriding = APR.HIDE_DIALOG

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()


if not APR.IsClassic or APR.Modules[ThisModule].WorksInClassic then

	-- When the user clicks the talent, the confirmation dialog is shown. The parameters to the ShowPopup function have the callback to actually buy the talent. Based on the talent tree, we can tell whether it's a dragonriding talent or not.
	-- Code updated based on suggestion by Foxlit on the WoWUIDev Discord.

	-- This function attempts to actually buy the talent.
	local function BuyDRTalent(customData, insertedFrame)
		DebugPrint("In BuyDRTalent")
		-- for debugging only
		if false then
			APR.Utilities.DumpTable(customData)
		end

		if not APR.DB.HideDragonriding then
			DebugPrint("HideDragonriding off, not buying talent")
			return
		end

		if GenericTraitFrame and type(customData) == "table" and customData.referenceKey == GenericTraitFrame and GenericTraitFrame:GetTalentTreeID() == 672 then
			DebugPrint("Buying DR talent")

			-- Execute the callback that actually buys the talent.
			customData.callback()

			-- hide the now-redundant confirmation popup.
			StaticPopup_Hide("GENERIC_CONFIRMATION")
		else
			DebugPrint("Data mismatch, not buying DR talent")
		end

	end -- function BuyDRTalent()

	-- Buy the talent when the confirmation dialog is displayed.
	hooksecurefunc("StaticPopup_ShowCustomGenericConfirmation", BuyDRTalent)

end -- WoW Classic check
