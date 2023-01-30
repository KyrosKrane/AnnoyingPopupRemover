-- module_dragonriding.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Copyright (c) 2015-2022 KyrosKrane Sylvanblade
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This file defines a module that APR can handle. Each module is one setting or popup.
-- This module removes the confirmation popup when selecing a dragonriding talent.

DEFAULT_CHAT_FRAME:AddMessage("at top of dragonriding raw load")


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
local ThisModule = "dragonriding"

-- Set up the module
APR.Modules[ThisModule] = {}

-- the name of the variable in APR.DB and its default value
APR.Modules[ThisModule].DBName = "HideDragonriding"
APR.Modules[ThisModule].DBDefaultValue = APR.HIDE_DIALOG

-- This is the config setup for AceConfig
APR.Modules[ThisModule].config = {
	name = L["Hide the confirmation pop-up when selecting a dragonriding talent"],
	type = "toggle",
	set = function(info, val) APR:HandleAceSettingsChange(val, info) end,
	get = function(info) return APR.DB.HideDragonriding end,
	descStyle = "inline",
	width = "full",
} -- config

-- Set the order based on the file inclusion order in the TOC
APR.Modules[ThisModule].config.order = APR.NextOrdering
APR.NextOrdering = APR.NextOrdering + 10

-- These are the status strings that are printed to indicate whether it's off or on
APR.Modules[ThisModule].hidden_msg = L[ThisModule .. "_hidden"]
APR.Modules[ThisModule].shown_msg = L[ThisModule .. "_shown"]

-- This Boolean tells us whether this module works in Classic.
APR.Modules[ThisModule].WorksInClassic = false


-- This function causes the popup to show when triggered.
APR.Modules[ThisModule].ShowPopup = function(printconfirm)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].ShowPopup, printconfirm is " .. MakeString(printconfirm))

	-- code here

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- ShowPopup()


-- This function causes the popup to be hidden when triggered.
APR.Modules[ThisModule].HidePopup = function(printconfirm, ForceHide)
	DebugPrint("in APR.Modules['" .. ThisModule .. "'].HidePopup, printconfirm is " .. MakeString(printconfirm ) .. ", ForceHide is " .. MakeString(ForceHide))

	-- code here

	if printconfirm then APR:PrintStatus(ThisModule) end
end -- HidePopup()


-- This function executes before the addon has fully loaded. Use it to initialize any settings this module needs.
-- This function can be safely deleted if not used by this module.
APR.Modules[ThisModule].PreloadFunc = function()
	DebugPrint("in dragonriding PreloadFunc")
end


-- Now capture the events that this module has to handle
print("in dragonriding raw load")

if not APR.IsClassic or APR.Modules[ThisModule].WorksInClassic then

	-- This uses the event registry
	-- https://wowpedia.fandom.com/wiki/EventRegistry
	-- callback name is "TalentButton.OnClick"

	-- Sample registration call from another addon
	-- ClassTalentFrame.TalentsTab:RegisterCallback(TalentFrameBaseMixin.Event.TalentButtonAcquired, self.OnTalentButtonAcquired, self);

	-- need to modify this and figure out how to implement in the APR framework.
	-- But also, this same callback is triggered for talents and other stuff. Have to figure out how to narrow it down
	-- first parameter is a table. Maybe that has info in it? Need to register and dump the table to see.

	local DragonridingSpellIDs = {
				377920,
		393999,	377938,	377964,
				378967,
			378409,	384824,
				377939,
				378970,
				377921,
			381870,	381871,
		377922,	377940,	377967,
	}


	local function DumpCallbackRegistry(...)
		if APR.DebugMode then
			DebugPrint("In DumpCallbackRegistry")
			APR.Utilities.PrintVarArgs(...)

			-- Document the incoming parameters.
			-- local item = ... -- this is an item link.
			-- DebugPrint("item is " .. item)
		end -- if APR.DebugMode

		-- If the user didn't ask us to hide this popup, just return.
		if not APR.DB.HideDragonriding then
			DebugPrint("HideDragonriding off, not auto confirming")
			return
		end

		DebugPrint("HideDragonriding on, autoconfirm logic goes here")

	end -- DumpCallbackRegistry()

	EventRegistry:RegisterCallback("TalentButton.OnClick", DumpCallbackRegistry)

end -- WoW Classic check
