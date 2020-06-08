-- Localization.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2015-2020 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.

-- This file sets up localization and text strings for the addon.


--#########################################
--# Parameters
--#########################################

-- Grab the WoW-defined addon folder name and storage table for our addon
local addonName, APR = ...


--#########################################
--# Localization
--#########################################

-- Get the language used by the client.
APR.locale = GetLocale()

-- This bit of meta-magic makes it so that if we call L with a key that doesn't yet exist, a key is created automatically, and its value is the name of the key.  For example, if L["MyAddon"] doesn't exist, and I run print(L["MyAddon"]), the __index command causes the L table to automatically create a new key called MyAddon, and its value is set to tostring("MyAddon") -- same as the key name.
APR.L = setmetatable({ }, {__index = function(t, k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end})

local L = APR.L

-- The above system effectively makes it so that we don't have to define the default, English-language values.  Just set the key name as the English value.
-- Set the default strings used here.  Other languages can override these as needed.
-- Not going to localize debug strings for now.

-- In another file, you can override these strings like:
--		if APR.locale == "deDE" then
--			L["Annoying Pop-up Remover"] = "German name of APR here";
--		end
-- That way, it preserves the default English strings in case of a missed translation.


--#########################################
--# Strings
--#########################################

-- These strings are a little complicated, so better to put them in a dedicated section here rather than define them implicitly.
L["loot_hidden"] = "Confirmation pop-up when " .. APR.Utilities.CHAT_GREEN .. "looting" .. FONT_COLOR_CODE_CLOSE .. " bind-on-pickup items will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["loot_shown"] = "Confirmation pop-up when " .. APR.Utilities.CHAT_RED .. "looting" .. FONT_COLOR_CODE_CLOSE .. " bind-on-pickup items will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["roll_hidden"] = "Confirmation pop-up when " .. APR.Utilities.CHAT_GREEN .. "rolling" .. FONT_COLOR_CODE_CLOSE .. " on bind-on-pickup items will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["roll_shown"] = "Confirmation pop-up when " .. APR.Utilities.CHAT_RED .. "rolling" .. FONT_COLOR_CODE_CLOSE .. " on bind-on-pickup items will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["void_hidden"] = "Confirmation pop-up when depositing modified items into " .. APR.Utilities.CHAT_GREEN .. "void storage" .. FONT_COLOR_CODE_CLOSE .. " will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["void_shown"] = "Confirmation pop-up when depositing modified items into " .. APR.Utilities.CHAT_RED .. "void storage" .. FONT_COLOR_CODE_CLOSE .. " will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["vendor_hidden"] = "Confirmation pop-up when selling group-looted items to a " .. APR.Utilities.CHAT_GREEN .. "vendor" .. FONT_COLOR_CODE_CLOSE .. " will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["vendor_shown"] = "Confirmation pop-up when selling group-looted items to a " .. APR.Utilities.CHAT_RED .. "vendor" .. FONT_COLOR_CODE_CLOSE .. " will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["delete_hidden"] = APR.Utilities.CHAT_GREEN .. "Deleting \"good\" items" .. FONT_COLOR_CODE_CLOSE .. " will " .. APR.Utilities.CHAT_GREEN .. "not require" .. FONT_COLOR_CODE_CLOSE .. " typing the word \"delete\"."
L["delete_shown"] = APR.Utilities.CHAT_RED .. "Deleting \"good\" items" .. FONT_COLOR_CODE_CLOSE .. " will " .. APR.Utilities.CHAT_RED .. "require" .. FONT_COLOR_CODE_CLOSE .. " typing the word \"delete\"."

L["mail_hidden"] = "Confirmation pop-up when " .. APR.Utilities.CHAT_GREEN .. "mailing" .. FONT_COLOR_CODE_CLOSE .. " refundable items will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["mail_shown"] = "Confirmation pop-up when " .. APR.Utilities.CHAT_RED .. "mailing" .. FONT_COLOR_CODE_CLOSE .. " refundable items will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["innkeeper_hidden"] = "Confirmation pop-up when binding at an " .. APR.Utilities.CHAT_GREEN .. "innkeeper" .. FONT_COLOR_CODE_CLOSE .. " will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["innkeeper_shown"] = "Confirmation pop-up when binding at an " .. APR.Utilities.CHAT_RED .. "innkeeper" .. FONT_COLOR_CODE_CLOSE .. " will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["undercut_hidden"] = "Reminder not to " .. APR.Utilities.CHAT_GREEN .. "undercut" .. FONT_COLOR_CODE_CLOSE .. " at the auction house will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["undercut_shown"] = "Reminder not to " .. APR.Utilities.CHAT_RED .. "undercut" .. FONT_COLOR_CODE_CLOSE .. " at the auction house will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

