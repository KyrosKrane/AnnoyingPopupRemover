-- Localization_frFR.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Translations by Klep-Ysondre on Github.
-- Copyright (c) 2023 KyrosKrane Sylvanblade & Klep-Ysondre
-- Licensed under the MIT License, as per the included file.

-- This file sets up French localization and text strings for the addon.

-- Grab the WoW-defined addon folder name and storage table for our addon
local addonName, APR = ...

-- Bail out if it's the wrong language.
if not "frFR" == APR.locale then return end

-- Get a handle to the localization table for easier reading
local L = APR.L

-- Strings

-- Addon name
L["Annoying Pop-up Remover"] = "Annoying Pop-up Remover"
L["APR"] = "APR"

-- Version and startup message
L["Version_message"] = APR.Version .. " chargée."
L["Startup_message"] = L["Version_message"] .. " Pour de l’aide et afficher les otpions, tapez /apr"

-- Config options
L["loot_config"]			= "Masquer la fenêtre de confirmation lorsque vous ramassez des objets Lié quand équipé" -- loot
L["roll_config"]			= "Masquer la fenêtre de confirmation lorsque vous effectuez un Jet de dés sur un Butin bonus pour les objets Lié quand équipé" -- roll
L["void_config"]			= "Masquer la fenêtre de confirmation lorsque vous déposez un objet modifié dans la Chambre du Vide" -- void
L["vendor_config"]			= "Masquer la fenêtre de confirmation lorsque vous vendez des objets provenant d’un groupe" -- vendor -- à revoir
L["buy_config"]				= "Masquer la fenêtre de confirmation lorsque vous achetez un objet dans une autre Monnaie" -- buy_alt_currency
L["nonrefundable_config"]	= "Masquer la fenêtre de confirmation lors vous achetez un objet non remboursable" -- buy_nonrefundable
L["equip_config"]			= "Masquer la fenêtre de confirmation lorsque vous équippez un objet Lié quand équipé" -- equip
L["trade_config"]			= "Masquer la fenêtre de confirmation lorsque vous équipez un objet qui a été pillé dans un groupe et qui peut encore être échangé" -- equip_tradable
L["refund_config"]			= "Masquer la fenêtre de confirmation lorsque vous équipez un objet qui peut encore être retourné contre remboursement" -- equip_refund
L["mail_config"]			= "Masquer la fenêtre de confirmation lorsque vous envoyez par Courrier un objet remboursable" -- mail
L["delete_config"]			= "Lorsque vous supprimez un objet Épique ou Rare, il ne sera plus nécessaire d’écrire, dans la fenêtre, le mot \"EFFACER\"" -- delete
L["innkeeper_config"]		= "Masquer la fenêtre de confirmation lorsque vous demandez à un Aubergiste de faire la zone demandée votre nouveau foyer" -- innkeeper
L["quest_config"]			= "Masquer la fenêtre de confirmation lorsque vous abandonnez une quête" -- innkeeper
L["undercut_config"]		= "Masquer le rappel selon lequel la sous-cotation n’est plus requis lors de la vente d’objet à l’Hôtel des Ventes" -- undercut
L["dragonriding_config"]	= "Masquer la fenêtre de confirmation lorsque vous selectionnez un talent du Vol à dos de Dragon" -- dragonriding
L["workorder_config"]		= "Masquer la fenêtre de confirmation lorsque vous réalisez une commande nécessitant certains de vos propres composants" -- workorder
L["actioncam_config"]		= "Masquer la fenêtre d’avertissement lors de l’utilisation de l’ActionCam" -- actioncam
L["gossip_config"]			= "Masquer la fenêtre de confirmation pour certaines discussions avec des PNJs" -- gossip

L["startup_config"]			= "Afficher un message d’accueil lors de votre connexion"

-- Config headers
L["Annoyances"]				= "Confirmations"
L["Addon Options"]			= "Options d’APR"

-- Status printing
L["startup_printed"]		= "Un message d’annonce sera affiché lors de votre prochaine connexion."
L["startup_not_printed"]	= "Un message d’annonce ne sera pas affiché lors de votre prochaine connexion."

-- module specific strings
-- This is for the gossip module using string matching
L["Darkmoon_travel"] = "Le déplacement jusqu’à la Foire de Sombrelune est payant :" -- This line (for the DMF) is not localized in Blizzard's lua code. Not actually used in APR. -- à revoir

-- Version and startup message
L["Version_message"] = APR.Version .. " chargée."
L["Startup_message"] = L["Version_message"] .. " Aide et options, tapez /apr"

-- Status printing
L["Debug mode is now on."] = "Le mode débogage est désormais activé."
L["Debug mode is now off."] = "Le mode débogage est désormais désactivé."

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
