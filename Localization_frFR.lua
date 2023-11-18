-- Localization_frFR.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Translations by Klep-Ysondre on Github.
-- Copyright (c) 2015-2023 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.

-- This file sets up French localization and text strings for the addon.


-- Parameters

-- Grab the WoW-defined addon folder name and storage table for our addon
local addonName, APR = ...

-- Bail out if it's the wrong language.
if "frFR" ~= APR.locale then return end

-- Get a handle to the localization table for easier reading
local L = APR.L



-- Strings

-- Addon name
L["Annoying Pop-up Remover"] = "Annoying Pop-up Remover"
L["APR"] = "APR"


-- Version and startup message
L["Version_message"] = APR.Version .. " chargé."
L["Startup_message"] = L["Version_message"] .. " Pour de l’aide et afficher les otpions, tapez /apr"


-- Config options
L["startup_config"] = "Afficher un message d’accueil lors de votre connexion"
L["status_config"] = "Afficher le résumé des paramètres dans la fenêtre de dialogue"
L["version_config"] = "Afficher la version d’APR et le résumé de l’aide"

-- Config headers
L["ItemsHeader"] = "Objets"
L["VendoringHeader"] = "Ventes"
L["NPCInteractionHeader"] = "Interaction avec les PNJs"
L["GameInterfaceHeader"] = "Interface de Jeu"
L["AddonOptionsHeader"] = L["APR"] .. " Options"


-- Status printing
L["startup_printed"] = "Un message d’annonce sera affiché lors de votre prochaine connexion."
L["startup_not_printed"] = "Un message d’annonce ne sera pas affiché lors de votre prochaine connexion."

L["Debug mode is now on."] = "Le mode débogage est désormais activé."
L["Debug mode is now off."] = "Le mode débogage est désormais désactivé."


-- Configuration names and toggles

-- module_loot
L["loot_name"] = "Objets Lié quand équipé"
L["loot_config"] = "Masquer la fenêtre de confirmation lorsque vous ramassez des objets Lié quand équipé"
L["loot_hidden"] = "La fenêtre de confirmation du " .. APR.Utilities.CHAT_GREEN .. "ramassage" .. FONT_COLOR_CODE_CLOSE .. " des objets Lié quand équipé sera " .. APR.Utilities.CHAT_GREEN .. "masquée" .. FONT_COLOR_CODE_CLOSE .. "."
L["loot_shown"] = "La fenêtre de confirmation du " .. APR.Utilities.CHAT_RED .. "ramassage" .. FONT_COLOR_CODE_CLOSE .. " des objets Lié quand équipé sera " .. APR.Utilities.CHAT_RED .. "affichée" .. FONT_COLOR_CODE_CLOSE .. "."

-- roll
L["roll_name"] = "Jet de dés Bonus pour les objets LqR"
L["roll_config"] = "Masquer la fenêtre de confirmation lors de l’utilisation Jet de dés Bonus pour les objets Lié quand ramassé"
L["roll_hidden"] = "La fenêtre de confirmation lors de l’utilisation du " .. APR.Utilities.CHAT_GREEN .. "Jet de dés Bonus" .. FONT_COLOR_CODE_CLOSE .. " pour les objets Lié quand ramassé sera " .. APR.Utilities.CHAT_GREEN .. "masquée" .. FONT_COLOR_CODE_CLOSE .. "."
L["roll_shown"] = "La fenêtre de confirmation lors de l’utilisation du " .. APR.Utilities.CHAT_RED .. "Jet de dés Bonus" .. FONT_COLOR_CODE_CLOSE .. " pour les objets Lié quand ramassé sera " .. APR.Utilities.CHAT_RED .. "affichée" .. FONT_COLOR_CODE_CLOSE .. "."

-- void
L["void_name"] = "Chambre du Vide"
L["void_config"] = "Masquer la fenêtre de confirmation lorsque vous déposez un objet modifié dans la Chambre du Vide"
L["void_hidden"] = "La fenêtre de confirmation lors du dépôt d’un objet LqR dans la " .. APR.Utilities.CHAT_GREEN .. "Chambre du Vide" .. FONT_COLOR_CODE_CLOSE .. " sera " .. APR.Utilities.CHAT_GREEN .. "masquée" .. FONT_COLOR_CODE_CLOSE .. "."
L["void_shown"] = "La fenêtre de confirmation lors du dépôt d’un objet LqR dans la " .. APR.Utilities.CHAT_RED .. "Chambre du Vide" .. FONT_COLOR_CODE_CLOSE .. " sera " .. APR.Utilities.CHAT_RED .. "affichée" .. FONT_COLOR_CODE_CLOSE .. "."

-- vendor
L["vendor_name"] = "Objets échangeables"
L["vendor_config"] = "Masquer la fenêtre de confirmation lorsque vous vendez des objets provenant d’un groupe"
L["vendor_hidden"] = "La fenêtre de confirmation lorsque vous vendez des objets provenant d’un groupe sera " .. APR.Utilities.CHAT_GREEN .. "masquée" .. FONT_COLOR_CODE_CLOSE .. "."
L["vendor_shown"] = "La fenêtre de confirmation lorsque vous vendez des objets provenant d’un groupe sera " .. APR.Utilities.CHAT_RED .. "affichée" .. FONT_COLOR_CODE_CLOSE .. "."

-- buy_alt_currency
L["buy_name"] = "Achat dans une monnaie différente (autre que l’Or)"
L["buy_config"] = "Masquer la fenêtre de confirmation lorsque vous achetez un objet dans une Monnaie différente"
L["buy_hidden"] = "La fenêtre de confirmation lorsque vous " .. APR.Utilities.CHAT_GREEN .. "achetez" .. FONT_COLOR_CODE_CLOSE .. " un objet avec une Monnaie différente sera " .. APR.Utilities.CHAT_GREEN .. "masquée" .. FONT_COLOR_CODE_CLOSE .. "."
L["buy_shown"]  = "La fenêtre de confirmation lorsque vous " .. APR.Utilities.CHAT_RED .. "achetez" .. FONT_COLOR_CODE_CLOSE .. " un objet avec une Monnaie différente sera " .. APR.Utilities.CHAT_RED .. "affichée" .. FONT_COLOR_CODE_CLOSE .. "."

-- buy_nonrefundable
L["nonrefundable_name"] = "Achat d’objet non remboursable"
L["nonrefundable_config"] = "Masquer la fenêtre de confirmation lors vous achetez un objet non remboursable"
L["nonrefundable_hidden"] = "La fenêtre de confirmation lorsque vous achetez un objet " .. APR.Utilities.CHAT_GREEN .. "non remboursable" .. FONT_COLOR_CODE_CLOSE .. " sera " .. APR.Utilities.CHAT_GREEN .. "masquée" .. FONT_COLOR_CODE_CLOSE .. "."
L["nonrefundable_shown"]  = "La fenêtre de confirmation lorsque vous achetez un objet " .. APR.Utilities.CHAT_RED .. "non remboursable" .. FONT_COLOR_CODE_CLOSE .. " sera " .. APR.Utilities.CHAT_RED .. "affichée" .. FONT_COLOR_CODE_CLOSE .. "."

-- equip
L["equip_name"] = "Équiper un objet LqÉ"
L["equip_config"] = "Masquer la fenêtre de confirmation lors de l'équipement d'un objet Lié quand équipé"
L["equip_hidden"] = "La fenêtre de confirmation lors de l'" .. APR.Utilities.CHAT_GREEN .. "équipement" .. FONT_COLOR_CODE_CLOSE .. " un objet Lié quand équipé sera " .. APR.Utilities.CHAT_GREEN .. "masquée" .. FONT_COLOR_CODE_CLOSE .. "."
L["equip_shown"] = "La fenêtre de confirmation lors de l'" .. APR.Utilities.CHAT_RED .. "équipement" .. FONT_COLOR_CODE_CLOSE .. " un objet Lié quand équipé sera " .. APR.Utilities.CHAT_RED .. "affichée" .. FONT_COLOR_CODE_CLOSE .. "."

-- equip_tradable
L["trade_name"] = "Équiper un objet pouvant encore être échangé"
L["trade_config"] = "Masquer la fenêtre de confirmation lorsque vous équipez un objet qui a été pillé dans un groupe et qui peut encore être échangé"
L["trade_hidden"] = "La fenêtre de confirmation lorsque vous équipez un objet qui a été pillé et qui peut encore être " .. APR.Utilities.CHAT_GREEN .. "échangé" .. FONT_COLOR_CODE_CLOSE .. " sera " .. APR.Utilities.CHAT_GREEN .. "masquée" .. FONT_COLOR_CODE_CLOSE .. "."
L["trade_shown"] = "La fenêtre de confirmation lorsque vous équipez un objet qui a été pillé et qui peut encore être " .. APR.Utilities.CHAT_RED .. "échangé" .. FONT_COLOR_CODE_CLOSE .. " sera " .. APR.Utilities.CHAT_RED .. "affichée" .. FONT_COLOR_CODE_CLOSE .. "."

-- equip_refund
L["refund_name"] = "Équiper un objet remboursable"
L["refund_config"] = "Masquer la fenêtre de confirmation lorsque vous équipez un objet qui peut encore être remboursé"
L["refund_hidden"] = "La fenêtre de confirmation lorsque vous équipez un objet qui peut encore être " .. APR.Utilities.CHAT_GREEN .. "remboursé" .. FONT_COLOR_CODE_CLOSE .. " sera " .. APR.Utilities.CHAT_GREEN .. "masquée" .. FONT_COLOR_CODE_CLOSE .. "."
L["refund_shown"] = "La fenêtre de confirmation lorsque vous équipez un objet qui peut encore être " .. APR.Utilities.CHAT_RED .. "remboursé" .. FONT_COLOR_CODE_CLOSE .. " sera " .. APR.Utilities.CHAT_RED .. "affichée" .. FONT_COLOR_CODE_CLOSE .. "."

-- mail
L["mail_name"] = "Poster un objet remboursable"
L["mail_config"] = "Masquer la fenêtre de confirmation lorsque vous envoyez par courrier un objet remboursable"
L["mail_hidden"] = "La fenêtre de confirmation lorsque vous " .. APR.Utilities.CHAT_GREEN .. "postez un objet remboursable" .. FONT_COLOR_CODE_CLOSE .. " sera " .. APR.Utilities.CHAT_GREEN .. "masquée" .. FONT_COLOR_CODE_CLOSE .. "."
L["mail_shown"] = "La fenêtre de confirmation lorsque vous " .. APR.Utilities.CHAT_RED .. "postez un objet remboursable" .. FONT_COLOR_CODE_CLOSE .. " sera " .. APR.Utilities.CHAT_RED .. "affichée" .. FONT_COLOR_CODE_CLOSE .. "."

-- delete
L["delete_name"] = "Supprimer un objet rapidement"
L["delete_config"] = "Lorsque vous supprimez un objet Épique ou Rare, il ne sera plus nécessaire d’écrire le mot \"EFFACER\""
L["delete_hidden"] = "Si vous " .. APR.Utilities.CHAT_GREEN .. "supprimez" .. FONT_COLOR_CODE_CLOSE .. " un objet Épique ou Rare il " .. APR.Utilities.CHAT_GREEN .. "ne sera plus nécessaire d’écrire" .. FONT_COLOR_CODE_CLOSE .. " le mot \"EFFACER\"."
L["delete_shown"] = "Si vous " .. APR.Utilities.CHAT_RED .. "supprimez" .. FONT_COLOR_CODE_CLOSE .. " un objet Épique ou Rare il " .. APR.Utilities.CHAT_RED .. "sera nécessaire d’écrire" .. FONT_COLOR_CODE_CLOSE .. " le mot \"EFFACER\"."

-- innkeeper
L["innkeeper_name"] = "Nouvelle Auberge"
L["innkeeper_config"] = "Masquer la fenêtre de confirmation lorsque vous demandez à un Aubergiste de lier la zone à votre Pierre de foyer"
L["innkeeper_hidden"] = "La fenêtre de confirmation lorsque vous demandez à un " .. APR.Utilities.CHAT_GREEN .. "Aubergiste" .. FONT_COLOR_CODE_CLOSE .. " de lier la zone à votre Pierre de foyer sera " .. APR.Utilities.CHAT_GREEN .. "masquée" .. FONT_COLOR_CODE_CLOSE .. "."
L["innkeeper_shown"] = "La fenêtre de confirmation lorsque vous demandez à un " .. APR.Utilities.CHAT_RED .. "Aubergiste" .. FONT_COLOR_CODE_CLOSE .. " de lier la zone à votre Pierre de foyer sera " .. APR.Utilities.CHAT_RED .. "affichée" .. FONT_COLOR_CODE_CLOSE .. "."

-- quest
L["quest_name"] = "Abandonner une quête"
L["quest_config"] = "Masquer la fenêtre de confirmation lorsque vous abandonnez une quête"
L["quest_hidden"] = "La fenêtre de confirmation lorsque vous abandonnez une " .. APR.Utilities.CHAT_GREEN .. "quête" .. FONT_COLOR_CODE_CLOSE .. " sera " .. APR.Utilities.CHAT_GREEN .. "masquée" .. FONT_COLOR_CODE_CLOSE .. "."
L["quest_shown"] = "La fenêtre de confirmation lorsque vous abandonnez une " .. APR.Utilities.CHAT_RED .. "quête" .. FONT_COLOR_CODE_CLOSE .. " sera " .. APR.Utilities.CHAT_RED .. "affichée" .. FONT_COLOR_CODE_CLOSE .. "."

-- undercut
L["undercut_name"] = "Sous-cotation à l’Hôtel des Ventes"
L["undercut_config"] = "Masquer le rappel selon lequel la sous-cotation n’est plus requis lors de la vente d’objet à l’Hôtel des Ventes"
L["undercut_hidden"] = "Le rappel pour ne pas appliquer la " .. APR.Utilities.CHAT_GREEN .. "sous-cotation" .. FONT_COLOR_CODE_CLOSE .. " lors de la vente d’objet à l’Hôtel des Ventes sera " .. APR.Utilities.CHAT_GREEN .. "masquée" .. FONT_COLOR_CODE_CLOSE .. "."
L["undercut_shown"] = "Le rappel pour ne pas appliquer la " .. APR.Utilities.CHAT_RED .. "sous-cotation" .. FONT_COLOR_CODE_CLOSE .. " lors de la vente d’objet à l’Hôtel des Ventes sera " .. APR.Utilities.CHAT_RED .. "affichée" .. FONT_COLOR_CODE_CLOSE .. "."

-- dragonriding
L["dragonriding_name"] = "Talents du Vol à dos de Dragon"
L["dragonriding_config"] = "Masquer la fenêtre de confirmation lorsque vous sélectionnez un talent du Vol à dos de Dragon"
L["dragonriding_hidden"] = "La fenêtre de confirmation lorsque vous sélectionnez un talent du " .. APR.Utilities.CHAT_GREEN .. "Vol à dos de Dragon" .. FONT_COLOR_CODE_CLOSE .. " sera " .. APR.Utilities.CHAT_GREEN .. "masquée" .. FONT_COLOR_CODE_CLOSE .. "."
L["dragonriding_shown"] = "La fenêtre de confirmation lorsque vous sélectionnez un talent du " .. APR.Utilities.CHAT_RED .. "Vol à dos de Dragon" .. FONT_COLOR_CODE_CLOSE .. " sera " .. APR.Utilities.CHAT_RED .. "affichée" .. FONT_COLOR_CODE_CLOSE .. "."

-- workorder
L["workorder_name"] = "Commandes nécessiants vos composants"
L["workorder_config"] = "Masquer la fenêtre de confirmation lorsque vous réalisez une commande nécessitant certains de vos propres composants"
L["workorder_hidden"] = "La fenêtre de confirmation lorsque vous réalisez une " .. APR.Utilities.CHAT_GREEN .. "commande" .. FONT_COLOR_CODE_CLOSE .. " nécessiant certains de vos propres composants sera " .. APR.Utilities.CHAT_GREEN .. "masquée" .. FONT_COLOR_CODE_CLOSE .. "."
L["workorder_shown"] = "La fenêtre de confirmation lorsque vous réalisez une " .. APR.Utilities.CHAT_RED .. "commande" .. FONT_COLOR_CODE_CLOSE .. " nécessiant certains de vos propres composants sera " .. APR.Utilities.CHAT_RED .. "affichée" .. FONT_COLOR_CODE_CLOSE .. "."

-- actioncam
L["actioncam_name"] = "Utiliser l’ActionCam"
L["actioncam_config"] = "Masquer la fenêtre d’avertissement lors de l’utilisation de l’ActionCam"
L["actioncam_hidden"] = "La fenêtre d’avertissement lors de l’utilisation de l’" .. APR.Utilities.CHAT_GREEN .. "ActionCam" .. FONT_COLOR_CODE_CLOSE .. " sera " .. APR.Utilities.CHAT_GREEN .. "masquée" .. FONT_COLOR_CODE_CLOSE .. "."
L["actioncam_shown"] = "La fenêtre d’avertissement lors de l’utilisation de l’" .. APR.Utilities.CHAT_RED .. "ActionCam" .. FONT_COLOR_CODE_CLOSE .. " sera " .. APR.Utilities.CHAT_RED .. "affichée" .. FONT_COLOR_CODE_CLOSE .. "."

-- gossip
L["gossip_name"] = "Conversation avec les PNJs"
L["gossip_config"] = "Masquer la fenêtre de confirmation pour certaines discussions avec des PNJs"
L["gossip_hidden"] = "La fenêtre de confirmation lors de la " .. APR.Utilities.CHAT_GREEN .. "conversation" .. FONT_COLOR_CODE_CLOSE .. " avec certains PNJ sera " .. APR.Utilities.CHAT_GREEN .. "masquée" .. FONT_COLOR_CODE_CLOSE .. "."
L["gossip_shown"] = "La fenêtre de confirmation lors de la " .. APR.Utilities.CHAT_RED .. "conversation" .. FONT_COLOR_CODE_CLOSE .. " avec certains PNJ sera " .. APR.Utilities.CHAT_RED .. "affichée" .. FONT_COLOR_CODE_CLOSE .. "."

-- module specific strings
-- This is for the gossip module using string matching
L["Darkmoon_travel"] = "Travel to the faire staging area will cost:" -- This line (for the DMF) is not localized in Blizzard's lua code. Not actually used in APR.
