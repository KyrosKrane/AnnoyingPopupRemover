-- Localization.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2015-2023 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.

-- This file sets up localization and text strings for the addon.
-- These are the default English strings used if another localization is not provided.


--#########################################
--# Parameters
--#########################################

-- Grab the WoW-defined addon folder name and storage table for our addon
local addonName, APR = ...

-- Get a handle to the localization table for easier reading
local L = APR.L


--#########################################
--# Strings
--#########################################

-- Addon name
L["Annoying Pop-up Remover"] = "Annoying Pop-up Remover"
L["APR"] = "APR"


-- Version and startup message
L["Version_message"] = APR.Version .. " loaded."
L["Startup_message"] = L["Version_message"] .. " For help and options, type /apr"


-- Config options
L["loot_config"] = "Hide the confirmation pop-up when looting bind-on-pickup items" -- loot
L["roll_config"] = "Hide the confirmation pop-up when rolling on bind-on-pickup items" -- roll
L["void_config"] = "Hide the confirmation pop-up when depositing modified items into void storage" -- void
L["vendor_config"] = "Hide the confirmation pop-up when selling group-looted items to a vendor" -- vendor
L["buy_config"] = "Hide the confirmation pop-up when buying an item with an alternate currency" -- buy_alt_currency
L["nonrefundable_config"] = "Hide the confirmation pop-up when buying a nonrefundable item" -- buy_nonrefundable
L["equip_config"] = "Hide the confirmation pop-up when equipping a bind-on-equip item" -- equip
L["trade_config"] = "Hide the confirmation pop-up when equipping an item that was looted in a group and can still be traded." -- equip_tradable
L["refund_config"] = "Hide the confirmation pop-up when equipping an item that can still be returned for a refund" -- equip_refund
L["mail_config"] = "Hide the confirmation pop-up when mailing refundable items" -- mail
L["delete_config"] = "When deleting \"good\" items, don't require typing the word \"delete\"" -- delete
L["innkeeper_config"] = "Hide the confirmation pop-up when binding at an innkeeper" -- innkeeper
L["quest_config"] = "Hide the popup when abandoning a quest" -- quest
L["undercut_config"] = "Hide the reminder that undercutting is no longer required when selling at the auction house" -- undercut
L["dragonriding_config"] = "Hide the confirmation pop-up when selecting a dragonriding talent" -- dragonriding
L["workorder_config"] = "Hide the confirmation pop-up when crafting a work order that requires some of your own reagents." -- workorder
L["actioncam_config"] = "Hide the warning pop-up when using the ActionCam" -- actioncam
L["gossip_config"] = "Hide the confirmation pop-up for various NPC chats" -- gossip

L["startup_config"] = "Show a startup announcement message in your chat frame at login"

-- Config headers
L["Annoyances"] = "Annoyances"
L["Addon Options"] = "Addon Options"


-- Status printing
L["startup_printed"] = "Startup announcement message will printed in your chat frame at login."
L["startup_not_printed"] = "Startup announcement message will NOT printed in your chat frame at login."

L["Debug mode is now on."] = "Debug mode is now on."
L["Debug mode is now off."] = "Debug mode is now off."


-- Configuration toggles
L["loot_hidden"] = "Confirmation pop-up when " .. APR.Utilities.CHAT_GREEN .. "loot" .. FONT_COLOR_CODE_CLOSE .. "ing bind-on-pickup items will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["loot_shown"] = "Confirmation pop-up when " .. APR.Utilities.CHAT_RED .. "loot" .. FONT_COLOR_CODE_CLOSE .. "ing bind-on-pickup items will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["roll_hidden"] = "Confirmation pop-up when " .. APR.Utilities.CHAT_GREEN .. "roll" .. FONT_COLOR_CODE_CLOSE .. "ing on bind-on-pickup items will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["roll_shown"] = "Confirmation pop-up when " .. APR.Utilities.CHAT_RED .. "roll" .. FONT_COLOR_CODE_CLOSE .. "ing on bind-on-pickup items will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["void_hidden"] = "Confirmation pop-up when depositing modified items into " .. APR.Utilities.CHAT_GREEN .. "void" .. FONT_COLOR_CODE_CLOSE .. " storage will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["void_shown"] = "Confirmation pop-up when depositing modified items into " .. APR.Utilities.CHAT_RED .. "void" .. FONT_COLOR_CODE_CLOSE .. " storage will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["vendor_hidden"] = "Confirmation pop-up when selling group-looted items to a " .. APR.Utilities.CHAT_GREEN .. "vendor" .. FONT_COLOR_CODE_CLOSE .. " will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["vendor_shown"] = "Confirmation pop-up when selling group-looted items to a " .. APR.Utilities.CHAT_RED .. "vendor" .. FONT_COLOR_CODE_CLOSE .. " will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["buy_hidden"] = "Confirmation pop-up when you " .. APR.Utilities.CHAT_GREEN .. "buy" .. FONT_COLOR_CODE_CLOSE .. " an item with an alternate currency will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["buy_shown"]  = "Confirmation pop-up when you " .. APR.Utilities.CHAT_RED .. "buy" .. FONT_COLOR_CODE_CLOSE .. " an item with an alternate currency will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["nonrefundable_hidden"] = "Confirmation pop-up when you buy a " .. APR.Utilities.CHAT_GREEN .. "nonrefundable" .. FONT_COLOR_CODE_CLOSE .. " item will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["nonrefundable_shown"]  = "Confirmation pop-up when you buy a " .. APR.Utilities.CHAT_RED .. "nonrefundable" .. FONT_COLOR_CODE_CLOSE .. " item will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["equip_hidden"] = "Confirmation pop-up when you " .. APR.Utilities.CHAT_GREEN .. "equip" .. FONT_COLOR_CODE_CLOSE .. " a bind-on-equip item will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["equip_shown"] = "Confirmation pop-up when you " .. APR.Utilities.CHAT_RED .. "equip" .. FONT_COLOR_CODE_CLOSE .. " a bind-on-equip item will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["trade_hidden"] = "Confirmation pop-up when equipping a group-looted items you can still " .. APR.Utilities.CHAT_GREEN .. "trade" .. FONT_COLOR_CODE_CLOSE .. " will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["trade_shown"] = "Confirmation pop-up when equipping a group-looted items you can still " .. APR.Utilities.CHAT_RED .. "trade" .. FONT_COLOR_CODE_CLOSE .. " will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["refund_hidden"] = "Confirmation pop-up when you equip a " .. APR.Utilities.CHAT_GREEN .. "refund" .. FONT_COLOR_CODE_CLOSE .. "able item will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["refund_shown"] = "Confirmation pop-up when you equip a " .. APR.Utilities.CHAT_RED .. "refund" .. FONT_COLOR_CODE_CLOSE .. "able item will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["mail_hidden"] = "Confirmation pop-up when " .. APR.Utilities.CHAT_GREEN .. "mail" .. FONT_COLOR_CODE_CLOSE .. "ing refundable items will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["mail_shown"] = "Confirmation pop-up when " .. APR.Utilities.CHAT_RED .. "mail" .. FONT_COLOR_CODE_CLOSE .. "ing refundable items will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["delete_hidden"] = "If you " .. APR.Utilities.CHAT_GREEN .. "delete" .. FONT_COLOR_CODE_CLOSE .. " a \"good\" item, it will " .. APR.Utilities.CHAT_GREEN .. "not require" .. FONT_COLOR_CODE_CLOSE .. " typing the word \"delete\"."
L["delete_shown"] = "If you " .. APR.Utilities.CHAT_RED .. "delete" .. FONT_COLOR_CODE_CLOSE .. " a \"good\" item, it will " .. APR.Utilities.CHAT_RED .. "require" .. FONT_COLOR_CODE_CLOSE .. " typing the word \"delete\"."

L["innkeeper_hidden"] = "Confirmation pop-up when binding at an " .. APR.Utilities.CHAT_GREEN .. "innkeeper" .. FONT_COLOR_CODE_CLOSE .. " will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["innkeeper_shown"] = "Confirmation pop-up when binding at an " .. APR.Utilities.CHAT_RED .. "innkeeper" .. FONT_COLOR_CODE_CLOSE .. " will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["quest_hidden"] = "Confirmation pop-up abandoning a " .. APR.Utilities.CHAT_GREEN .. "quest" .. FONT_COLOR_CODE_CLOSE .. " will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["quest_shown"] = "Confirmation pop-up abandoning a " .. APR.Utilities.CHAT_RED .. "quest" .. FONT_COLOR_CODE_CLOSE .. " will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["undercut_hidden"] = "Reminder not to " .. APR.Utilities.CHAT_GREEN .. "undercut" .. FONT_COLOR_CODE_CLOSE .. " at the auction house will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["undercut_shown"] = "Reminder not to " .. APR.Utilities.CHAT_RED .. "undercut" .. FONT_COLOR_CODE_CLOSE .. " at the auction house will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["dragonriding_hidden"] = "Confirmation pop-up when selecting a " .. APR.Utilities.CHAT_GREEN .. "dragonriding" .. FONT_COLOR_CODE_CLOSE .. " talent will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["dragonriding_shown"] = "Confirmation pop-up when selecting a " .. APR.Utilities.CHAT_RED .. "dragonriding" .. FONT_COLOR_CODE_CLOSE .. " talent will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["workorder_hidden"] = "Confirmation pop-up when crafting a " .. APR.Utilities.CHAT_GREEN .. "workorder" .. FONT_COLOR_CODE_CLOSE .. " that uses your own reagents will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["workorder_shown"] = "Confirmation pop-up when crafting a " .. APR.Utilities.CHAT_RED .. "workorder" .. FONT_COLOR_CODE_CLOSE .. " that uses your own reagents will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["actioncam_hidden"] = "Warning pop-up when using the " .. APR.Utilities.CHAT_GREEN .. "ActionCam" .. FONT_COLOR_CODE_CLOSE .. " will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["actioncam_shown"] = "Warning pop-up when using the " .. APR.Utilities.CHAT_RED .. "ActionCam" .. FONT_COLOR_CODE_CLOSE .. " will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

L["gossip_hidden"] = "Confirmation pop-up when " .. APR.Utilities.CHAT_GREEN .. "gossip" .. FONT_COLOR_CODE_CLOSE .. "ing with some NPCS will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["gossip_shown"] = "Confirmation pop-up when " .. APR.Utilities.CHAT_RED .. "gossip" .. FONT_COLOR_CODE_CLOSE .. "ing with some NPCS will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

-- module specific strings
-- This is for the gossip module using string matching
L["Darkmoon_travel"] = "Travel to the faire staging area will cost:" -- This line (for the DMF) is not localized in Blizzard's lua code. Not actually used in APR.
