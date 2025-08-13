-- Hide_StaticPopup.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2024 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This file defines functions that let you work with  StaticPopups and enable compatibility between different API versions.

-- Included functions:
-- APR.SP.FindVisible(which)
-- APR.SP.ForEachShownDialog(func)
-- APR.SP.Cancel(which)
-- APR.SP.Accept(which)
-- APR.SP.Hide(which, data, data2)

-- Grab the WoW-defined addon folder name and storage table for our addon
local _, APR = ...

-- Upvalues for readability
local DebugPrint = APR.Utilities.DebugPrint


-- Create a holder for our StaticPopup abstraction functions
APR.SP={}

-- This function seems to be available in all versions of the API, so we just use the Blizz version.
APR.SP.FindVisible = StaticPopup_FindVisible

-- This function is a replacement for Blizz's new function, for use with the old API
local function ForEachShownDialog(func)
	for i = 1, STATICPOPUP_NUMDIALOGS do
		local sp_name = "StaticPopup" .. i
		local dialog = _G[sp_name]

		-- We need to check two things.
		-- 1) Does the dialog exist?
		-- 2) Is the dialog shown?

		-- Check the first three conditions.
		if dialog then
			DebugPrint(string.format("in ForEachShownDialog, Dialog %s exists", sp_name))
			if dialog:IsShown() then
				DebugPrint(string.format("in ForEachShownDialog, Dialog %s is shown", sp_name))
				func(dialog)
			end -- if dialog is shown
		end -- if dialog is not nil
	end -- for each dialog
end -- ForEachShownDialog()

APR.SP.ForEachShownDialog = StaticPopup_ForEachShownDialog or ForEachShownDialog


-- Finds a shown static popup of the matching type and calls the OnCancel function for it
-- Assumption is only one dialog of the specified type is shown (true for the vast majority of popups)
function APR.SP.Cancel(which)
	local dialog = APR.SP.FindVisible(which)
	if dialog then
		dialog:Hide();
		local OnCancel = StaticPopupDialogs[which].OnCancel;
		if ( OnCancel ) then
			OnCancel(dialog, dialog.data, "override");
		end
	end
end -- APR.APR.SP.Cancel()


-- Finds a shown static popup of the matching type and calls the OnAccept function for it
function APR.SP.Accept(which)
	local dialog = APR.SP.FindVisible(which)
	if dialog then
		dialog:Hide();
		local OnAccept = StaticPopupDialogs[which].OnAccept;
		if ( OnAccept ) then
			OnAccept(dialog, dialog.data);
		end
	end
end -- APR.SP.Accept()


-- This function checks if a dialog is shown and hides it. Returns true if at least one dialog was hidden, false otherwise.
function APR.SP.Hide(which, data, data2)
	DebugPrint(string.format("In APR.SP.Hide, searching for dialog with type %s, data %s, and data2 %s.", which or "all", data or "nil", data2 or "nil"))
	
	-- The default Blizz hide functions don't return a value indicating whether a dialog was specifically hidden or not.
	-- My use case requires taking certain actions iff a dialog was hidden.
	-- so we can't just use the Blizz hide functions as is.
	-- Instead, we loop through all shown dialogs, check if they match, hide them, then explicitly return a value.

	-- We need to check four things.
	-- 1) Does the dialog exist?
	-- 2) Is the dialog shown?
	-- 3) Is the dialog type the one we want?
	-- 4) Does the dialog data match the requested? (This differentiates if there are multiple open dialogs of the same type.)

	-- ForEachShownDialog() takes care of the first two checks. So, we just need to validate 3 and 4, then hide and mark that something was hidden.

	local DialogWasHidden = false

	-- Blizz provides a tool to run a function on each shown dialog, so set up a function to do what we need.
	local function ProcessDialog(dialog)
		if dialog.which == which then
			DebugPrint(string.format("Dialog has type %s, processing", dialog.which))

			-- Check the fourth condition. data and data2 may be nil, so we have to explicitly check the permutations. 
			-- There should never be a situation where data2 is not nil and data is nil, unless nil is the intended value.
			if data2 then
				if dialog.data == data and dialog.data2 == data2 then
					-- data and data2 both exist and match
					DebugPrint(string.format("data and data2 both exist and match, hiding this dialog"))
					DialogWasHidden = true
					dialog:Hide()
				else
					DebugPrint(string.format("data and data2 both exist and DO NOT match, skipping this dialog"))
				end
			elseif data then
				if dialog.data == data then
					-- only data exists and matches
					DebugPrint(string.format("only data exists and matches, hiding this dialog"))
					DialogWasHidden = true
					dialog:Hide()
				else
					DebugPrint(string.format("only data exists and DOES NOT match, skipping this dialog"))
				end
			else
				-- neither data nor data2 exist, but the dialog type matches.
				DebugPrint(string.format("neither data nor data2 provided, but the dialog type matches, hiding this dialog"))
				DialogWasHidden = true
				dialog:Hide()
			end

		else
			DebugPrint(string.format("Dialog has type %s, skipping", dialog.which))
		end -- if dialog type matches
	end -- ProcessDialog()

	-- Now we actually loop over the visible dialogs and return the result
	APR.SP.ForEachShownDialog(ProcessDialog)
	return DialogWasHidden
end -- function APR.SP.Hide()
