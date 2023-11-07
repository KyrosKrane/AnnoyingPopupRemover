-- module_mail.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2015-2020 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This file defines a module that APR can handle. Each module is one setting or popup.

-- This module removes the popup when mailing a refundable item.

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
local ThisModule = "mail"

-- Set up the module
APR.Modules[ThisModule] = {}
this = APR.Modules[ThisModule]

-- the name of the variable in APR.DB and its default value
this.DBName = "HideMail"
this.DBDefaultValue = APR.HIDE_DIALOG

-- The module's category determines where it goes in the options list
this.Category = "Items"

-- This is the config setup for AceConfig
this.config = {
	name = "/apr " .. ThisModule,
	desc = L["mail_config"],
	type = "toggle",
	set = function(info,val) APR:HandleAceSettingsChange(val, info) end,
	get = function(info) return APR.DB.HideMail end,
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


-- This function causes the popup to show when triggered.
this.ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm, printconfirm is " .. MakeString(printconfirm))
	if APR.DB.HideMail then
		-- Re-enable the dialog for mailing refundable items while still tradable.
		StaticPopupDialogs["CONFIRM_MAIL_ITEM_UNREFUNDABLE"] = APR.StoredDialogs["CONFIRM_MAIL_ITEM_UNREFUNDABLE"]
		APR.StoredDialogs["CONFIRM_MAIL_ITEM_UNREFUNDABLE"] = nil

		-- Mark that the dialog is shown.
		APR.DB.HideMail = APR.SHOW_DIALOG

	-- else already shown, nothing to do.
	end

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
this.HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm) .. ", ForceHide is " .. MakeString(ForceHide))
	if not APR.DB.HideMail or ForceHide then
		-- Disable the dialog for mailing refundable items while still tradable.
		APR.StoredDialogs["CONFIRM_MAIL_ITEM_UNREFUNDABLE"] = StaticPopupDialogs["CONFIRM_MAIL_ITEM_UNREFUNDABLE"]
		StaticPopupDialogs["CONFIRM_MAIL_ITEM_UNREFUNDABLE"] = nil

		-- Mark that the dialog is hidden.
		APR.DB.HideMail = APR.HIDE_DIALOG

	-- else already hidden, nothing to do.
	end

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()


-- Now capture the events that this module has to handle

if not APR.IsClassic or this.WorksInClassic then
	function APR.Events:MAIL_LOCK_SEND_ITEMS(...)
		if APR.DebugMode then
			DebugPrint("In APR.Events:MAIL_LOCK_SEND_ITEMS")
			APR.Utilities.PrintVarArgs(...)
		end -- if APR.DebugMode

		-- Document the incoming parameters.
		local mailSlot, itemLink = ...
		DebugPrint("mailSlot is " .. mailSlot .. ", itemLink is " .. itemLink)

		-- If the user didn't ask us to hide this popup, just return.
		if not APR.DB.HideMail then
			DebugPrint("HideMail off, not auto confirming")
			return
		end

		-- Confirm the mail.
		RespondMailLockSendItem(mailSlot, true)
	end -- APR.Events:MAIL_LOCK_SEND_ITEMS()
end -- WoW Classic check
