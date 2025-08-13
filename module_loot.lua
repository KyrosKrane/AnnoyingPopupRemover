-- module_loot.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2015-2025 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This file defines a module that APR can handle. Each module is one setting or popup.

-- This module removes the popup when looting a bind-on-pickup item.

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
local ThisModule = "loot"

-- Set up the module
APR.Modules[ThisModule] = {}
local this = APR.Modules[ThisModule]

-- the name of the variable in APR.DB and its default value
this.DBName = "HideBind"
this.DBDefaultValue = APR.HIDE_DIALOG

-- The module's category determines where it goes in the options list
this.Category = "Items"

-- This is the config setup for AceConfig
this.config = {
	name = L[ThisModule .. "_name"],
	desc = L[ThisModule .. "_config"],
	type = "toggle",
	set = function(info,val) APR:HandleAceSettingsChange(val, info) end,
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
this.WorksInClassic = true


this.ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))
	if APR.DB.HideBind then

		-- Mark that the dialog is shown.
		APR.DB.HideBind = APR.SHOW_DIALOG

	-- else already shown, nothing to do.
	end

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


this.HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm) .. ", ForceHide is " .. MakeString(ForceHide))
	if not APR.DB.HideBind or ForceHide then

		-- Mark that the dialog is hidden.
		APR.DB.HideBind = APR.HIDE_DIALOG

	-- else already hidden, nothing to do.
	end

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()


-- Now capture the events that this module has to handle

if not APR.IsClassic or this.WorksInClassic then

	-- Looting a BOP item triggers this event.
	function APR.Events:LOOT_BIND_CONFIRM(lootSlot)
		DebugPrint("In APR.Events:LOOT_BIND_CONFIRM")

		if not lootSlot then
			DebugPrint("lootSlot is nil, skipping")
			return
		end

		DebugPrint("lootSlot is ", lootSlot)

		-- If the user didn't ask us to hide this popup, just return.
		if not APR.DB.HideBind then
			DebugPrint("HideBind off, not auto confirming")
			return
		end

		-- Check if a dialog is shown, and if so, hide it, then call the accept function
		if APR.SP.Hide("LOOT_BIND", lootSlot) then
			-- note that Hide_StaticPopup returns the ID of the matching popup, or nil. We don't care about the specific ID, just that it's not nil.

			-- call the approval function and hide the popup
			RunNextFrame(function() StaticPopupDialogs["LOOT_BIND"]:OnAccept(lootSlot) end)
			-- note that due to the way Blizz does the dialogs, you can't do dialog:OnAccept() - it doesn't exist. The StaticPopup_OnClick function actually references the static version.
		end

	end -- APR.Events:LOOT_BIND_CONFIRM()

end -- WoW Classic check
