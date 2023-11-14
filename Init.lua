-- Init.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2015-2022 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@


-- This file initializes some settings for Annoying Popup Remover.

--#########################################
--# Parameters
--#########################################

-- Grab the WoW-defined addon folder name and storage table for our addon
local addonName, APR = ...

-- Create the frame to hold our event catcher, and the list of events.
APR.Frame, APR.Events = CreateFrame("Frame"), {}

-- Create a holder to store dialogs we're removing, in case the user wants to restore them.
APR.StoredDialogs = {}

-- Set up the modules holder
APR.Modules = {}

-- Set the current version so we can display it.
APR.Version = "@project-version@"

--@alpha@
-- Enable debug mode for test only
-- It's initialized to false in the Utility library
APR.DebugMode = true
--@end-alpha@


--#########################################
--# Constants (for more readable code)
--#########################################

-- These are NOT settings; don't change these!
APR.FORCE_HIDE_DIALOG = true
APR.PRINT_CONFIRMATION = true
APR.NO_CONFIRMATION = false
APR.HIDE_DIALOG = true
APR.SHOW_DIALOG = false
APR.PRINT_STARTUP = true
APR.HIDE_STARTUP = false


--#########################################
--# Global variables
--#########################################

-- Determine whether we're running Classic or normal. Wrath Classic and Classic Era (vanilla) both count as Classic.
APR.IsClassic = select(4, GetBuildInfo()) < 40000

-- Annoyingly, some functions on Classic Era still use old code. So, track that separately.
APR.IsClassicEra = select(4, GetBuildInfo()) < 30000

-- Get the ordering constant of the next module
APR.NextOrdering = 10


--#########################################
--# Localization
--#########################################

-- Get the language used by the client.
APR.locale = GetLocale()
--@alpha@
-- Override for testing of missing strings
if false then APR.locale = "frFR" end
--@end-alpha@
APR.Utilities.DebugPrint("At load time, locale is ", APR.locale)

-- This bit of meta-magic makes it so that if we call L with a key that doesn't yet exist, a key is created automatically, and its value is the name of the key.  For example, if L["MyAddon"] doesn't exist, and I run print(L["MyAddon"]), the __index command causes the L table to automatically create a new key called MyAddon, and its value is set to tostring("MyAddon") -- same as the key name.
APR.L = setmetatable({}, {
	__index = function(t, k)
		local prestring = APR.DebugMode and "UNLOCALIZED STRING - " or ""
		local v = prestring .. tostring(k)
		rawset(t, k, v)
		return v
	end,
})

-- The above system effectively makes it so that we don't have to define the default, English-language values.  Just set the key name as the English value.
-- Set the default strings used here.  Other languages can override these as needed.
-- Not going to localize debug strings for now.

-- In another file, you can override these strings like:
--		if APR.locale == "deDE" then
--			L["Annoying Pop-up Remover"] = "German name of APR here"
--		end
-- That way, it preserves the default English strings in case of a missed translation.
