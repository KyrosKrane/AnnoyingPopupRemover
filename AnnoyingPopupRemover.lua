-- AnnoyingPopupRemover.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2015-2019 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.

--#########################################
--# Description
--#########################################

-- This add-on file removes a number of annoying pop-ups.
--	It removes the popup confirmation dialog when looting a bind-on-pickup item.
--	It removes the popup confirmation dialog when rolling on a bind-on-pickup item.
--	It removes the popup confirmation dialog when adding a BOP item to void storage, and that item is modified (gemmed, enchanted, or transmogged) or still tradable with the looting group.
--	It removes the popup confirmation dialog when selling a BOP item to a vendor that was looted while grouped, and can still be traded to other group members.
--	It removes the popup confirmation dialog when mailing a BOA item that can still be sold back for a refund of the original purchase price.
--	It changes the popup confirmation dialog when deleting a "good" item from requiring you to type the word "delete" to just yes/no.


--#########################################
--# Constants (for more readable code)
--#########################################

-- These are NOT settings; don't change these!
local FORCE_HIDE_DIALOG = true
local PRINT_CONFIRMATION = true
local NO_CONFIRMATION = false
local HIDE_DIALOG = true
local SHOW_DIALOG = false
local PRINT_STARTUP = true
local HIDE_STARTUP = false


--#########################################
--# Local references (for readability)
--#########################################

local DebugPrint = APR.Utilities.DebugPrint
local ChatPrint = APR.Utilities.ChatPrint


--#########################################
--# Localization
--#########################################

-- This bit of meta-magic makes it so that if we call L with a key that doesn't yet exist, a key is created automatically, and its value is the name of the key.  For example, if L["MyAddon"] doesn't exist, and I run print(L["MyAddon"]), the __index command causes the L table to automatically create a new key called MyAddon, and its value is set to tostring("MyAddon") -- same as the key name.
local L = setmetatable({ }, {__index = function(t, k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end})

-- The above system effectively makes it so that we don't have to define the default, English-language values.  Just set the key name as the English value.
-- Set the default strings used here.  Other languages can override these as needed.
-- Not going to localize debug strings for now.

-- In another file, you can override these strings like:
--		if APR.locale == "deDE" then
--			L["APR"] = "German name of APR here";
--		end
-- That way, it preserves the default English strings in case of a missed translation.


-- These strings are a little complicated, so better to put them in a dedicated section here rather than define them implicitly.
L["loot_hidden"] = "Confirmation pop-up when " .. addon.Utilities.CHAT_GREEN .. "looting" .. FONT_COLOR_CODE_CLOSE .. " bind-on-pickup items will be " .. addon.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["loot_shown"] = "Confirmation pop-up when " .. addon.Utilities.CHAT_RED .. "looting" .. FONT_COLOR_CODE_CLOSE .. " bind-on-pickup items will be " .. addon.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["roll_hidden"] = "Confirmation pop-up when " .. addon.Utilities.CHAT_GREEN .. "rolling" .. FONT_COLOR_CODE_CLOSE .. " on bind-on-pickup items will be " .. addon.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["roll_shown"] = "Confirmation pop-up when " .. addon.Utilities.CHAT_RED .. "rolling" .. FONT_COLOR_CODE_CLOSE .. " on bind-on-pickup items will be " .. addon.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["void_hidden"] = "Confirmation pop-up when depositing modified items into " .. addon.Utilities.CHAT_GREEN .. "void storage" .. FONT_COLOR_CODE_CLOSE .. " will be " .. addon.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["void_shown"] = "Confirmation pop-up when depositing modified items into " .. addon.Utilities.CHAT_RED .. "void storage" .. FONT_COLOR_CODE_CLOSE .. " will be " .. addon.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["vendor_hidden"] = "Confirmation pop-up when selling group-looted items to a " .. addon.Utilities.CHAT_GREEN .. "vendor" .. FONT_COLOR_CODE_CLOSE .. " will be " .. addon.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["vendor_shown"] = "Confirmation pop-up when selling group-looted items to a " .. addon.Utilities.CHAT_RED .. "vendor" .. FONT_COLOR_CODE_CLOSE .. " will be " .. addon.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["delete_hidden"] = addon.Utilities.CHAT_GREEN .. "Deleting \"good\" items" .. FONT_COLOR_CODE_CLOSE .. " will " .. addon.Utilities.CHAT_GREEN .. "not require" .. FONT_COLOR_CODE_CLOSE .. " typing the word \"delete\"."
L["delete_shown"] = addon.Utilities.CHAT_RED .. "Deleting \"good\" items" .. FONT_COLOR_CODE_CLOSE .. " will " .. addon.Utilities.CHAT_RED .. "require" .. FONT_COLOR_CODE_CLOSE .. " typing the word \"delete\"."

L["mail_hidden"] = "Confirmation pop-up when " .. addon.Utilities.CHAT_GREEN .. "mailing" .. FONT_COLOR_CODE_CLOSE .. " refundable items will be " .. addon.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["mail_shown"] = "Confirmation pop-up when " .. addon.Utilities.CHAT_RED .. "mailing" .. FONT_COLOR_CODE_CLOSE .. " refundable items will be " .. addon.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."



--#########################################
--# Global Variables
--#########################################

-- Grab the WoW-defined addon folder name and storage table for our addon
local addonName, APR = ...

-- Set the human-readable name for the addon.
APR.USER_ADDON_NAME = L["Annoying Pop-up Remover"]

-- Set the current version so we can display it.
APR.Version = "@project-version@"

-- Create the frame to hold our event catcher, and the list of events.
APR.Frame, APR.Events = CreateFrame("Frame"), {}

-- Create a holder to store dialogs we're removing, in case the user wants to restore them.
APR.StoredDialogs = {}

-- Get a local reference to these functions to speed up execution.
local rawset = rawset
local tostring = tostring
local select = select
local pairs = pairs
local type = type

-- Get the language used by the client.
APR.locale = GetLocale()

-- Determine whether we're running Classic or normal
-- Note that we don't save this to the APR holder
local IsClassic = select(4, GetBuildInfo()) < 20000


--#########################################
--# Configuration setup
--#########################################

-- These are the settings for the addon, to be displayed in the Interface panel in game.
APR.OptionsTable = {
	type = "group",
	args = {
		AnnoyancesHeader = {
			name = L["Annoyances"],
			type = "header",
			order = 100,
		}, -- AnnoyancesHeader
		loot = {
			name = L["Hide the confirmation pop-up when looting bind-on-pickup items"],
			type = "toggle",
			set = function(info,val) APR:HandleAceSettingsChange(val, info) end,
			get = function(info) return APR.DB.HideBind end,
			descStyle = "inline",
			width = "full",
			order = 110,
		}, -- loot
		roll = {
			name = L["Hide the confirmation pop-up when rolling on bind-on-pickup items"],
			type = "toggle",
			set = function(info,val) APR:HandleAceSettingsChange(val, info) end,
			get = function(info) return APR.DB.HideRoll end,
			descStyle = "inline",
			width = "full",
			order = 120,
		}, -- roll
		void = {
			name = L["Hide the confirmation pop-up when depositing modified items into void storage"],
			type = "toggle",
			set = function(info,val) APR:HandleAceSettingsChange(val, info) end,
			get = function(info) return APR.DB.HideVoid end,
			descStyle = "inline",
			width = "full",
			order = 130,
		}, -- void
		vendor = {
			name = L["Hide the confirmation pop-up when selling group-looted items to a vendor"],
			type = "toggle",
			set = function(info,val) APR:HandleAceSettingsChange(val, info) end,
			get = function(info) return APR.DB.HideVendor end,
			descStyle = "inline",
			width = "full",
			order = 140,
		}, -- vendor
		mail = {
			name = L["Hide the confirmation pop-up when mailing refundable items"],
			type = "toggle",
			set = function(info,val) APR:HandleAceSettingsChange(val, info) end,
			get = function(info) return APR.DB.HideMail end,
			descStyle = "inline",
			width = "full",
			order = 140,
		}, -- mail
		delete = {
			name = L["When deleting \"good\" items, don't require typing the word \"delete\""],
			type = "toggle",
			set = function(info,val) APR:HandleAceSettingsChange(val, info) end,
			get = function(info) return APR.DB.HideDelete end,
			descStyle = "inline",
			width = "full",
			order = 150,
		}, -- delete
		AddonOptionsHeader = {
			name = L["Addon Options"],
			type = "header",
			order = 200,
		}, -- AddonOptionsHeader
		startup = {
			name = L["Show a startup announcement message in your chat frame at login"],
			type = "toggle",
			set = function(info,val) APR:HandleAceSettingsChange(val, info) end,
			get = function(info) return APR.DB.PrintStartupMessage end,
			descStyle = "inline",
			width = "full",
			order = 210,
		}, -- startup
		debug = {
			name = "Enable debug output",
			desc = string.format("%s%s%s", L["Prints extensive debugging output about everything "], APR.USER_ADDON_NAME, L[" does"]),
			type = "toggle",
			set = function(info,val) APR:SetDebug(val) end,
			get = function(info) return APR.DebugMode end,
			descStyle = "inline",
			width = "full",
			hidden = true,
			order = 300,
		}, -- debug
		status = {
			name = L["Print the setting summary to the chat window"],
			--desc = L["Print the setting summary to the chat window"],
			type = "execute",
			func = function() APR:PrintStatus() end,
			guiHidden = true,
			order = 800,
		}, -- status
	} -- args
} -- APR.OptionsTable

-- Delete the options that don't apply to Classic
if IsClassic then
	APR.OptionsTable.args.void = nil
	APR.OptionsTable.args.vendor = nil
end

-- Process the options and create the AceConfig options table
APR.AceConfigReg = LibStub("AceConfigRegistry-3.0")
APR.AceConfigReg:RegisterOptionsTable(addonName, APR.OptionsTable)

-- Create the slash command handler
APR.AceConfigCmd = LibStub("AceConfigCmd-3.0")
APR.AceConfigCmd:CreateChatCommand("apr", addonName)

-- Create the frame to set the options and add it to the Blizzard settings
APR.ConfigFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName, APR.USER_ADDON_NAME)


--#########################################
--# Slash command handling
--#########################################


-- This dispatcher handles settings from the AceConfig setup.
-- value is the true/false value (or other setting) we get from Ace
-- AceInfo is the info table provided by AceConfig, used to determine the option and whether a slash command was used or not
function APR:HandleAceSettingsChange(value, AceInfo)

	-- Check whether a slash command was used, which determines whether a confirmation message is needed
	local ShowConf = NO_CONFIRMATION
	if AceInfo[0] and AceInfo[0] ~= "" then
		-- This was a slash command. Print a confirmation.
		ShowConf = PRINT_CONFIRMATION
	end

	-- Check which option the user toggled
	local option = AceInfo[#AceInfo]

	-- This variable holds the "show/hide" instruction used in the toggling functions.
	local TextAction = value and "hide" or "show"

	-- Check for toggling a pop-up off or on
	if	   "bind" == option
		or "loot" == option
		or "roll" == option
		or "void" == option
		or "vendor" == option
		or "destroy" == option
		or "delete" == option
		or "mail" == option
		then
			APR:TogglePopup(option, TextAction, ShowConf)

	-- Check whether to announce ourself at startup
	elseif "startup" == option then
		-- This one uses opposite text messages
		TextAction = value and "show" or "hide"
		APR:ToggleStartupMessage(TextAction, ShowConf)

	-- Hidden command to toggle the debug state from the command line.
	elseif "debug" == option then
		APR:SetDebug(value, ShowConf)

	-- Print status if requested
	elseif "status" == option then
		APR:PrintStatus()

	end -- if
end -- APR:HandleAceSettingsChange()


--#########################################
--# Status printing
--#########################################

-- Print the status for a given popup type, or for all if not specified.
-- popup is optional
function APR:PrintStatus(popup)
	if not popup or "loot" == popup then
		if APR.DB.HideBind then
			ChatPrint(L["loot_hidden"])
		else
			ChatPrint(L["loot_shown"])
		end
	end
	if not popup or "roll" == popup then
		if APR.DB.HideRoll then
			ChatPrint(L["roll_hidden"])
		else
			ChatPrint(L["roll_shown"])
		end
	end
	if not IsClassic and (not popup or "void" == popup) then
		if APR.DB.HideVoid then
			ChatPrint(L["void_hidden"])
		else
			ChatPrint(L["void_shown"])
		end
	end
	if not IsClassic and (not popup or "vendor" == popup) then
		if APR.DB.HideVendor then
			ChatPrint(L["vendor_hidden"])
		else
			ChatPrint(L["vendor_shown"])
		end
	end
	if not popup or "delete" == popup then
		if APR.DB.HideDelete then
			ChatPrint(L["delete_hidden"])
		else
			ChatPrint(L["delete_shown"])
		end
	end
	if not popup or "mail" == popup then
		if APR.DB.HideMail then
			ChatPrint(L["mail_hidden"])
		else
			ChatPrint(L["mail_shown"])
		end
	end
end -- APR:PrintStatus()


--#########################################
--# Toggle state
--#########################################

-- Dispatcher function to call the correct show or hide function for the appropriate popup window.
-- popup is required, state and ConfState are optional
function APR:TogglePopup(popup, state, ConfState)

	DebugPrint("in TogglePopup, popup = " .. popup .. ", state is " .. (state and state or "nil") .. ", ConfState is " .. (ConfState == nil and "nil" or (ConfState and "true" or "false")))

	-- Check if a confirmation message should be printed. This is only needed when a change is made from the command line, not from the config UI.
	local ShowConf = PRINT_CONFIRMATION
	if ConfState ~= nil then
		ShowConf = ConfState
	end

	-- Older versions of the addon used the keyword "bind" instead of "loot". Handle the case where a user tries to use the old keyword.
	if "bind" == popup then popup = "loot" end

	-- The words "delete" and "destroy" are synonymous for our purposes. The in-game dialog says "delete", but players refer to it as destroying an item.
	-- We'll follow the game protocol of using the word "delete", but accept "destroy" as well.
	if "destroy" == popup then popup = "delete" end

	-- Some options don't apply to Classic
	if IsClassic and ("void" == popup or "vendor" == popup) then
		return
	end

	if "loot" == popup then
		if state then
			if "show" == state then
				APR:ShowPopupBind(ShowConf)
			elseif "hide" == state then
				APR:HidePopupBind(ShowConf)
			else
				-- error, bad programmer, no cookie!
				DebugPrint("Error in APR:TogglePopup: unknown state " .. state .. " for popup type " .. popup .. " passed in.")
				return false
			end
		else
			-- no state specified, so reverse the state. If Hide was on, then show it, and vice versa.
			if APR.DB.HideBind then
				APR:ShowPopupBind(ShowConf)
			else
				APR:HidePopupBind(ShowConf)
			end
		end

	elseif "roll" == popup then
		if state then
			if "show" == state then
				APR:ShowPopupRoll(ShowConf)
			elseif "hide" == state then
				APR:HidePopupRoll(ShowConf)
			else
				-- error, bad programmer, no cookie!
				DebugPrint("Error in APR:TogglePopup: unknown state " .. state .. " for popup type " .. popup .. " passed in.")
				return false
			end
		else
			-- no state specified, so reverse the state. If Hide was on, then show it, and vice versa.
			if APR.DB.HideRoll then
				APR:ShowPopupRoll(ShowConf)
			else
				APR:HidePopupRoll(ShowConf)
			end
		end

	elseif "void" == popup and not IsClassic then
		if state then
			if "show" == state then
				APR:ShowPopupVoid(ShowConf)
			elseif "hide" == state then
				APR:HidePopupVoid(ShowConf)
			else
				-- error, bad programmer, no cookie!
				DebugPrint("Error in APR:TogglePopup: unknown state " .. state .. " for popup type " .. popup .. " passed in.")
				return false
			end
		else
			-- no state specified, so reverse the state. If Hide was on, then show it, and vice versa.
			if APR.DB.HideVoid then
				APR:ShowPopupVoid(ShowConf)
			else
				APR:HidePopupVoid(ShowConf)
			end
		end

	elseif "vendor" == popup and not IsClassic then
		if state then
			if "show" == state then
				APR:ShowPopupVendor(ShowConf)
			elseif "hide" == state then
				APR:HidePopupVendor(ShowConf)
			else
				-- error, bad programmer, no cookie!
				DebugPrint("Error in APR:TogglePopup: unknown state " .. state .. " for popup type " .. popup .. " passed in.")
				return false
			end
		else
			-- no state specified, so reverse the state. If Hide was on, then show it, and vice versa.
			if APR.DB.HideVendor then
				APR:ShowPopupVendor(ShowConf)
			else
				APR:HidePopupVendor(ShowConf)
			end
		end

	elseif "delete" == popup then
		if state then
			if "show" == state then
				APR:ShowPopupDelete(ShowConf)
			elseif "hide" == state then
				APR:HidePopupDelete(ShowConf)
			else
				-- error, bad programmer, no cookie!
				DebugPrint("Error in APR:TogglePopup: unknown state " .. state .. " for popup type " .. popup .. " passed in.")
				return false
			end
		else
			-- no state specified, so reverse the state. If Hide was on, then show it, and vice versa.
			if APR.DB.HideDelete then
				APR:ShowPopupDelete(ShowConf)
			else
				APR:HidePopupDelete(ShowConf)
			end
		end

	elseif "mail" == popup then
		if state then
			if "show" == state then
				APR:ShowPopupMail(ShowConf)
			elseif "hide" == state then
				APR:HidePopupMail(ShowConf)
			else
				-- error, bad programmer, no cookie!
				DebugPrint("Error in APR:TogglePopup: unknown state " .. state .. " for popup type " .. popup .. " passed in.")
				return false
			end
		else
			-- no state specified, so reverse the state. If Hide was on, then show it, and vice versa.
			if APR.DB.HideMail then
				APR:ShowPopupMail(ShowConf)
			else
				APR:HidePopupMail(ShowConf)
			end
		end

	else
		-- error, bad programmer, no cookie!
		DebugPrint("Error in APR:TogglePopup: unknown popup type " .. popup .. " passed in.")
		return false
	end
end -- APR:TogglePopup()


function APR:SetDebug(mode)
	if mode then
		APR.DebugMode = true
		ChatPrint(L["Debug mode is now on."])
	else
		APR.DebugMode = false
		ChatPrint(L["Debug mode is now off."])
	end
end -- APR:SetDebug()


function APR:ToggleStartupMessage(mode, ConfState)
	DebugPrint("in ToggleStartupMessage, mode = " .. mode .. ", ConfState is " .. (ConfState == nil and "nil" or (ConfState and "true" or "false")))

	-- Check if a confirmation message should be printed. This is only needed when a change is made from the command line, not from the config UI.
	local ShowConf = PRINT_CONFIRMATION
	if ConfState ~= nil then
		ShowConf = ConfState
	end

	if "show" == mode then
		APR.DB.PrintStartupMessage = PRINT_STARTUP
		if ShowConf then ChatPrint(L["Startup announcement message will printed in your chat frame at login."]) end
	elseif "hide" == mode then
		APR.DB.PrintStartupMessage = HIDE_STARTUP
		if ShowConf then ChatPrint(L["Startup announcement message will NOT printed in your chat frame at login."]) end
	else
		-- error, bad programmer, no cookie!
		DebugPrint("Error in APR:ToggleStartupMessage: unknown mode " .. mode .. " passed in.")
		return false
	end
end -- APR:ToggleStartupMessage()


--#########################################
--# Dialog toggling functions
--#########################################

-- Show and hide functions for each of the supported types
-- not documenting individually, as it should be clear what they do.

function APR:ShowPopupBind(printconfirm)
	DebugPrint("in APR:ShowPopupBind, printconfirm is " .. (printconfirm and "true" or "false"))
	if APR.DB.HideBind then
		-- Re-enable the dialog that pops to confirm looting BoP gear yourself.
		StaticPopupDialogs["LOOT_BIND"] = APR.StoredDialogs["LOOT_BIND"]
		APR.StoredDialogs["LOOT_BIND"] = nil

		-- Mark that the dialog is shown.
		APR.DB.HideBind = SHOW_DIALOG

	-- else already shown, nothing to do.
	end

	if printconfirm then APR:PrintStatus("loot") end
end -- APR:ShowPopupBind()


function APR:ShowPopupRoll(printconfirm)
	DebugPrint("in APR:ShowPopupRoll, printconfirm is " .. (printconfirm and "true" or "false"))
	if APR.DB.HideRoll then
		-- Re-enable the dialog for the event that triggers when rolling on BOP items.
		StaticPopupDialogs["CONFIRM_LOOT_ROLL"] = APR.StoredDialogs["CONFIRM_LOOT_ROLL"]
		APR.StoredDialogs["CONFIRM_LOOT_ROLL"] = nil

		-- Mark that the dialog is shown.
		APR.DB.HideRoll = SHOW_DIALOG

	-- else already shown, nothing to do.
	end

	if printconfirm then APR:PrintStatus("roll") end
end -- APR:ShowPopupRoll()


function APR:ShowPopupVoid(printconfirm)
	DebugPrint("in APR:ShowPopupVoid, printconfirm is " .. (printconfirm and "true" or "false"))
	if IsClassic then
		DebugPrint("in APR:ShowPopupVoid, Classic detected, aborting")
		return
	end
	if APR.DB.HideVoid then
		-- Re-enable the dialog for putting tradable or modified items into void storage.
		StaticPopupDialogs["VOID_DEPOSIT_CONFIRM"] = APR.StoredDialogs["VOID_DEPOSIT_CONFIRM"]
		APR.StoredDialogs["VOID_DEPOSIT_CONFIRM"] = nil

		-- Mark that the dialog is shown.
		APR.DB.HideVoid = SHOW_DIALOG

	-- else already shown, nothing to do.
	end

	if printconfirm then APR:PrintStatus("void") end
end -- APR:ShowPopupVoid()


function APR:ShowPopupVendor(printconfirm)
	DebugPrint("in APR:ShowPopupVendor, printconfirm is " .. (printconfirm and "true" or "false"))
	if IsClassic then
		DebugPrint("in APR:ShowPopupVendor, Classic detected, aborting")
		return
	end
	if APR.DB.HideVendor then
		-- Re-enable the dialog for selling group-looted items to a vendor while still tradable.
		StaticPopupDialogs["CONFIRM_MERCHANT_TRADE_TIMER_REMOVAL"] = APR.StoredDialogs["CONFIRM_MERCHANT_TRADE_TIMER_REMOVAL"]
		APR.StoredDialogs["CONFIRM_MERCHANT_TRADE_TIMER_REMOVAL"] = nil

		-- Mark that the dialog is shown.
		APR.DB.HideVendor = SHOW_DIALOG

	-- else already shown, nothing to do.
	end

	if printconfirm then APR:PrintStatus("vendor") end
end -- APR:ShowPopupVendor()


function APR:ShowPopupDelete(printconfirm)
	DebugPrint("in APR:ShowPopupDelete, printconfirm is " .. (printconfirm and "true" or "false"))
	if APR.DB.HideDelete then
		-- Re-enable typing the word "delete" when deleting good items.
		StaticPopupDialogs["DELETE_GOOD_ITEM"] = APR.StoredDialogs["DELETE_GOOD_ITEM"]
		APR.StoredDialogs["DELETE_GOOD_ITEM"] = nil

		-- Mark that the dialog is shown.
		APR.DB.HideDelete = SHOW_DIALOG

	-- else already shown, nothing to do.
	end

	if printconfirm then APR:PrintStatus("delete") end
end -- APR:ShowPopupDelete()


function APR:ShowPopupMail(printconfirm)
	DebugPrint("in APR:ShowPopupMail, printconfirm is " .. (printconfirm and "true" or "false"))
	if APR.DB.HideMail then
		-- Re-enable the dialog for mailing refundable items while still tradable.
		StaticPopupDialogs["CONFIRM_MAIL_ITEM_UNREFUNDABLE"] = APR.StoredDialogs["CONFIRM_MAIL_ITEM_UNREFUNDABLE"]
		APR.StoredDialogs["CONFIRM_MAIL_ITEM_UNREFUNDABLE"] = nil

		-- Mark that the dialog is shown.
		APR.DB.HideMail = SHOW_DIALOG

	-- else already shown, nothing to do.
	end

	if printconfirm then APR:PrintStatus("mail") end
end -- APR:ShowPopupMail()


function APR:HidePopupBind(printconfirm, ForceHide)
	DebugPrint("in APR:HidePopupBind, printconfirm is " .. (printconfirm and "true" or "false") .. ", ForceHide is " .. (ForceHide == nil and "nil" or (ForceHide and "true" or "false")))
	if not APR.DB.HideBind or ForceHide then
		-- Disable the dialog that pops to confirm looting BoP gear yourself.
		APR.StoredDialogs["LOOT_BIND"] = StaticPopupDialogs["LOOT_BIND"]
		StaticPopupDialogs["LOOT_BIND"] = nil

		-- Mark that the dialog is hidden.
		APR.DB.HideBind = HIDE_DIALOG

	-- else already hidden, nothing to do.
	end

	if printconfirm then APR:PrintStatus("loot") end
end -- APR:HidePopupBind()


function APR:HidePopupRoll(printconfirm, ForceHide)
	DebugPrint("in APR:HidePopupRoll, printconfirm is " .. (printconfirm and "true" or "false") .. ", ForceHide is " .. (ForceHide == nil and "nil" or (ForceHide and "true" or "false")))
	if not APR.DB.HideRoll or ForceHide then
		-- Disable the dialog for the event that triggers when rolling on BOP items.
		APR.StoredDialogs["CONFIRM_LOOT_ROLL"] = StaticPopupDialogs["CONFIRM_LOOT_ROLL"]
		StaticPopupDialogs["CONFIRM_LOOT_ROLL"] = nil

		-- Mark that the dialog is hidden.
		APR.DB.HideRoll = HIDE_DIALOG

	-- else already hidden, nothing to do.
	end

	if printconfirm then APR:PrintStatus("roll") end
end -- APR:HidePopupRoll()


function APR:HidePopupVoid(printconfirm, ForceHide)
	DebugPrint("in APR:HidePopupVoid, printconfirm is " .. (printconfirm and "true" or "false") .. ", ForceHide is " .. (ForceHide == nil and "nil" or (ForceHide and "true" or "false")))
	if IsClassic then
		DebugPrint("in APR:HidePopupVoid, Classic detected, aborting")
		return
	end
	if not APR.DB.HideVoid or ForceHide then
		-- Disable the dialog for putting tradable or modified items into void storage.
		APR.StoredDialogs["VOID_DEPOSIT_CONFIRM"] = StaticPopupDialogs["VOID_DEPOSIT_CONFIRM"]
		StaticPopupDialogs["VOID_DEPOSIT_CONFIRM"] = nil

		-- Mark that the dialog is hidden.
		APR.DB.HideVoid = HIDE_DIALOG

	-- else already hidden, nothing to do.
	end

	if printconfirm then APR:PrintStatus("void") end
end -- APR:HidePopupVoid()


function APR:HidePopupVendor(printconfirm, ForceHide)
	DebugPrint("in APR:HidePopupVendor, printconfirm is " .. (printconfirm and "true" or "false") .. ", ForceHide is " .. (ForceHide == nil and "nil" or (ForceHide and "true" or "false")))
	if IsClassic then
		DebugPrint("in APR:HidePopupVendor, Classic detected, aborting")
		return
	end
	if not APR.DB.HideVendor or ForceHide then
		-- Disable the dialog for selling group-looted items to a vendor while still tradable.
		APR.StoredDialogs["CONFIRM_MERCHANT_TRADE_TIMER_REMOVAL"] = StaticPopupDialogs["CONFIRM_MERCHANT_TRADE_TIMER_REMOVAL"]
		StaticPopupDialogs["CONFIRM_MERCHANT_TRADE_TIMER_REMOVAL"] = nil

		-- Mark that the dialog is hidden.
		APR.DB.HideVendor = HIDE_DIALOG

	-- else already hidden, nothing to do.
	end

	if printconfirm then APR:PrintStatus("vendor") end
end -- APR:HidePopupVendor()


function APR:HidePopupDelete(printconfirm, ForceHide)
	DebugPrint("in APR:HidePopupDelete, printconfirm is " .. (printconfirm and "true" or "false") .. ", ForceHide is " .. (ForceHide == nil and "nil" or (ForceHide and "true" or "false")))
	if not APR.DB.HideDelete or ForceHide then
		-- When deleting a good item, get a yes/no dialog instead of typing the word "delete"
		APR.StoredDialogs["DELETE_GOOD_ITEM"] = StaticPopupDialogs["DELETE_GOOD_ITEM"]
		StaticPopupDialogs["DELETE_GOOD_ITEM"] = StaticPopupDialogs["DELETE_ITEM"]

		-- Mark that the dialog is hidden.
		APR.DB.HideDelete = HIDE_DIALOG

	-- else already hidden, nothing to do.
	end

	if printconfirm then APR:PrintStatus("delete") end
end -- APR:HidePopupDelete()


function APR:HidePopupMail(printconfirm, ForceHide)
	DebugPrint("in APR:HidePopupMail, printconfirm is " .. (printconfirm and "true" or "false") .. ", ForceHide is " .. (ForceHide == nil and "nil" or (ForceHide and "true" or "false")))
	if not APR.DB.HideMail or ForceHide then
		-- Disable the dialog for mailing refundable items while still tradable.
		APR.StoredDialogs["CONFIRM_MAIL_ITEM_UNREFUNDABLE"] = StaticPopupDialogs["CONFIRM_MAIL_ITEM_UNREFUNDABLE"]
		StaticPopupDialogs["CONFIRM_MAIL_ITEM_UNREFUNDABLE"] = nil

		-- Mark that the dialog is hidden.
		APR.DB.HideMail = HIDE_DIALOG

	-- else already hidden, nothing to do.
	end

	if printconfirm then APR:PrintStatus("mail") end
end -- APR:HidePopupMail()


--#########################################
--# Event hooks - Processing
--#########################################

-- Looting a BOP item triggers this event.
function APR.Events:LOOT_BIND_CONFIRM(Frame, ...)
	local id = ...

	if APR.DebugMode then
		DebugPrint("In APR.Events:LOOT_BIND_CONFIRM")
		DebugPrint("Frame is " .. Frame)
		DebugPrint("id is " .. id)
		APR.Utilities.PrintVarArgs(...)
	end -- if APR.DebugMode

	-- If the user didn't ask us to hide this popup, just return.
	if not APR.DB.HideBind then
		DebugPrint("HideBind off, not auto confirming")
		return
	end

	-- When harvesting (mining, herbing, or skinning) in WoD, you can get a Primal Spirit. This is a BoP item that will trigger this event when found on a mob corpse. Prior to patch 7.0.3, getting a PS while harvesting would not trigger this event (since there was never a scenario where someone else in the group could get the PS). For some reason, with 7.0.3, looting a PS on a harvest WILL trigger this event, even if you're solo. Worse, there are several problems.
	-- 1: The parameters passed in will be wrong; it doesn't pass in the Frame; instead, the id is passed in as the first parameter.
	-- 2: The ConfirmLootSlot() call is ignored. Effectively, it requires the user to click on the PS in the loot window to pick it up. If the user doesn't have autoloot turned on, it requires two total clicks to loot the PS.
	-- The real fix here that this event should never trigger on a harvest; only on a kill loot. This is a Blizzard bug that has to be fixed from their end. In the meantime, I've put in the if/elseif below to handle this odd scenario.
	-- The bug noted above was fixed some time during or after the patch 7.0.3 era.

	if id then
		DebugPrint("id is valid.")
		ConfirmLootSlot(id)
	elseif Frame then
		DebugPrint("id is null, confirming with Frame.")
		ConfirmLootSlot(Frame)

	--		-- Testing whether double-Confirming would help. It didn't. :(
	--		DebugPrint("Verifying if slot is empty.")
	--		if LootSlotHasItem(Frame) then
	--			DebugPrint("Loot slot still has item; attempting to re-loot.")
	--			-- LootSlot(Frame) -- don't do this! This retriggers the same event recursively and infinitely, leading to a stack overflow.
	--			ConfirmLootSlot(Frame)
	--		else
	--			DebugPrint("Loot slot is empty.")
	--		end
	end
end -- APR.Events:LOOT_BIND_CONFIRM()


-- Rolling on a BOP item triggers this event.
function APR.Events:CONFIRM_LOOT_ROLL(...)
	if APR.DebugMode then
		DebugPrint("In APR.Events:CONFIRM_LOOT_ROLL")
		APR.Utilities.PrintVarArgs(...)
	end -- if APR.DebugMode

	local id, rollType = ...

	DebugPrint("id is " .. id)
	DebugPrint("rollType is " .. rollType)

	-- If the user didn't ask us to hide this popup, just return.
	if not APR.DB.HideRoll then
		DebugPrint("HideRoll off, not auto confirming")
		return
	end

	ConfirmLootRoll(id, rollType)
end -- APR.Events:CONFIRM_LOOT_ROLL()

if not IsClassic then
	-- Depositing an item that's modified (gemmed, enchanted, or transmogged) or a BOP item still tradable in group triggers this event.
	function APR.Events:VOID_DEPOSIT_WARNING(...)
		if APR.DebugMode then
			DebugPrint("In APR.Events:VOID_DEPOSIT_WARNING")
			APR.Utilities.PrintVarArgs(...)
		end -- if APR.DebugMode

		-- Document the incoming parameters.
		local slot, itemLink = ...
		DebugPrint("slot is " .. slot)

		-- If the user didn't ask us to hide this popup, just return.
		if not APR.DB.HideVoid then
			DebugPrint("HideVoid off, not auto confirming")
			return
		end

		-- prior to this event firing, the game triggers "VOID_STORAGE_DEPOSIT_UPDATE", which disables the transfer button and pops up the dialog.
		-- So, we simulate clicking OK with the UpdateTransferButton, and pass "nil" to indicate the warning dialog isn't showing.
		VoidStorage_UpdateTransferButton(nil)
	end -- APR.Events:VOID_DEPOSIT_WARNING()
else
	DebugPrint("Classic detected, not registering APR.Events:VOID_DEPOSIT_WARNING")
end -- if not IsClassic

-- Vendoring an item that was group-looted and is still tradable in the group triggers this.
function APR.Events:MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL(...)
	if APR.DebugMode then
		DebugPrint("In APR.Events:MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL")
		APR.Utilities.PrintVarArgs(...)
	end -- if APR.DebugMode

	if IsClassic then
		DebugPrint("in APR.Events:MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL, Classic detected, aborting")
		return
	end

	-- Document the incoming parameters.
	local item = ... -- this is an item link.
	DebugPrint("item is " .. item)

	-- If the user didn't ask us to hide this popup, just return.
	if not APR.DB.HideVendor then
		DebugPrint("HideVendor off, not auto confirming")
		return
	end

	-- Sell the item.
	SellCursorItem()
end -- APR.Events:MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL()


-- Mailing an item that was vendor-bought and is still refundable triggers this.
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


--#########################################
--# Event hooks - Addon setup
--#########################################

-- On-load handler for addon initialization.
function APR.Events:PLAYER_LOGIN(...)
	DebugPrint("In PLAYER_LOGIN")

	-- Load the saved variables, or initialize if they don't exist yet.
	if APR_DB then
		DebugPrint("Loading existing saved var.")
		if nil == APR_DB.HideBind then
			APR_DB.HideBind = HIDE_DIALOG
			DebugPrint("HideBind initialized to true.")
		end
		if nil == APR_DB.HideRoll then
			APR_DB.HideRoll = HIDE_DIALOG
			DebugPrint("HideRoll initialized to true.")
		end
		if nil == APR_DB.HideDelete then
			APR_DB.HideDelete = HIDE_DIALOG
			DebugPrint("HideDelete initialized to true.")
		end
		if nil == APR_DB.HideMail then
			APR_DB.HideMail = HIDE_DIALOG
			DebugPrint("HideMail initialized to true.")
		end
		if nil == APR_DB.PrintStartupMessage then
			APR_DB.PrintStartupMessage = PRINT_STARTUP
			DebugPrint("PrintStartupMessage initialized to true.")
		end
		if not IsClassic then
			if nil == APR_DB.HideVoid then
				APR_DB.HideVoid = HIDE_DIALOG
				DebugPrint("HideVoid initialized to true.")
			end
			if nil == APR_DB.HideVendor then
				APR_DB.HideVendor = HIDE_DIALOG
				DebugPrint("HideVendor initialized to true.")
			end
		end
		DebugPrint("Applying saved settings.")
		APR.DB = APR_DB
	else
		DebugPrint("No saved var, setting defaults.")
		APR.DB = {
			HideBind = HIDE_DIALOG,
			HideRoll = HIDE_DIALOG,
			HideDelete = HIDE_DIALOG,
			HideMail = HIDE_DIALOG,
			PrintStartupMessage = PRINT_STARTUP,
		}
		if not IsClassic then
			APR.DB.HideVendor = HIDE_DIALOG
			APR.DB.HideVoid = HIDE_DIALOG
		end
	end

	DebugPrint("HideBind is " .. (APR.DB.HideBind and "true" or "false"))
	DebugPrint("HideRoll is " .. (APR.DB.HideRoll and "true" or "false"))
	DebugPrint("HideDelete is " .. (APR.DB.HideDelete and "true" or "false"))
	DebugPrint("HideMail is " .. (APR.DB.HideMail and "true" or "false"))

	if not IsClassic then
		DebugPrint("HideVoid is " .. (APR.DB.HideVoid and "true" or "false"))
		DebugPrint("HideVendor is " .. (APR.DB.HideVendor and "true" or "false"))
	end

	-- Announce our load.
	DebugPrint("APR.DB.PrintStartupMessage is " .. (APR.DB.PrintStartupMessage and "true" or "false"))
	if APR.DB.PrintStartupMessage then
		ChatPrint(APR.USER_ADDON_NAME .. " " .. APR.Version .. " " .. L["loaded"] .. ". " .. L["For help and options, type /apr"])
	end

	-- Hide the dialogs the user has selected.
	-- In this scenario, the DB variable is already true, but the dialog has not yet been hidden. So, we pass FORCE_HIDE_DIALOG to forcibly hide the dialogs.
	if APR.DB.HideBind then APR:HidePopupBind(NO_CONFIRMATION, FORCE_HIDE_DIALOG) end
	if APR.DB.HideRoll then APR:HidePopupRoll(NO_CONFIRMATION, FORCE_HIDE_DIALOG) end
	if APR.DB.HideDelete then APR:HidePopupDelete(NO_CONFIRMATION, FORCE_HIDE_DIALOG) end
	if APR.DB.HideMail then APR:HidePopupMail(NO_CONFIRMATION, FORCE_HIDE_DIALOG) end

	if not IsClassic then
		-- Force the default Void Storage frame to load so we can override it
		local isloaded, reason = LoadAddOn("Blizzard_VoidStorageUI")
		DebugPrint("Blizzard_VoidStorageUI isloaded is " .. (isloaded and "true" or "false"))
		DebugPrint("Blizzard_VoidStorageUI reason is " .. (reason and reason or "nil"))

		-- Hide the non-Classic dialogs
		if APR.DB.HideVoid then APR:HidePopupVoid(NO_CONFIRMATION, FORCE_HIDE_DIALOG) end
		if APR.DB.HideVendor then APR:HidePopupVendor(NO_CONFIRMATION, FORCE_HIDE_DIALOG) end
	end
end -- APR.Events:PLAYER_LOGIN()


-- Save the db on logout.
function APR.Events:PLAYER_LOGOUT(...)
	DebugPrint("In PLAYER_LOGOUT, saving DB.")
	APR_DB = APR.DB
end -- APR.Events:PLAYER_LOGOUT()


--#########################################
--# Implement the event handlers
--#########################################

-- Create the event handler function.
APR.Frame:SetScript("OnEvent", function(self, event, ...)
	APR.Events[event](self, ...) -- call one of the functions above
end)

-- Register all events for which handlers have been defined
for k, v in pairs(APR.Events) do
	DebugPrint("Registering event " .. k)
	APR.Frame:RegisterEvent(k)
end

