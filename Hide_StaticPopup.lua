-- Hide_StaticPopup.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2024 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This file defines functions that let you hide a specific StaticPopup.

-- Grab the WoW-defined addon folder name and storage table for our addon
local _, APR = ...

-- Upvalues for readability
local DebugPrint = APR.Utilities.DebugPrint


-- This function checks if a dialog is shown and hides it. It returns the integer ID of the matching popup if one was found and hidden, nil otherwise.
function APR:Hide_StaticPopup(which, data)
	DebugPrint(string.format("In APR:Hide_StaticPopup, searching for dialog with type %s and data %s.", which, data))

	-- Loop through the static popup dialogs to find the one that matches what we need.
	for i = 1, STATICPOPUP_NUMDIALOGS do
		local sp_name = "StaticPopup" .. i
		local dialog = _G[sp_name]

		-- We need to check four things.
		-- 1) Does the dialog exist?
		-- 2) Is the dialog shown?
		-- 3) Is the dialog type the one we want?
		-- 4) Is the dialog data matching the requested? (This differentiates if there are multiple open dialogs of the same type.)

		if dialog and dialog:IsShown() and dialog.which == which and dialog.data == data then

			DebugPrint(string.format("Found matching popup with ID %d", i))

            dialog:Hide()

			return i
		end -- if matching dialog found
	end -- for each dialog

	DebugPrint("Did not find matching popup")
    return nil -- the nil is redundant, but it's better to explicitly mention the intended return value
end -- function APR:Hide_StaticPopup()
