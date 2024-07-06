-- Module_Upgrades.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2024 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This removes the confirmation popup when upgrading an item.

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

-- Note the lowercase naming of modules. Makes it easier to pass status and settings around.
-- This is also the value used in slash commands to toggle settings. For the user, it's case insensitive.
-- This value should always be lowercase only in this file.
local ThisModule = "upgrade"

-- Set up the module
APR.Modules[ThisModule] = {}
local this = APR.Modules[ThisModule]

-- the name of the variable in APR.DB and its default value
this.DBName = "HideItemUpgrades"
this.DBDefaultValue = APR.HIDE_DIALOG

-- The module's category determines where it goes in the options list
this.Category = "Items"

-- This is the config setup for AceConfig
this.config = {
	-- With the standardization that came with the localization and options revamp, these are now typically identical for all modules.
	name = L[ThisModule .. "_name"],
	desc = L[ThisModule .. "_config"],
	type = "toggle",
	set = function(info, val) APR:HandleAceSettingsChange(val, info) end,
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
this.WorksInClassic = false -- no upgrades in Classic

-- This Boolean tells us whether to disable this module during combat. This can be deleted if it's false.
this.DisableInCombat = false


-- This function causes the popup to show when triggered.
this.ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))

	APR.DB.HideItemUpgrades = APR.SHOW_DIALOG

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
this.HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm ) .. ", ForceHide is " .. MakeString(ForceHide))

	APR.DB.HideItemUpgrades = APR.HIDE_DIALOG

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()





-- Now capture the events that this module has to handle
-- This block can be deleted if you don't use events.
if not APR.IsClassic or this.WorksInClassic then
	DebugPrint("In Upgrade at load time")

	local function ConfirmUpgrade()
		DebugPrint("In Upgrade, In ConfirmUpgrade()")

		-- If the user didn't ask us to hide this popup, just return.
		if not APR.DB.HideItemUpgrades then
			DebugPrint("HideItemUpgrades off, not auto confirming")
			return
		end

		-- Loop through the static popup dialogs to find the one that matches what we need.
		for i = 1, STATICPOPUP_NUMDIALOGS do
			local sp_name = "StaticPopup" .. i
			local dialog = _G[sp_name]

			if dialog and dialog:IsShown() and dialog.which == "CONFIRM_UPGRADE_ITEM" then
				DebugPrint(string.format("Dialog %s is shown and validated.", sp_name))
				--StaticPopupDialogs["GOSSIP_CONFIRM"]:OnAccept()
				ItemUpgradeFrame:OnConfirm() -- @TODO: DOES NOT WORK
					-- This call goes through and eventually calls C_ItemUpgrade.UpgradeItem() 
					-- C_ItemUpgrade.UpgradeItem() is protected and can only be called from Blizzard code.
				return
			else
				DebugPrint(string.format("Dialog %s Auto-confirm condition not met.", sp_name))
			end -- if dialog shown
		end -- for each dialog

	end -- ConfirmUpgrade()

	-- local function show()
	-- 	DebugPrint("In Upgrade, in show()")
	-- end

	-- This function executes before the addon has fully loaded. Use it to initialize any settings this module needs.
	this.PreloadFunc = function()

		DebugPrint("In Upgrade, In PreloadFunc, hooking the upgrade button")
		-- ItemUpgradeFrame:HookScript("OnShow", show)
		ItemUpgradeFrame.UpgradeButton:HookScript("OnClick", ConfirmUpgrade)

	end


end -- WoW Classic check
