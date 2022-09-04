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

-- Determine whether we're running Classic or normal. Burning Crusade and Classic Era (vanilla) both count as Classic.
APR.IsClassic = select(4, GetBuildInfo()) < 40000

-- Get the ordering constant of the next module
APR.NextOrdering = 110
