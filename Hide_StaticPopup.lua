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

local function HideDialog(dialog, ID)
	DebugPrint(string.format("Found matching popup with ID %d", ID))
	dialog:Hide()
	return ID
end

-- This function checks if a dialog is shown and hides it. It returns the integer ID of the matching popup if one was found and hidden, nil otherwise.
function APR:Hide_StaticPopup(which, data, data2)
	DebugPrint(string.format("In APR:Hide_StaticPopup, searching for dialog with type %s, data %s, and data2 %s.", which, data or "nil", data2 or "nil"))

	-- Loop through the static popup dialogs to find the one that matches what we need.
	for i = 1, STATICPOPUP_NUMDIALOGS do
		local sp_name = "StaticPopup" .. i
		local dialog = _G[sp_name]

		-- We need to check four things.
		-- 1) Does the dialog exist?
		-- 2) Is the dialog shown?
		-- 3) Is the dialog type the one we want?
		-- 4) Does the dialog data match the requested? (This differentiates if there are multiple open dialogs of the same type.)

		-- Check the first three conditions.
		if dialog then
			DebugPrint(string.format("Dialog %s exists", sp_name))
			if dialog:IsShown() then
				DebugPrint(string.format("Dialog %s is shown", sp_name))
				if dialog.which == which then
					DebugPrint(string.format("Dialog %s has type %s", sp_name, dialog.which))

					-- Check the fourth condition. data and data2 may be nil, so we have to explicitly check the permutations. 
					-- There should never be a situation where data2 is not nil and data is nil, unless nil is the intended value.
					if data2 then
						if dialog.data == data and dialog.data2 == data2 then
							-- data and data2 both exist and match
							return HideDialog(dialog, i)
						end
					elseif data then
						if dialog.data == data then
							-- only data exists and matches
							return HideDialog(dialog, i)
						end
					else
						-- neither data nor data2 exist, but the dialog type matches.
						return HideDialog(dialog, i)
					end

				-- else there was a data mismatch, so continue looping looking for another dialog.
				end -- if dialog type matches
			end -- if dialog is shown
		end -- if dialog is not nil
	end -- for each dialog

	DebugPrint("Did not find matching popup")
	return nil -- the nil is redundant, but it's better to explicitly mention the intended return value
end -- function APR:Hide_StaticPopup()
