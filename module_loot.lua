-- module_loot.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2015-2020 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This file defines a module that APR can handle. Each module is one setting or popup.

-- Grab the WoW-defined addon folder name and storage table for our addon
local addonName, APR = ...

-- Upvalues for readability
local DebugPrint = APR.Utilities.DebugPrint
local ChatPrint = APR.Utilities.ChatPrint
local MakeString = APR.Utilities.MakeString
local L = APR.L


--#########################################
--# Module settings
--#########################################

-- Note the lowercase naming of modules. Makes it easier to pass status and settings around
local ThisModule = "loot"

-- Set up the module
APR.Modules[ThisModule] = {}

-- the name of the variable in APR.DB and its default value
APR.Modules[ThisModule].DBName = "HideBind";
APR.Modules[ThisModule].DBDefaultValue = APR.HIDE_DIALOG

-- This is the config setup for AceConfig
APR.Modules[ThisModule].config = {
	name = L["Hide the confirmation pop-up when looting bind-on-pickup items"],
	type = "toggle",
	set = function(info,val) APR:HandleAceSettingsChange(val, info) end,
	get = function(info) return APR.DB.HideBind end,
	descStyle = "inline",
	width = "full",
	order = 110,
} -- config

-- These are the status strings that are printed to indicate whether it's off or on
APR.Modules[ThisModule].hidden_msg = L[ThisModule .. "_hidden"];
APR.Modules[ThisModule].shown_msg = L[ThisModule .. "_shown"];

-- This Boolean tells us whether this module works in Classic.
APR.Modules[ThisModule].WorksInClassic = true;


APR.Modules[ThisModule].ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['loot'].ShowPopup, printconfirm is " .. MakeString(printconfirm))
	if APR.DB.HideBind then
		-- Re-enable the dialog that pops to confirm looting BoP gear yourself.
		StaticPopupDialogs["LOOT_BIND"] = APR.StoredDialogs["LOOT_BIND"]
		APR.StoredDialogs["LOOT_BIND"] = nil

		-- Mark that the dialog is shown.
		APR.DB.HideBind = APR.SHOW_DIALOG

	-- else already shown, nothing to do.
	end

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


APR.Modules[ThisModule].HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['loot'].HidePopup, printconfirm is " .. MakeString(printconfirm) .. ", ForceHide is " .. MakeString(ForceHide))
	if not APR.DB.HideBind or ForceHide then
		-- Disable the dialog that pops to confirm looting BoP gear yourself.
		APR.StoredDialogs["LOOT_BIND"] = StaticPopupDialogs["LOOT_BIND"]
		StaticPopupDialogs["LOOT_BIND"] = nil

		-- Mark that the dialog is hidden.
		APR.DB.HideBind = APR.HIDE_DIALOG

	-- else already hidden, nothing to do.
	end

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()


-- Now capture the events that this module has to handle

if not APR.IsClassic or APR.Modules[ThisModule].WorksInClassic then

	-- Looting a BOP item triggers this event.
	function APR.Events:LOOT_BIND_CONFIRM(Frame, id, ...)

		if APR.DebugMode then
			DebugPrint("In APR.Events:LOOT_BIND_CONFIRM")
			DebugPrint("Frame is " .. Frame)
			DebugPrint("id is " .. id)
			APR.Utilities.PrintVarArgs(...)
		end -- if APR.DebugMode

		-- If the user didn't ask us to hide this popup, just return.
		if not APR.DB.HideBind then
			DebugPrint("HideBind off, not auto confirming")
			return
		end

		-- When harvesting (mining, herbing, or skinning) in WoD, you can get a Primal Spirit. This is a BoP item that will trigger this event when found on a mob corpse. Prior to patch 7.0.3, getting a PS while harvesting would not trigger this event (since there was never a scenario where someone else in the group could get the PS). For some reason, with 7.0.3, looting a PS on a harvest WILL trigger this event, even if you're solo. Worse, there are several problems.
		-- 1: The parameters passed in will be wrong; it doesn't pass in the Frame; instead, the id is passed in as the first parameter.
		-- 2: The ConfirmLootSlot() call is ignored. Effectively, it requires the user to click on the PS in the loot window to pick it up. If the user doesn't have autoloot turned on, it requires two total clicks to loot the PS.
		-- The real fix here that this event should never trigger on a harvest; only on a kill loot. This is a Blizzard bug that has to be fixed from their end. In the meantime, I've put in the if/elseif below to handle this odd scenario.
		-- The bug noted above was fixed some time during or after the patch 7.0.3 era.

		if id then
			DebugPrint("id is valid.")
			ConfirmLootSlot(id)
		elseif Frame then
			DebugPrint("id is null, confirming with Frame.")
			ConfirmLootSlot(Frame)

		--		-- Testing whether double-Confirming would help. It didn't. :(
		--		DebugPrint("Verifying if slot is empty.")
		--		if LootSlotHasItem(Frame) then
		--			DebugPrint("Loot slot still has item; attempting to re-loot.")
		--			-- LootSlot(Frame) -- don't do this! This retriggers the same event recursively and infinitely, leading to a stack overflow.
		--			ConfirmLootSlot(Frame)
		--		else
		--			DebugPrint("Loot slot is empty.")
		--		end
		end
	end -- APR.Events:LOOT_BIND_CONFIRM()

end -- WoW Classic check
