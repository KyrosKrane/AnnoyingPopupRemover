-- module_innkeeper.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2015-2022 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This file defines a module that APR can handle. Each module is one setting or popup.

-- This module removes the popup when setting your hearthstone location at an innkeeper.

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
local ThisModule = "innkeeper"

-- Set up the module
APR.Modules[ThisModule] = {}

-- the name of the variable in APR.DB and its default value
APR.Modules[ThisModule].DBName = "HideInnkeeper"
APR.Modules[ThisModule].DBDefaultValue = APR.HIDE_DIALOG

-- This is the config setup for AceConfig
APR.Modules[ThisModule].config = {
	name = L["Hide the confirmation pop-up when binding at an innkeeper"],
	type = "toggle",
	set = function(info,val) APR:HandleAceSettingsChange(val, info) end,
	get = function(info) return APR.DB.HideInnkeeper end,
	descStyle = "inline",
	width = "full",
} -- config

-- Set the order based on the file inclusion order in the TOC
APR.Modules[ThisModule].config.order = APR.NextOrdering
APR.NextOrdering = APR.NextOrdering + 10

-- These are the status strings that are printed to indicate whether it's off or on
-- @TODO: Remember to add these localized strings to the localization file!
APR.Modules[ThisModule].hidden_msg = L[ThisModule .. "_hidden"]
APR.Modules[ThisModule].shown_msg = L[ThisModule .. "_shown"]

-- This Boolean tells us whether this module works in Classic.
APR.Modules[ThisModule].WorksInClassic = true


-- This function causes the popup to show when triggered.
APR.Modules[ThisModule].ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))
	if APR.DB.HideInnkeeper then
		-- Re-enable the dialog for the event that triggers when binding at an innkeeper.
		StaticPopupDialogs["CONFIRM_BINDER"] = APR.StoredDialogs["CONFIRM_BINDER"]
		APR.StoredDialogs["CONFIRM_BINDER"] = nil

		-- Mark that the dialog is shown.
		APR.DB.HideInnkeeper = APR.SHOW_DIALOG

	-- else already shown, nothing to do.
	end

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
APR.Modules[ThisModule].HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm ) .. ", ForceHide is " .. MakeString(ForceHide))
	if not APR.DB.HideInnkeeper or ForceHide then
		-- Disable the dialog for the event that triggers when binding at an innkeeper.
		APR.StoredDialogs["CONFIRM_BINDER"] = StaticPopupDialogs["CONFIRM_BINDER"]
		StaticPopupDialogs["CONFIRM_BINDER"] = nil

		-- Mark that the dialog is hidden.
		APR.DB.HideInnkeeper = APR.HIDE_DIALOG

	-- else already hidden, nothing to do.
	end

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()


-- Now capture the events that this module has to handle

if not APR.IsClassic or APR.Modules[ThisModule].WorksInClassic then
	-- Requesting a bind at an innkeeper triggers this event.
	function APR.Events:CONFIRM_BINDER(...)
		if APR.DebugMode then
			DebugPrint("In APR.Events:CONFIRM_BINDER")
			APR.Utilities.PrintVarArgs(...)

			-- Document the parameters
			local InnName = ...
			DebugPrint("InnName is " .. InnName)
		end -- if APR.DebugMode

		-- If the user didn't ask us to hide this popup, just return.
		if not APR.DB.HideInnkeeper then
			DebugPrint("HideInnkeeper off, not auto confirming")
			return
		end

		DebugPrint("Auto confirming Innkeeper bind request")
		if select(4, GetBuildInfo()) >= 100000 then
			DebugPrint("Executing with Dragonflight command")
			C_PlayerInteractionManager.ConfirmationInteraction(Enum.PlayerInteractionType.Binder)
			C_PlayerInteractionManager.ClearInteraction(Enum.PlayerInteractionType.Binder)
		else
			DebugPrint("Executing with pre-DF command")
			ConfirmBinder()
		end

	end -- APR.Events:CONFIRM_BINDER()
end -- WoW Classic check
