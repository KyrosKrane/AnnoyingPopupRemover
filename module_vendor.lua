-- module_vendor.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2015-2025 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This file defines a module that APR can handle. Each module is one setting or popup.

-- This module removes the popup when vendoring a group looted item that can still be traded to other group members.

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
local ThisModule = "vendor"

-- Set up the module
APR.Modules[ThisModule] = {}
local this = APR.Modules[ThisModule]

-- the name of the variable in APR.DB and its default value
this.DBName = "HideVendor"
this.DBDefaultValue = APR.HIDE_DIALOG

-- The module's category determines where it goes in the options list
this.Category = "Vendoring"

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
APR.NextOrdering = APR.NextOrdering + 1

-- These are the status strings that are printed to indicate whether it's off or on
this.hidden_msg = L[ThisModule .. "_hidden"]
this.shown_msg = L[ThisModule .. "_shown"]

-- This Boolean tells us whether this module works in Classic.
this.WorksInClassic = true


-- This function causes the popup to show when triggered.
this.ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))

	if APR.DB.HideVendor then
		-- Mark that the dialog is shown.
		APR.DB.HideVendor = APR.SHOW_DIALOG

	-- else already shown, nothing to do.
	end

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
this.HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm) .. ", ForceHide is " .. MakeString(ForceHide))

	if not APR.DB.HideVendor or ForceHide then
		-- Mark that the dialog is hidden.
		APR.DB.HideVendor = APR.HIDE_DIALOG

	-- else already hidden, nothing to do.
	end

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()


-- Now capture the events that this module has to handle

if not APR.IsClassic or this.WorksInClassic then
-- Vendoring an item that was group-looted and is still tradable in the group triggers this.
	function APR.Events:MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL(...)
		if APR.DebugMode then
			DebugPrint("In APR.Events:MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL")
			APR.Utilities.PrintVarArgs(...)

			-- Document the incoming parameters.
			-- local item = ... -- this is an item link.
			-- DebugPrint("item is " .. item)
		end -- if APR.DebugMode

		-- If the user didn't ask us to hide this popup, just return.
		if not APR.DB.HideVendor then
			DebugPrint("HideVendor off, not auto confirming")
			return
		end

		-- Sell the item.
		SellCursorItem()
		RunNextFrame(function() StaticPopup_Hide("CONFIRM_MERCHANT_TRADE_TIMER_REMOVAL") end)
	end -- APR.Events:MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL()
end -- WoW Classic check
