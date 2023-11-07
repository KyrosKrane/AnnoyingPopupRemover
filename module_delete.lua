-- module_delete.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2015-2021 KyrosKrane Sylvanblade
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

-- the name of the variable in APR.DB and its default value
APR.Modules[ThisModule].DBName = "HideDelete"
APR.Modules[ThisModule].DBDefaultValue = APR.HIDE_DIALOG

-- This is the config setup for AceConfig
APR.Modules[ThisModule].config = {
	name = "/apr " .. ThisModule,
	desc = L["delete_config"],
	type = "toggle",
	set = function(info,val) APR:HandleAceSettingsChange(val, info) end,
	get = function(info) return APR.DB.HideDelete end,
	descStyle = "inline",
	width = "full",
} -- config

-- Set the order based on the file inclusion order in the TOC
-- The module's category determines where it goes in the options list
APR.Modules[ThisModule].Category = "Items"

-- Set the order based on the file inclusion order in the TOC
APR.Modules[ThisModule].config.order = APR.Categories[APR.Modules[ThisModule].Category].order + APR.NextOrdering
APR.NextOrdering = APR.NextOrdering + 5

-- This Boolean tells us whether this module works in Classic.
APR.Modules[ThisModule].WorksInClassic = true


-- This function causes the popup to show when triggered.
APR.Modules[ThisModule].ShowPopup = function(printconfirm)
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
APR.Modules[ThisModule].HidePopup = function(printconfirm, ForceHide)
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
