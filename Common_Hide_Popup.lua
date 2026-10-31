-- Common_Hide_Popup.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2026 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This file creates a standard system for identifying popups, matching them to the rules in the addon, and hiding them when appropriate.

-- Grab the WoW-defined addon folder name and storage table for our addon
local addonName, APR = ...

-- Upvalues for readability
local DebugPrint = APR.Utilities.DebugPrint
local MakeString = APR.Utilities.MakeString


-- create a table to hold all the StaticPopup types that can be auto closed, and when to close them.
-- The format for each entry is:
--      StaticPopupType = true|false|string|func
-- StaticPopupType is the type used by Blizzard's code, usually stored in the "which" value of the StaticPopup table.
-- value of true means always hide
-- value of false means never hide
-- a string is treated as the name of a value in the APR.DB table, which makes linking to modules easy.
-- a function is evaluated as func(SPU_Name, ...); the result is evaluated as a Boolean. If true, the popup is hidden, otherwise it's left allowed. The parameters are the same as what's passed to StaticPopup_Show() in Blizzard code.
-- Note that non-Boolean values or function results can give unexpected behavior, as they're evaluated using Lua's truthiness rules, which might occasionally be surprising.
APR.AutoClose = {}


-- This function is called whenever a static popup is shown, and determines whether to auto accept it.
local function CheckPopup(SPU_Name, ...)
	DebugPrint("in common CheckPopup, SPU_Name is", MakeString(SPU_Name))

	if not APR.AutoClose[SPU_Name] then return end

    -- Check whether to accept this popup
    local result

    if "function" == type(APR.AutoClose[SPU_Name]) then
        DebugPrint("in common CheckPopup, ", SPU_Name, " has a function evaluator")
        result = APR.AutoClose[SPU_Name](SPU_Name, ...)
        DebugPrint("in common CheckPopup, function returned ", result)

    elseif "string" == type(APR.AutoClose[SPU_Name]) then
        DebugPrint("in common CheckPopup, ", SPU_Name, " has a string value of ", APR.AutoClose[SPU_Name])
        result = APR.DB[APR.AutoClose[SPU_Name]]
        DebugPrint("in common CheckPopup, string lookup evalutes to ", result)

    else
        DebugPrint("in common CheckPopup, ", SPU_Name, " has a static value of ", APR.AutoClose[SPU_Name])
        result = APR.AutoClose[SPU_Name]
    end

    -- Hide the popup if needed
    if result then
        APR.SP.Accept(SPU_Name)
        StaticPopup_Hide(SPU_Name)
    end

end -- CheckPopup()

-- Hook the Blizzard function and call our function to evaluate and close the popup.
hooksecurefunc("StaticPopup_Show", CheckPopup)
