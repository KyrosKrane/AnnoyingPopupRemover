-- module_mail.lua
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
local ThisModule = "mail"

-- Set up the module
APR.Modules[ThisModule] = {}

-- the name of the variable in APR.DB and its default value
APR.Modules[ThisModule].DBName = "HideMail";
APR.Modules[ThisModule].DBDefaultValue = APR.HIDE_DIALOG

-- This is the config setup for AceConfig
APR.Modules[ThisModule].config = {
	name = L["Hide the confirmation pop-up when mailing refundable items"],
	type = "toggle",
	set = function(info,val) APR:HandleAceSettingsChange(val, info) end,
	get = function(info) return APR.DB.HideMail end,
	descStyle = "inline",
	width = "full",
} -- config

-- Set the order based on the file inclusion order in the TOC
APR.Modules[ThisModule].config.order = APR.NextOrdering
APR.NextOrdering = APR.NextOrdering + 10

-- These are the status strings that are printed to indicate whether it's off or on
APR.Modules[ThisModule].hidden_msg = L[ThisModule .. "_hidden"];
APR.Modules[ThisModule].shown_msg = L[ThisModule .. "_shown"];

-- This Boolean tells us whether this module works in Classic.
APR.Modules[ThisModule].WorksInClassic = true;


-- This function causes the popup to show when triggered.
APR.Modules[ThisModule].ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['mail'].ShowPopup, printconfirm, printconfirm is " .. MakeString(printconfirm))
	if APR.DB.HideMail then
		-- Re-enable the dialog for mailing refundable items while still tradable.
		StaticPopupDialogs["CONFIRM_MAIL_ITEM_UNREFUNDABLE"] = APR.StoredDialogs["CONFIRM_MAIL_ITEM_UNREFUNDABLE"]
		APR.StoredDialogs["CONFIRM_MAIL_ITEM_UNREFUNDABLE"] = nil

		-- Mark that the dialog is shown.
		APR.DB.HideMail = APR.SHOW_DIALOG

	-- else already shown, nothing to do.
	end

	if printconfirm then APR:PrintStatus("mail") end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
APR.Modules[ThisModule].HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['mail'].HidePopup, printconfirm is " .. MakeString(printconfirm) .. ", ForceHide is " .. MakeString(ForceHide))
	if not APR.DB.HideMail or ForceHide then
		-- Disable the dialog for mailing refundable items while still tradable.
		APR.StoredDialogs["CONFIRM_MAIL_ITEM_UNREFUNDABLE"] = StaticPopupDialogs["CONFIRM_MAIL_ITEM_UNREFUNDABLE"]
		StaticPopupDialogs["CONFIRM_MAIL_ITEM_UNREFUNDABLE"] = nil

		-- Mark that the dialog is hidden.
		APR.DB.HideMail = APR.HIDE_DIALOG

	-- else already hidden, nothing to do.
	end

	if printconfirm then APR:PrintStatus("mail") end
end -- HidePopup()


-- Now capture the events that this module has to handle

if not APR.IsClassic or APR.Modules[ThisModule].WorksInClassic then
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
