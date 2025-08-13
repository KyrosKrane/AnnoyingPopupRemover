-- module_equip_refund.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2021-2025 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This file defines a module that APR can handle. Each module is one setting or popup.

-- This module removes the popup when equipping or using a vendor-bought item that can still be returned for a refund.

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
local ThisModule = "refund"

-- Set up the module
APR.Modules[ThisModule] = {}
local this = APR.Modules[ThisModule]

-- the name of the variable in APR.DB and its default value
this.DBName = "HideRefund"
this.DBDefaultValue = APR.HIDE_DIALOG

-- The module's category determines where it goes in the options list
this.Category = "Items"

-- This is the config setup for AceConfig
this.config = {
	name = L[ThisModule .. "_name"],
	desc = L[ThisModule .. "_config"],
	type = "toggle",
	set = function(info,val) APR:HandleAceSettingsChange(val, info) end,
	get = function(info) return APR.DB[this.DBName] end,
	descStyle = "inline",
	width = "full",
	order = APR.Categories[this.Category].order + APR.NextOrdering,
} -- config

-- Update the ordering for the next file to be loaded
APR.NextOrdering = APR.NextOrdering + 5

-- These are the status strings that are printed to indicate whether it's off or on
this.hidden_msg = L[ThisModule .. "_hidden"]
this.shown_msg = L[ThisModule .. "_shown"]

-- This Boolean tells us whether this module works in Classic.
this.WorksInClassic = true

-- This Boolean tells us whether to disable this module during combat.
this.DisableInCombat = true


-- This function causes the popup to show when triggered.
this.ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))

	if APR.DB.HideRefund then
		-- Re-enable the dialog that pops to confirm equipping BoE gear yourself.
		APR.DB.HideRefund = APR.SHOW_DIALOG

	-- else already shown, nothing to do.
	end

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
this.HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm ) .. ", ForceHide is " .. MakeString(ForceHide))

	if not APR.DB.HideRefund or ForceHide then
		-- Disable the dialog that pops to confirm equipping BoE gear yourself.
		APR.DB.HideRefund = APR.HIDE_DIALOG

	-- else already hidden, nothing to do.
	end

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()


-- Now capture the events that this module has to handle

if not APR.IsClassic or this.WorksInClassic then
	-- Equipping a vendor-refundable item triggers this event.
	function APR.Events:EQUIP_BIND_REFUNDABLE_CONFIRM(slot, itemLocation)

		DebugPrint("In APR.Events:EQUIP_BIND_REFUNDABLE_CONFIRM")
		DebugPrint("Slot is ", slot)
		DebugPrint("itemLocation is ", itemLocation and "not nil" or "nil")


		-- If the user didn't ask us to hide this popup, just return.
		if not APR.DB.HideRefund then
			DebugPrint("HideRefund off, not auto confirming")
			return
		end

		if not slot then
			DebugPrint("Slot is invalid.")
			return
		end


		-- Note that if we hide the dialog, the OnHide function is called, which cancels the pending equip request. 
		-- So, we have to accept first, then hide.
		-- note that due to the way Blizz does the dialogs, you can't do dialog:OnAccept() - it doesn't exist. 
		-- The StaticPopup_OnClick function actually references the static version.

		if APR.IsClassic then
			StaticPopupDialogs["EQUIP_BIND_REFUNDABLE"]:OnAccept(slot)
		else
			-- in 11.0.0, Blizz changed the functions in this static dialog to expect a data table with a slot element, not just the slot number.
			local data = {
				slot = slot,
				itemLocation = itemLocation
			}
			StaticPopupDialogs["EQUIP_BIND_REFUNDABLE"]:OnAccept(data)
		end

		APR.SP.Hide("EQUIP_BIND_REFUNDABLE")

	end -- APR.Events:EQUIP_BIND_REFUNDABLE_CONFIRM()


	-- Using a cosmetic vendor-refundable item triggers this event.
	function APR.Events:USE_NO_REFUND_CONFIRM()

		DebugPrint("In APR.Events:USE_NO_REFUND_CONFIRM")

		-- in 11.0.5, Blizzard made the function C_Item.ConfirmNoRefundOnUse() protected. This function is called by the OnAccept method on the dialog.
		-- So, until the next update (hopefully) reverses this change, just bail out when this is called.
		-- This appears to have been reverted as of 2024-11-11 (still in 11.0.5).
		-- It wasn't reverted. It just seems that the confirm function sometimes works and sometimes gives a protected error.


		--[[===
					
			Scenario 1:
			If I use the item Preserved Deep-Dweller's Staff (a cosmetic that can be purchased for resonance crystals and is refundable still), the game fires the event USE_NO_REFUND_CONFIRM, which causes a static popup of type USE_NO_REFUND_CONFIRM to appear. Clicking Okay to learn invokes the dialog's :OnAccept() function, which ultimately calls C_Item.ConfirmNoRefundOnUse(). Doing this via /run or in an addon works correctly and without error.

			Scenario 2:
			If I use the item Alchemy Lab, Level 2 (a garrison plan that is purchased and is refundable still), the game fires the event USE_NO_REFUND_CONFIRM, which causes a static popup of type USE_NO_REFUND_CONFIRM to appear. Clicking Okay to learn invokes the dialog's :OnAccept() function, which ultimately calls C_Item.ConfirmNoRefundOnUse(). Doing this via /run or in an addon generates an error (e.g., from /run: "[ADDON_ACTION_FORBIDDEN] AddOn '*** ForceTaint_Strong ***' tried to call the protected function 'ConfirmNoRefundOnUse()'."

		===]]

		if true then
			DebugPrint("Bailing out until Blizz reallows addons to use C_Item.ConfirmNoRefundOnUse()")
			return
		end

		-- If the user didn't ask us to hide this popup, just return.
		if not APR.DB.HideRefund then
			DebugPrint("HideRefund off, not auto confirming")
			return
		end

		DebugPrint("HideRefund on, auto confirming the buy")

		-- Note that if we hide the dialog, the OnHide function is called, which cancels the pending equip request. 
		-- So, we have to accept first, then hide.
		-- note that due to the way Blizz does the dialogs, you can't do dialog:OnAccept() - it doesn't exist. 
		-- The StaticPopup_OnClick function actually references the static version.

		StaticPopupDialogs["USE_NO_REFUND_CONFIRM"]:OnAccept()

		APR.SP.Hide("USE_NO_REFUND_CONFIRM")

	end -- APR.Events:EQUIP_BIND_REFUNDABLE_CONFIRM()

end -- WoW Classic check
