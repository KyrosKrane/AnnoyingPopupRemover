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
--			L["Annoying Pop-up Remover"] = "German name of APR here"
--		end
-- That way, it preserves the default English strings in case of a missed translation.

L["Annoying Pop-up Remover"] = "Annoying Pop-up Remover"
L["APR"] = "APR"


--#########################################
--# Strings
--#########################################

-- These strings are a little complicated, so better to put them in a dedicated section here rather than define them implicitly.
L["loot_hidden"] = "Confirmation pop-up when " .. APR.Utilities.CHAT_GREEN .. "loot" .. FONT_COLOR_CODE_CLOSE .. "ing bind-on-pickup items will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["loot_shown"] = "Confirmation pop-up when " .. APR.Utilities.CHAT_RED .. "loot" .. FONT_COLOR_CODE_CLOSE .. "ing bind-on-pickup items will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["roll_hidden"] = "Confirmation pop-up when " .. APR.Utilities.CHAT_GREEN .. "roll" .. FONT_COLOR_CODE_CLOSE .. "ing on bind-on-pickup items will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["roll_shown"] = "Confirmation pop-up when " .. APR.Utilities.CHAT_RED .. "roll" .. FONT_COLOR_CODE_CLOSE .. "ing on bind-on-pickup items will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["void_hidden"] = "Confirmation pop-up when depositing modified items into " .. APR.Utilities.CHAT_GREEN .. "void" .. FONT_COLOR_CODE_CLOSE .. " storage will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["void_shown"] = "Confirmation pop-up when depositing modified items into " .. APR.Utilities.CHAT_RED .. "void" .. FONT_COLOR_CODE_CLOSE .. " storage will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["vendor_hidden"] = "Confirmation pop-up when selling group-looted items to a " .. APR.Utilities.CHAT_GREEN .. "vendor" .. FONT_COLOR_CODE_CLOSE .. " will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["vendor_shown"] = "Confirmation pop-up when selling group-looted items to a " .. APR.Utilities.CHAT_RED .. "vendor" .. FONT_COLOR_CODE_CLOSE .. " will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["delete_hidden"] = "If you " .. APR.Utilities.CHAT_GREEN .. "delete" .. FONT_COLOR_CODE_CLOSE .. " a \"good\" item, it will " .. APR.Utilities.CHAT_GREEN .. "not require" .. FONT_COLOR_CODE_CLOSE .. " typing the word \"delete\"."
L["delete_shown"] = "If you " .. APR.Utilities.CHAT_RED .. "delete" .. FONT_COLOR_CODE_CLOSE .. " a \"good\" item, it will " .. APR.Utilities.CHAT_RED .. "require" .. FONT_COLOR_CODE_CLOSE .. " typing the word \"delete\"."

L["mail_hidden"] = "Confirmation pop-up when " .. APR.Utilities.CHAT_GREEN .. "mail" .. FONT_COLOR_CODE_CLOSE .. "ing refundable items will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["mail_shown"] = "Confirmation pop-up when " .. APR.Utilities.CHAT_RED .. "mail" .. FONT_COLOR_CODE_CLOSE .. "ing refundable items will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["innkeeper_hidden"] = "Confirmation pop-up when binding at an " .. APR.Utilities.CHAT_GREEN .. "innkeeper" .. FONT_COLOR_CODE_CLOSE .. " will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["innkeeper_shown"] = "Confirmation pop-up when binding at an " .. APR.Utilities.CHAT_RED .. "innkeeper" .. FONT_COLOR_CODE_CLOSE .. " will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["undercut_hidden"] = "Reminder not to " .. APR.Utilities.CHAT_GREEN .. "undercut" .. FONT_COLOR_CODE_CLOSE .. " at the auction house will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["undercut_shown"] = "Reminder not to " .. APR.Utilities.CHAT_RED .. "undercut" .. FONT_COLOR_CODE_CLOSE .. " at the auction house will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["equip_hidden"] = "Confirmation pop-up when you " .. APR.Utilities.CHAT_GREEN .. "equip" .. FONT_COLOR_CODE_CLOSE .. " a bind-on-equip item will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["equip_shown"] = "Confirmation pop-up when you " .. APR.Utilities.CHAT_RED .. "equip" .. FONT_COLOR_CODE_CLOSE .. " a bind-on-equip item will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["refund_hidden"] = "Confirmation pop-up when you equip a " .. APR.Utilities.CHAT_GREEN .. "refund" .. FONT_COLOR_CODE_CLOSE .. "able item will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["refund_shown"] = "Confirmation pop-up when you equip a " .. APR.Utilities.CHAT_RED .. "refund" .. FONT_COLOR_CODE_CLOSE .. "able item will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["buy_hidden"] = "Confirmation pop-up when you " .. APR.Utilities.CHAT_GREEN .. "buy" .. FONT_COLOR_CODE_CLOSE .. " an item with an alternate currency will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["buy_shown"]  = "Confirmation pop-up when you " .. APR.Utilities.CHAT_RED .. "buy" .. FONT_COLOR_CODE_CLOSE .. " an item with an alternate currency will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["nonrefundable_hidden"] = "Confirmation pop-up when you buy a " .. APR.Utilities.CHAT_GREEN .. "nonrefundable" .. FONT_COLOR_CODE_CLOSE .. " item will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["nonrefundable_shown"]  = "Confirmation pop-up when you buy a " .. APR.Utilities.CHAT_RED .. "nonrefundable" .. FONT_COLOR_CODE_CLOSE .. " item will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["trade_hidden"] = "Confirmation pop-up when equipping a group-looted items you can still " .. APR.Utilities.CHAT_GREEN .. "trade" .. FONT_COLOR_CODE_CLOSE .. " will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["trade_shown"] = "Confirmation pop-up when equipping a group-looted items you can still " .. APR.Utilities.CHAT_RED .. "trade" .. FONT_COLOR_CODE_CLOSE .. " will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["dragonriding_hidden"] = "Confirmation pop-up when selecting a " .. APR.Utilities.CHAT_GREEN .. "dragonriding" .. FONT_COLOR_CODE_CLOSE .. " talent will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["dragonriding_shown"] = "Confirmation pop-up when selecting a " .. APR.Utilities.CHAT_RED .. "dragonriding" .. FONT_COLOR_CODE_CLOSE .. " talent will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["quest_hidden"] = "Confirmation pop-up abandoning a " .. APR.Utilities.CHAT_GREEN .. "quest" .. FONT_COLOR_CODE_CLOSE .. " will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["quest_shown"] = "Confirmation pop-up abandoning a " .. APR.Utilities.CHAT_RED .. "quest" .. FONT_COLOR_CODE_CLOSE .. " will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["workorder_hidden"] = "Confirmation pop-up when crafting a " .. APR.Utilities.CHAT_GREEN .. "workorder" .. FONT_COLOR_CODE_CLOSE .. " that uses your own reagents will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["workorder_shown"] = "Confirmation pop-up crafting a " .. APR.Utilities.CHAT_RED .. "workorder" .. FONT_COLOR_CODE_CLOSE .. " that uses your own reagents will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["actioncam_hidden"] = "Warning pop-up when using the " .. APR.Utilities.CHAT_GREEN .. "ActionCam" .. FONT_COLOR_CODE_CLOSE .. " will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["actioncam_shown"] = "Warning pop-up when using the " .. APR.Utilities.CHAT_RED .. "ActionCam" .. FONT_COLOR_CODE_CLOSE .. " will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["gossip_hidden"] = "Confirmation pop-up when " .. APR.Utilities.CHAT_GREEN .. "gossip" .. FONT_COLOR_CODE_CLOSE .. "ing with some NPCS will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["gossip_shown"] = "Confirmation pop-up when " .. APR.Utilities.CHAT_RED .. "gossip" .. FONT_COLOR_CODE_CLOSE .. "ing with some NPCS will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."
