-- module_delete.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2015-2024 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This module changes the popup when deleting a "good" item from requiring you to type the word "delete" to just clicking Yes.

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
local ThisModule = "delete"

-- Set up the module
APR.Modules[ThisModule] = {}
local this = APR.Modules[ThisModule]

-- the name of the variable in APR.DB and its default value
this.DBName = "HideDelete"
this.DBDefaultValue = APR.HIDE_DIALOG

-- The module's category determines where it goes in the options list
this.Category = "Items"

-- This is the config setup for AceConfig
this.config = {
	name = L[ThisModule .. "_name"],
	desc = L[ThisModule .. "_config"],
	type = "toggle",
	set = function(info, val) APR:HandleAceSettingsChange(val, info) end,
	get = function(info) return APR.DB[this.DBName] end,
	descStyle = "inline",
	width = "full",
	order = APR.Categories[this.Category].order + APR.NextOrdering
} -- config

-- Update the ordering for the next file to be loaded
APR.NextOrdering = APR.NextOrdering + 5

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
	if APR.DB.HideDelete then
		-- Re-enable typing the word "delete" when deleting good items.
		StaticPopupDialogs["DELETE_GOOD_ITEM"] = APR.StoredDialogs["DELETE_GOOD_ITEM"]
		APR.StoredDialogs["DELETE_GOOD_ITEM"] = nil

		-- Same again for quest items.
		StaticPopupDialogs["DELETE_GOOD_QUEST_ITEM"] = APR.StoredDialogs["DELETE_GOOD_QUEST_ITEM"]
		APR.StoredDialogs["DELETE_GOOD_QUEST_ITEM"] = nil

		-- Mark that the dialog is shown.
		APR.DB.HideDelete = APR.SHOW_DIALOG

	-- else already shown, nothing to do.
	end

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
this.HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm) .. ", ForceHide is " .. MakeString(ForceHide))
	if not APR.DB.HideDelete or ForceHide then
		-- When deleting a good item, get a yes/no dialog instead of typing the word "delete"
		APR.StoredDialogs["DELETE_GOOD_ITEM"] = StaticPopupDialogs["DELETE_GOOD_ITEM"]
		StaticPopupDialogs["DELETE_GOOD_ITEM"] = StaticPopupDialogs["DELETE_ITEM"]

		-- Do the same for quest items
		APR.StoredDialogs["DELETE_GOOD_QUEST_ITEM"] = StaticPopupDialogs["DELETE_GOOD_QUEST_ITEM"]
		StaticPopupDialogs["DELETE_GOOD_QUEST_ITEM"] = StaticPopupDialogs["DELETE_ITEM"]

		-- Mark that the dialog is hidden.
		APR.DB.HideDelete = APR.HIDE_DIALOG

	-- else already hidden, nothing to do.
	end

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()
