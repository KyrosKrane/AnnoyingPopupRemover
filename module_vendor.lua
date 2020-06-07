-- module_vendor.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2015-2020 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This file defines a module that APR can handle. Each module is one setting or popup.

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

-- the name of the variable in APR.DB and its default value
APR.Modules[ThisModule].DBName = "HideVendor";
APR.Modules[ThisModule].DBDefaultValue = APR.HIDE_DIALOG

-- This is the config setup for AceConfig
APR.Modules[ThisModule].config = {
	name = L["Hide the confirmation pop-up when selling group-looted items to a vendor"],
	type = "toggle",
	set = function(info,val) APR:HandleAceSettingsChange(val, info) end,
	get = function(info) return APR.DB.HideVendor end,
	descStyle = "inline",
	width = "full",
	order = 140,
} -- config

-- These are the status strings that are printed to indicate whether it's off or on
APR.Modules[ThisModule].hidden_msg = L[ThisModule .. "_hidden"];
APR.Modules[ThisModule].shown_msg = L[ThisModule .. "_shown"];

-- This Boolean tells us whether this module works in Classic.
APR.Modules[ThisModule].WorksInClassic = false;


-- This function causes the popup to show when triggered.
APR.Modules[ThisModule].ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['vendor'].ShowPopup, printconfirm is " .. MakeString(printconfirm))
	if APR.IsClassic then
		DebugPrint("in APR.Modules['vendor'].ShowPopup, Classic detected, aborting")
		return
	end

	if APR.DB.HideVendor then
		-- Re-enable the dialog for selling group-looted items to a vendor while still tradable.
		StaticPopupDialogs["CONFIRM_MERCHANT_TRADE_TIMER_REMOVAL"] = APR.StoredDialogs["CONFIRM_MERCHANT_TRADE_TIMER_REMOVAL"]
		APR.StoredDialogs["CONFIRM_MERCHANT_TRADE_TIMER_REMOVAL"] = nil

		-- Mark that the dialog is shown.
		APR.DB.HideVendor = APR.SHOW_DIALOG

	-- else already shown, nothing to do.
	end

	if printconfirm then APR:PrintStatus("vendor") end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
APR.Modules[ThisModule].HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['vendor'].HidePopup, printconfirm is " .. MakeString(printconfirm) .. ", ForceHide is " .. MakeString(ForceHide))
	if APR.IsClassic then
		DebugPrint("in APR.Modules['vendor'].HidePopup, Classic detected, aborting")
		return
	end

	if not APR.DB.HideVendor or ForceHide then
		-- Disable the dialog for selling group-looted items to a vendor while still tradable.
		APR.StoredDialogs["CONFIRM_MERCHANT_TRADE_TIMER_REMOVAL"] = StaticPopupDialogs["CONFIRM_MERCHANT_TRADE_TIMER_REMOVAL"]
		StaticPopupDialogs["CONFIRM_MERCHANT_TRADE_TIMER_REMOVAL"] = nil

		-- Mark that the dialog is hidden.
		APR.DB.HideVendor = APR.HIDE_DIALOG

	-- else already hidden, nothing to do.
	end

	if printconfirm then APR:PrintStatus("vendor") end
end -- HidePopup()


-- Now capture the events that this module has to handle

if not APR.IsClassic or APR.Modules[ThisModule].WorksInClassic then
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
	end -- APR.Events:MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL()
end -- WoW Classic check
