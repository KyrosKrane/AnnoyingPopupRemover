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
--# Localization
--#########################################

-- This bit of meta-magic makes it so that if we call L with a key that doesn't yet exist, a key is created automatically, and its value is the name of the key.  For example, if L["MyAddon"] doesn't exist, and I run print (L["MyAddon"]), the __index command causes the L table to automatically create a new key called MyAddon, and its value is set to tostring("MyAddon") -- same as the key name.
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


--#########################################
--# Global Variables
--#########################################

-- Define a global for our namespace
local APR = { }

-- Define whether we're in debug mode or production mode. True means debug; false means production.
APR.DebugMode = false

--@alpha@
APR.DebugMode = true
--@end-alpha@

-- Set the internal and human-readable names for the addon.
APR.ADDON_NAME = "AnnoyingPopupRemover" -- Don't localize this
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
if (IsClassic) then
	APR.OptionsTable.args.remove(void)
	APR.OptionsTable.args.remove(vendor)
end

-- Process the options and create the AceConfig options table
APR.AceConfigReg = LibStub("AceConfigRegistry-3.0")
APR.AceConfigReg:RegisterOptionsTable(APR.ADDON_NAME, APR.OptionsTable)

-- Create the slash command handler
APR.AceConfigCmd = LibStub("AceConfigCmd-3.0")
APR.AceConfigCmd:CreateChatCommand("apr", APR.ADDON_NAME)

-- Create the frame to set the options and add it to the Blizzard settings
APR.ConfigFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(APR.ADDON_NAME, APR.USER_ADDON_NAME)


--#########################################
--# Utility Functions
--#########################################

-- Print debug output to the chat frame.
function APR:DebugPrint(...)
	if (APR.DebugMode) then
		print ("|cff" .. "a00000" .. L["APR"] .. " " .. L["Debug"] .. ":|r", ...)
	end
end -- APR:DebugPrint


-- Print standard output to the chat frame.
function APR:ChatPrint(...)
	print ("|cff" .. "0066ff" .. L["APR"] ..":|r", ...)
end -- APR:ChatPrint()


-- Debugging code to see what the hell is being passed in...
function APR:PrintVarArgs(...)
	local n = select('#', ...)
	APR:DebugPrint ("There are ", n, " items in varargs.")
	local msg
	for i = 1, n do
		msg = select(i, ...)
		APR:DebugPrint ("Item ", i, " is ", msg)
	end
end -- APR:PrintVarArgs()


-- Dumps a table into chat. Not intended for production use.
function APR:DumpTable(tab, indent)
	if not indent then indent = 0 end
	if indent > 10 then
		APR:DebugPrint("Recursion is at 11 already; aborting.")
		return
	end
	for k, v in pairs(tab) do
		local s = ""
		if indent > 0 then
			for i = 0, indent do
				s = s .. "    "
			end
		end
		if "table" == type(v) then
			s = s .. "Item " .. k .. " is sub-table."
			APR:DebugPrint(s)
			indent = indent + 1
			APR:DumpTable(v, indent)
			indent = indent - 1
		else
			s = s .. "Item " .. k .. " is " .. tostring(v)
			APR:DebugPrint(s)
		end
	end
end -- APR:DumpTable()


-- Splits a string into sections, based on a specified separator.
-- Split text into a list consisting of the strings in text,
-- separated by strings matching delimiter (which may be a pattern).
-- example: APR:strsplit(",%s*", "Anna, Bob, Charlie,Dolores")
-- Adapted from Lua manual: http://lua-users.org/wiki/SplitJoin
function APR:strsplit(delimiter, text)
	local list = {}
	local pos = 1
	if strfind("", delimiter, 1) then
		-- this would result in endless loops
		-- error("delimiter matches empty string!")

		-- return the entire string instead.
		tinsert(list, text)
		return list
	end
	while 1 do
		local first, last = strfind(text, delimiter, pos)
		if first then -- found?
			tinsert(list, strsub(text, pos, first-1))
			pos = last+1
		else
			tinsert(list, strsub(text, pos))
			break
		end
	end
	return list
end -- APR:strsplit()


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
			APR:ChatPrint (L["Confirmation pop-up when |cff00ff00looting|r bind-on-pickup items will be |cff00ff00hidden|r."])
		else
			APR:ChatPrint (L["Confirmation pop-up when |cffff0000looting|r bind-on-pickup items will be |cffff0000shown|r."])
		end
	end
	if not popup or "roll" == popup then
		if APR.DB.HideRoll then
			APR:ChatPrint (L["Confirmation pop-up when |cff00ff00rolling|r on bind-on-pickup items will be |cff00ff00hidden|r."])
		else
			APR:ChatPrint (L["Confirmation pop-up when |cffff0000rolling|r on bind-on-pickup items will be |cffff0000shown|r."])
		end
	end
	if not IsClassic and (not popup or "void" == popup) then
		if APR.DB.HideVoid then
			APR:ChatPrint (L["Confirmation pop-up when depositing modified items into |cff00ff00void storage|r will be |cff00ff00hidden|r."])
		else
			APR:ChatPrint (L["Confirmation pop-up when depositing modified items into |cffff0000void storage|r will be |cffff0000shown|r."])
		end
	end
	if not IsClassic and (not popup or "vendor" == popup) then
		if APR.DB.HideVendor then
			APR:ChatPrint (L["Confirmation pop-up when selling group-looted items to a |cff00ff00vendor|r will be |cff00ff00hidden|r."])
		else
			APR:ChatPrint (L["Confirmation pop-up when selling group-looted items to a |cff00ff00vendor|r will be |cffff0000shown|r."])
		end
	end
	if not popup or "delete" == popup then
		if APR.DB.HideDelete then
			APR:ChatPrint (L["|cff00ff00Deleting \"good\" items|r will |cff00ff00not require|r typing the word \"delete\"."])
		else
			APR:ChatPrint (L["|cff00ff00Deleting \"good\" items|r will |cffff0000require|r typing the word \"delete\"."])
		end
	end
	if not popup or "mail" == popup then
		if APR.DB.HideVendor then
			APR:ChatPrint (L["Confirmation pop-up when |cff00ff00mail|ring refundable items will be |cff00ff00hidden|r."])
		else
			APR:ChatPrint (L["Confirmation pop-up when |cff00ff00mail|ring refundable items will be |cffff0000shown|r."])
		end
	end
end -- APR:PrintStatus()


--#########################################
--# Toggle state
--#########################################

-- Dispatcher function to call the correct show or hide function for the appropriate popup window.
-- popup is required, state and ConfState are optional
function APR:TogglePopup(popup, state, ConfState)

	APR:DebugPrint("in TogglePopup, popup = " .. popup .. ", state is " .. (state and state or "nil") .. ", ConfState is " .. (ConfState == nil and "nil" or (ConfState and "true" or "false")))

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
				APR:DebugPrint("Error in APR:TogglePopup: unknown state " .. state .. " for popup type " .. popup .. " passed in.")
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
				APR:DebugPrint("Error in APR:TogglePopup: unknown state " .. state .. " for popup type " .. popup .. " passed in.")
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

	elseif "void" == popup then
		if state then
			if "show" == state then
				APR:ShowPopupVoid(ShowConf)
			elseif "hide" == state then
				APR:HidePopupVoid(ShowConf)
			else
				-- error, bad programmer, no cookie!
				APR:DebugPrint("Error in APR:TogglePopup: unknown state " .. state .. " for popup type " .. popup .. " passed in.")
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

	elseif "vendor" == popup then
		if state then
			if "show" == state then
				APR:ShowPopupVendor(ShowConf)
			elseif "hide" == state then
				APR:HidePopupVendor(ShowConf)
			else
				-- error, bad programmer, no cookie!
				APR:DebugPrint("Error in APR:TogglePopup: unknown state " .. state .. " for popup type " .. popup .. " passed in.")
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
				APR:DebugPrint("Error in APR:TogglePopup: unknown state " .. state .. " for popup type " .. popup .. " passed in.")
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
				APR:DebugPrint("Error in APR:TogglePopup: unknown state " .. state .. " for popup type " .. popup .. " passed in.")
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
		APR:DebugPrint("Error in APR:TogglePopup: unknown popup type " .. popup .. " passed in.")
		return false
	end
end -- APR:TogglePopup()


function APR:SetDebug(mode)
	if mode then
		APR.DebugMode = true
		APR:ChatPrint (L["Debug mode is now on."])
	else
		APR.DebugMode = false
		APR:ChatPrint (L["Debug mode is now off."])
	end
end -- APR:SetDebug()


function APR:ToggleStartupMessage(mode, ConfState)
	APR:DebugPrint("in ToggleStartupMessage, mode = " .. mode .. ", ConfState is " .. (ConfState == nil and "nil" or (ConfState and "true" or "false")))

	-- Check if a confirmation message should be printed. This is only needed when a change is made from the command line, not from the config UI.
	local ShowConf = PRINT_CONFIRMATION
	if ConfState ~= nil then
		ShowConf = ConfState
	end

	if "show" == mode then
		APR.DB.PrintStartupMessage = PRINT_STARTUP
		if ShowConf then APR:ChatPrint (L["Startup announcement message will printed in your chat frame at login."]) end
	elseif "hide" == mode then
		APR.DB.PrintStartupMessage = HIDE_STARTUP
		if ShowConf then APR:ChatPrint (L["Startup announcement message will NOT printed in your chat frame at login."]) end
	else
		-- error, bad programmer, no cookie!
		APR:DebugPrint("Error in APR:ToggleStartupMessage: unknown mode " .. mode .. " passed in.")
		return false
	end
end -- APR:ToggleStartupMessage()


--#########################################
--# Dialog toggling functions
--#########################################

-- Show and hide functions for each of the supported types
-- not documenting individually, as it should be clear what they do.

function APR:ShowPopupBind(printconfirm)
	APR:DebugPrint ("in APR:ShowPopupBind, printconfirm is " .. (printconfirm and "true" or "false"))
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
	APR:DebugPrint ("in APR:ShowPopupRoll, printconfirm is " .. (printconfirm and "true" or "false"))
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
	APR:DebugPrint ("in APR:ShowPopupVoid, printconfirm is " .. (printconfirm and "true" or "false"))
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
	APR:DebugPrint ("in APR:ShowPopupVendor, printconfirm is " .. (printconfirm and "true" or "false"))
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
	APR:DebugPrint ("in APR:ShowPopupDelete, printconfirm is " .. (printconfirm and "true" or "false"))
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
	APR:DebugPrint ("in APR:ShowPopupMail, printconfirm is " .. (printconfirm and "true" or "false"))
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
	APR:DebugPrint ("in APR:HidePopupBind, printconfirm is " .. (printconfirm and "true" or "false") .. ", ForceHide is " .. (ForceHide == nil and "nil" or (ForceHide and "true" or "false")))
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
	APR:DebugPrint ("in APR:HidePopupRoll, printconfirm is " .. (printconfirm and "true" or "false") .. ", ForceHide is " .. (ForceHide == nil and "nil" or (ForceHide and "true" or "false")))
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
	APR:DebugPrint ("in APR:HidePopupVoid, printconfirm is " .. (printconfirm and "true" or "false") .. ", ForceHide is " .. (ForceHide == nil and "nil" or (ForceHide and "true" or "false")))
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
	APR:DebugPrint ("in APR:HidePopupVendor, printconfirm is " .. (printconfirm and "true" or "false") .. ", ForceHide is " .. (ForceHide == nil and "nil" or (ForceHide and "true" or "false")))
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
	APR:DebugPrint ("in APR:HidePopupDelete, printconfirm is " .. (printconfirm and "true" or "false") .. ", ForceHide is " .. (ForceHide == nil and "nil" or (ForceHide and "true" or "false")))
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
	APR:DebugPrint ("in APR:HidePopupMail, printconfirm is " .. (printconfirm and "true" or "false") .. ", ForceHide is " .. (ForceHide == nil and "nil" or (ForceHide and "true" or "false")))
	if not APR.DB.HideMail or ForceHide then
		-- Disable the dialog for mailing refundable items while still tradable.
		APR.StoredDialogs["CONFIRM_MAIL_ITEM_UNREFUNDABLE"] = StaticPopupDialogs["CONFIRM_MAIL_ITEM_UNREFUNDABLE"]
		StaticPopupDialogs["CONFIRM_MAIL_ITEM_UNREFUNDABLE"] = nil

		-- Mark that the dialog is hidden.
		APR.DB.HideMail = HIDE_DIALOG

	-- else already hidden, nothing to do.
	end

	if printconfirm then APR:PrintStatus("vendor") end
end -- APR:HidePopupMail()


--#########################################
--# Event hooks - Processing
--#########################################

-- Looting a BOP item triggers this event.
function APR.Events:LOOT_BIND_CONFIRM(Frame, ...)
	local id = ...

	if (APR.DebugMode) then
		APR:DebugPrint ("In APR.Events:LOOT_BIND_CONFIRM")
		APR:DebugPrint ("Frame is ", Frame)
		APR:DebugPrint ("id is ", id)
		APR:PrintVarArgs(...)
	end -- if APR.DebugMode

	-- If the user didn't ask us to hide this popup, just return.
	if not APR.DB.HideBind then
		APR:DebugPrint ("HideBind off, not auto confirming")
		return
	end

	-- When harvesting (mining, herbing, or skinning) in WoD, you can get a Primal Spirit. This is a BoP item that will trigger this event when found on a mob corpse. Prior to patch 7.0.3, getting a PS while harvesting would not trigger this event (since there was never a scenario where someone else in the group could get the PS). For some reason, with 7.0.3, looting a PS on a harvest WILL trigger this event, even if you're solo. Worse, there are several problems.
	-- 1: The parameters passed in will be wrong; it doesn't pass in the Frame; instead, the id is passed in as the first parameter.
	-- 2: The ConfirmLootSlot() call is ignored. Effectively, it requires the user to click on the PS in the loot window to pick it up. If the user doesn't have autoloot turned on, it requires two total clicks to loot the PS.
	-- The real fix here that this event should never trigger on a harvest; only on a kill loot. This is a Blizzard bug that has to be fixed from their end. In the meantime, I've put in the if/elseif below to handle this odd scenario.
	-- The bug noted above was fixed some time during or after the patch 7.0.3 era.

	if id then
		APR:DebugPrint ("id is valid.")
		ConfirmLootSlot(id)
	elseif Frame then
		APR:DebugPrint ("id is null, confirming with Frame.")
		ConfirmLootSlot(Frame)

--		-- Testing whether double-Confirming would help. It didn't. :(
--		APR:DebugPrint ("Verifying if slot is empty.")
--		if LootSlotHasItem(Frame) then
--			APR:DebugPrint ("Loot slot still has item; attempting to re-loot.")
--			-- LootSlot(Frame) -- don't do this! This retriggers the same event recursively and infinitely, leading to a stack overflow.
--			ConfirmLootSlot(Frame)
--		else
--			APR:DebugPrint ("Loot slot is empty.")
--		end
	end
end -- APR.Events:LOOT_BIND_CONFIRM()


-- Rolling on a BOP item triggers this event.
function APR.Events:CONFIRM_LOOT_ROLL(...)
	if (APR.DebugMode) then
		APR:DebugPrint ("In APR.Events:CONFIRM_LOOT_ROLL")
		APR:PrintVarArgs(...)
	end -- if APR.DebugMode

	local id, rollType = ...

	APR:DebugPrint ("id is ", id)
	APR:DebugPrint ("rollType is ", rollType)

	-- If the user didn't ask us to hide this popup, just return.
	if not APR.DB.HideRoll then
		APR:DebugPrint ("HideRoll off, not auto confirming")
		return
	end

	ConfirmLootRoll(id, rollType)
end -- APR.Events:CONFIRM_LOOT_ROLL()


-- Depositing an item that's modified (gemmed, enchanted, or transmogged) or a BOP item still tradable in group triggers this event.
function APR.Events:VOID_DEPOSIT_WARNING(...)
	if (APR.DebugMode) then
		APR:DebugPrint ("In APR.Events:VOID_DEPOSIT_WARNING")
		APR:PrintVarArgs(...)
	end -- if APR.DebugMode

	-- Document the incoming parameters.
	local slot, itemLink = ...
	APR:DebugPrint ("slot is ", slot)

	-- If the user didn't ask us to hide this popup, just return.
	if not APR.DB.HideVoid then
		APR:DebugPrint ("HideVoid off, not auto confirming")
		return
	end

	-- prior to this event firing, the game triggers "VOID_STORAGE_DEPOSIT_UPDATE", which disables the transfer button and pops up the dialog.
	-- So, we simulate clicking OK with the UpdateTransferButton, and pass "nil" to indicate the warning dialog isn't showing.
	VoidStorage_UpdateTransferButton(nil)
end -- APR.Events:VOID_DEPOSIT_WARNING()


-- Vendoring an item that was group-looted and is still tradable in the group triggers this.
function APR.Events:MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL(...)
	if (APR.DebugMode) then
		APR:DebugPrint ("In APR.Events:MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL")
		APR:PrintVarArgs(...)
	end -- if APR.DebugMode

	-- Document the incoming parameters.
	local item = ... -- this is an item link.
	APR:DebugPrint ("item is ", item)

	-- If the user didn't ask us to hide this popup, just return.
	if not APR.DB.HideVendor then
		APR:DebugPrint ("HideVendor off, not auto confirming")
		return
	end

	-- Sell the item.
	SellCursorItem()
end -- APR.Events:MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL()


-- Mailing an item that was vendor-bought and is still refundable triggers this.
function APR.Events:MAIL_LOCK_SEND_ITEMS(...)
	if (APR.DebugMode) then
		APR:DebugPrint ("In APR.Events:MAIL_LOCK_SEND_ITEMS")
		APR:PrintVarArgs(...)
	end -- if APR.DebugMode

	-- Document the incoming parameters.
	local mailSlot, itemLink = ...
	APR:DebugPrint ("mailSlot is ", mailSlot, ", itemLink is ", itemLink)

	-- If the user didn't ask us to hide this popup, just return.
	if not APR.DB.HideMail then
		APR:DebugPrint ("HideMail off, not auto confirming")
		return
	end

	-- Confirm the mail.
	RespondMailLockSendItem(mailSlot, true)
end -- APR.Events:MAIL_LOCK_SEND_ITEMS()


-- For debugging only.
function APR.Events:VOID_STORAGE_DEPOSIT_UPDATE(...)
	-- We don't actually do anything in this function; it's just for debugging.
	if (not APR.DebugMode) then return end

	APR:DebugPrint ("In APR.Events:VOID_STORAGE_DEPOSIT_UPDATE")
	APR:PrintVarArgs(...)

	-- Document the incoming parameters.
	-- local slot = ...

end -- APR.Events:VOID_STORAGE_DEPOSIT_UPDATE()


-- On-load handler for addon initialization.
function APR.Events:PLAYER_LOGIN(...)
	-- Announce our load.
	if APR.DB.PrintStartupMessage then
		APR:ChatPrint (APR.USER_ADDON_NAME .. " " .. APR.Version .. " " .. L["loaded"] .. ". " .. L["For help and options, type /apr"])
	end

	-- Force the default Void Storage frame to load so we can override it.
	local isloaded, reason = LoadAddOn("Blizzard_VoidStorageUI")
	APR:DebugPrint ("Blizzard_VoidStorageUI isloaded is ", isloaded)
	APR:DebugPrint ("Blizzard_VoidStorageUI reason is ", reason)
end -- APR.Events:PLAYER_LOGIN()


--#########################################
--# Event hooks - Addon setup
--#########################################

function APR.Events:ADDON_LOADED(addon)
	APR:DebugPrint ("Got ADDON_LOADED for " .. addon)
	if addon == "AnnoyingPopupRemover" then
		-- Load the saved variables, or initialize if they don't exist yet.
		if APR_DB then
			APR:DebugPrint ("Loading existing saved var.")
			if nil == APR_DB.HideBind then
				APR_DB.HideBind = HIDE_DIALOG
				APR:DebugPrint ("HideBind initialized to true.")
			end
			if nil == APR_DB.HideRoll then
				APR_DB.HideRoll = HIDE_DIALOG
				APR:DebugPrint ("HideRoll initialized to true.")
			end
			if nil == APR_DB.HideVoid then
				APR_DB.HideVoid = HIDE_DIALOG
				APR:DebugPrint ("HideVoid initialized to true.")
			end
			if nil == APR_DB.HideVendor then
				APR_DB.HideVendor = HIDE_DIALOG
				APR:DebugPrint ("HideVendor initialized to true.")
			end
			if nil == APR_DB.HideDelete then
				APR_DB.HideDelete = HIDE_DIALOG
				APR:DebugPrint ("HideDelete initialized to true.")
			end
			if nil == APR_DB.HideMail then
				APR_DB.HideMail = HIDE_DIALOG
				APR:DebugPrint ("HideMail initialized to true.")
			end
			if nil == APR_DB.PrintStartupMessage then
				APR_DB.PrintStartupMessage = PRINT_STARTUP
				APR:DebugPrint ("PrintStartupMessage initialized to true.")
			end
			APR:DebugPrint ("Applying saved settings.")
			APR.DB = APR_DB
		else
			APR:DebugPrint ("No saved var, setting defaults.")
			APR.DB = {
				HideBind = HIDE_DIALOG,
				HideRoll = HIDE_DIALOG,
				HideVoid = HIDE_DIALOG,
				HideVendor = HIDE_DIALOG,
				HideDelete = HIDE_DIALOG,
				HideMail = HIDE_DIALOG,
				PrintStartupMessage = PRINT_STARTUP,
			}
		end

		APR:DebugPrint ("HideBind is " .. (APR.DB.HideBind and "true" or "false"))
		APR:DebugPrint ("HideRoll is " .. (APR.DB.HideRoll and "true" or "false"))
		APR:DebugPrint ("HideVoid is " .. (APR.DB.HideVoid and "true" or "false"))
		APR:DebugPrint ("HideVendor is " .. (APR.DB.HideVendor and "true" or "false"))
		APR:DebugPrint ("HideDelete is " .. (APR.DB.HideDelete and "true" or "false"))
		APR:DebugPrint ("HideMail is " .. (APR.DB.HideMail and "true" or "false"))

		-- Hide the dialogs the user has selected.
		-- In this scenario, the DB variable is already true, but the dialog has not yet been hidden. So, we pass FORCE_HIDE_DIALOG to forcibly hide the dialogs.
		if APR.DB.HideBind then APR:HidePopupBind(NO_CONFIRMATION, FORCE_HIDE_DIALOG) end
		if APR.DB.HideRoll then APR:HidePopupRoll(NO_CONFIRMATION, FORCE_HIDE_DIALOG) end
		if APR.DB.HideVoid then APR:HidePopupVoid(NO_CONFIRMATION, FORCE_HIDE_DIALOG) end
		if APR.DB.HideVendor then APR:HidePopupVendor(NO_CONFIRMATION, FORCE_HIDE_DIALOG) end
		if APR.DB.HideDelete then APR:HidePopupDelete(NO_CONFIRMATION, FORCE_HIDE_DIALOG) end
		if APR.DB.HideMail then APR:HidePopupMail(NO_CONFIRMATION, FORCE_HIDE_DIALOG) end

	end -- if AnnoyingPopupRemover
end -- APR.Events:ADDON_LOADED()


-- Save the db on logout.
function APR.Events:PLAYER_LOGOUT(...)
	APR:DebugPrint ("In PLAYER_LOGOUT, saving DB.")
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
	APR:DebugPrint ("Registering event ", k)
	APR.Frame:RegisterEvent(k)
end

