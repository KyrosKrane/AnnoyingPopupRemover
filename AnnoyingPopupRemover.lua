-- AnnoyingPopupRemover.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2015-2020 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

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
--# Parameters
--#########################################

-- Grab the WoW-defined addon folder name and storage table for our addon
local addonName, APR = ...

-- Get the localization details from our external setup file
local L = APR.L


--#########################################
--# Local references (for readability and speed)
--#########################################

local DebugPrint = APR.Utilities.DebugPrint
local ChatPrint = APR.Utilities.ChatPrint
local MakeString = APR.Utilities.MakeString
local pairs = pairs


--#########################################
--# Global Variables
--#########################################

-- Set the human-readable name for the addon.
APR.USER_ADDON_NAME = L["Annoying Pop-up Remover"]

-- Set the current version so we can display it.
APR.Version = "@project-version@"


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

			-- Annoyances should be ordered between 101-299


		AddonOptionsHeader = {
			name = L["Addon Options"],
			type = "header",
			order = 300,
		}, -- AddonOptionsHeader

			-- Addon options should be between 301 and 399

		startup = {
			name = L["Show a startup announcement message in your chat frame at login"],
			type = "toggle",
			set = function(info,val) APR:HandleAceSettingsChange(val, info) end,
			get = function(info) return APR.DB.PrintStartupMessage end,
			descStyle = "inline",
			width = "full",
			order = 310,
		}, -- startup


		-- Hidden options should be between 701 and 799

		debug = {
			name = "Enable debug output",
			desc = string.format("%s%s%s", L["Prints extensive debugging output about everything "], APR.USER_ADDON_NAME, L[" does"]),
			type = "toggle",
			set = function(info,val) APR:SetDebug(val) end,
			get = function(info) return APR.DebugMode end,
			descStyle = "inline",
			width = "full",
			hidden = true,
			order = 710,
		}, -- debug


		-- Other items should be 800+

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


-- Programmatically add the settings for each module
for ModuleName, ModuleSettings in pairs(APR.Modules) do
	if (not APR.IsClassic or APR.Modules[ModuleName].WorksInClassic) then
		APR.OptionsTable.args[ModuleName] = ModuleSettings.config
	end
end


-- Process the options and create the AceConfig options table
local AceName = APR.USER_ADDON_NAME .. APR.Version
APR.AceConfigReg = LibStub("AceConfigRegistry-3.0")
APR.AceConfigReg:RegisterOptionsTable(AceName, APR.OptionsTable)

-- Create the slash command handler
APR.AceConfigCmd = LibStub("AceConfigCmd-3.0")
APR.AceConfigCmd:CreateChatCommand("apr", AceName)

-- Create the frame to set the options and add it to the Blizzard settings
APR.ConfigFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(AceName, APR.USER_ADDON_NAME)


--#########################################
--# Slash command handling
--#########################################

-- This dispatcher handles settings from the AceConfig setup.
-- value is the true/false value (or other setting) we get from Ace
-- AceInfo is the info table provided by AceConfig, used to determine the option and whether a slash command was used or not
function APR:HandleAceSettingsChange(value, AceInfo)

	-- Check whether a slash command was used, which determines whether a confirmation message is needed
	local ShowConf = APR.NO_CONFIRMATION
	if AceInfo[0] and AceInfo[0] ~= "" then
		-- This was a slash command. Print a confirmation.
		ShowConf = APR.PRINT_CONFIRMATION
	end

	-- Check which option the user toggled
	local option = AceInfo[#AceInfo]

	-- This variable holds the "show/hide" instruction used in the toggling functions.
	local TextAction = value and "hide" or "show"

	-- Check for toggling a pop-up off or on
	if (APR.Modules[option] ~= nil) then
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

-- Prints the status for a single popup type
-- popup is required.
function APR:PrintStatusSingle(popup)
	if not popup then return false end

	if (not APR.IsClassic or APR.Modules[popup].WorksInClassic) then
		if APR.DB[APR.Modules[popup].DBName] then
			ChatPrint(APR.Modules[popup].hidden_msg)
		else
			ChatPrint(APR.Modules[popup].shown_msg)
		end
	end
end

-- Print the status for a given popup type, or for all if not specified.
-- popup is optional
function APR:PrintStatus(popup)
	if not popup then
		-- No specific popup requested, so cycle through all and give status

		-- The ordering of the keys inside the Modules table is arbitrary.
		-- So, to give a consistent UX, we will create a table keyed off the ordering of the modules, sort that, and then print them in that order.

		-- First, gather the relevant data into a single array, and map the ordering to the module names.
		local OrderValues, OrderToModuleNameMapping = {}, {}

		for ModuleName, Settings in pairs(APR.Modules) do
			-- (Note that ModuleName is equivalent to the passed-in popup in this context.)

			if (not APR.IsClassic or Settings.WorksInClassic) then
				table.insert(OrderValues, Settings.config.order)
				OrderToModuleNameMapping[Settings.config.order] = ModuleName;
			end
		end -- for each module

		-- Next, sort the ordering values
		table.sort(OrderValues)

		-- Finally, map the ordering values (which are now sorted) back to the module names, and extract the needed data for each.
		for _, Order in ipairs(OrderValues) do
			APR:PrintStatusSingle(OrderToModuleNameMapping[Order])
		end -- for each order

	else
		-- One specific popup was requested
		APR:PrintStatusSingle(popup)
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
	local ShowConf = APR.PRINT_CONFIRMATION
	if ConfState ~= nil then
		ShowConf = ConfState
	end

	-- store the passed in value before we go mucking with it
	local PreReplacePopup = popup

	-- Older versions of the addon used the keyword "bind" instead of "loot". Handle the case where a user tries to use the old keyword.
	if "bind" == popup then popup = "loot" end

	-- The words "delete" and "destroy" are synonymous for our purposes. The in-game dialog says "delete", but players refer to it as destroying an item.
	-- We'll follow the game protocol of using the word "delete", but accept "destroy" as well.
	if "destroy" == popup then popup = "delete" end

	DebugPrint("in TogglePopup, After replacing, popup is " .. popup)

	-- Get the settings for the selected popup
	local Settings = APR.Modules[popup]

	if Settings then
		DebugPrint("in TogglePopup, Settings is found.")
		-- Some options don't apply to Classic
		if APR.IsClassic and (not Settings.WorksInClassic) then
			DebugPrint("in TogglePopup, this popup requires Retail and we are in Classic. Aborting")
			return
		end

		if state then
			if "show" == state then
				Settings.ShowPopup(ShowConf)
			elseif "hide" == state then
				Settings.HidePopup(ShowConf)
			else
				-- error, bad programmer, no cookie!
				DebugPrint("Error in APR:TogglePopup: unknown state " .. state .. " for popup type " .. PreReplacePopup .. " passed in.")
				return false
			end
		else
			-- no state specified, so reverse the state. If Hide was on, then show it, and vice versa.
			if APR.DB[Settings.DBName] then
				Settings.ShowPopup(ShowConf)
			else
				Settings.HidePopup(ShowConf)
			end
		end
	else
		-- error, bad programmer, no cookie!
		DebugPrint("Error in APR:TogglePopup: unknown popup type " .. PreReplacePopup .. " passed in. (Parsed as " .. popup .. " after replacement.)")
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
	local ShowConf = APR.PRINT_CONFIRMATION
	if ConfState ~= nil then
		ShowConf = ConfState
	end

	if "show" == mode then
		APR.DB.PrintStartupMessage = APR.PRINT_STARTUP
		if ShowConf then ChatPrint(L["Startup announcement message will printed in your chat frame at login."]) end
	elseif "hide" == mode then
		APR.DB.PrintStartupMessage = APR.HIDE_STARTUP
		if ShowConf then ChatPrint(L["Startup announcement message will NOT printed in your chat frame at login."]) end
	else
		-- error, bad programmer, no cookie!
		DebugPrint("Error in APR:ToggleStartupMessage: unknown mode " .. mode .. " passed in.")
		return false
	end
end -- APR:ToggleStartupMessage()


--#########################################
--# Event hooks - Addon setup
--#########################################

-- On-load handler for addon initialization.
function APR.Events:PLAYER_LOGIN(...)
	DebugPrint("In PLAYER_LOGIN")

	-- Load the saved variables, or initialize if they don't exist yet.
	if APR_DB then
		DebugPrint("Loading existing saved var.")

		for ModuleName, Settings in pairs(APR.Modules) do
			if not APR.IsClassic or Settings.WorksInClassic then
				if nil == APR_DB[Settings.DBName] then
					APR_DB[Settings.DBName] = Settings.DBDefaultValue
					DebugPrint(Settings.DBName .. " in APR_DB initialized to " .. MakeString(Settings.DBDefaultValue) .. ".")
				else
					DebugPrint(Settings.DBName .. " in APR_DB exists as " .. MakeString(Settings.DBDefaultValue) .. ".")
				end
			end
		end

		DebugPrint("Applying saved settings.")
		APR.DB = APR_DB
	else
		DebugPrint("No saved var, setting defaults.")
		APR.DB = {}
		for ModuleName, Settings in pairs(APR.Modules) do
			if not APR.IsClassic or Settings.WorksInClassic then
				APR.DB[Settings.DBName] = Settings.DBDefaultValue
			end
		end

		APR.DB.PrintStartupMessage = APR.PRINT_STARTUP
	end -- if APR_DB

	-- Process the loaded settings
	for ModuleName, Settings in pairs(APR.Modules) do
		if not APR.IsClassic or Settings.WorksInClassic then

			-- If this module has a pre-load function, run it now.
			if Settings.PreloadFunc then Settings.PreloadFunc() end

			-- Hide the dialogs the user has selected.
			-- In this scenario, the DB variable may already be true, but the dialog has not yet been hidden. So, we pass APR.FORCE_HIDE_DIALOG to forcibly hide the dialogs.
			DebugPrint("At load, " .. Settings.DBName .. " is " .. MakeString(APR.DB[Settings.DBName]))
			if APR.DB[Settings.DBName] then
				Settings.HidePopup(APR.NO_CONFIRMATION, APR.FORCE_HIDE_DIALOG)
			end
		end
	end -- processing loaded settings

	-- Announce our load.
	DebugPrint("APR.DB.PrintStartupMessage is " .. MakeString(APR.DB.PrintStartupMessage))
	if APR.DB.PrintStartupMessage then
		ChatPrint(APR.USER_ADDON_NAME .. " " .. APR.Version .. " " .. L["loaded"] .. ". " .. L["For help and options, type /apr"])
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
	APR.Events[event](self, ...) -- call one of the functions defined by the modules or above
end)

-- Register all events for which handlers have been defined
for k, v in pairs(APR.Events) do
	DebugPrint("Registering event " .. k)
	APR.Frame:RegisterEvent(k)
end

