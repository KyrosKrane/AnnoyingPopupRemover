-- AnnoyingPopupRemover.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Licensed under the MIT License, as below.
--
-- Copyright (c) 2015 KyrosKrane Sylvanblade
--
--#########################################
--# License: MIT License
--#########################################

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.

-- This add-on file removes a number of annoying pop-ups.
--	It removes the popup confirmation dialog when looting a bind-on-pickup item.
--	It removes the popup confirmation dialog when rolling on a bind-on-pickup item.
--	It removes the popup confirmation dialog when adding a BOP item to void storage, and that item is modified (gemmed, enchanted, or transmogged) or still tradable with the looting group.


--#########################################
--# Global Variables
--#########################################

-- Define whether we're in debug mode or production mode. True means debug; false means production.
local DebugMode = false;

-- Set the current version so we can display it.
local APR_Version = "@project-version@";

-- Get a local reference to these functions to speed up execution.
local rawset = rawset
local tostring = tostring

-- Get the language used by the client.
local locale = GetLocale();


--#########################################
--# Saved Variables
--#########################################

-- Load the saved variables, or initialize if they don't exist yet.
APR_DB = APR_DB or { } ;


--#########################################
--# Utility Functions
--#########################################

-- Print debug output to the chat frame.
function DebugPrint(...)
	if (DebugMode) then
		print (L["APR"] .. " " .. L["Debug"] .. ": ", ...);
	end
end


-- Print standard output to the chat frame.
function ChatPrint(...)
	print (L["APR"] ..": ", ...);
end


-- Debugging code to see what the hell is being passed in...
function PrintVarArgs(...)
	local n = select('#', ...)
	DebugPrint ("There are ", n, " items in varargs.")
	local msg
	for i = 1, n do
		msg = select(i, ...)
		DebugPrint ("Item ", i, " is ", msg);
	end
end -- PrintVarArgs()


--#########################################
--# Slash command handling
--#########################################

-- Set the default slash command.
SLASH_APR1 = "/apr"
SlashCmdList.APR = function (...) HandleCommandLine(...) end

-- Dumps a table into chat. Not intended for production use.
function DumpTable(tab, indent)
	if not indent then indent = 0 end
	if indent > 10 then
		DebugPrint("Recursion is at 11 already; aborting.")
		return
	end
	for k, v in pairs(tab) do
		local s = ""
		if indent > 0 then
			for i = 0, indent do
				s = s .. "    ";
			end
		end
		if "table" == type(v) then
			s = s .. "Item " .. k .. " is sub-table." ;
			DebugPrint(s);
			indent = indent + 1;
			DumpTable(v, indent);
			indent = indent - 1;
		else
			s = s .. "Item " .. k .. " is " .. tostring(v);
			DebugPrint(s);
		end
	end
end


-- Splits a string into sections, based on a specified separator.
-- Split text into a list consisting of the strings in text,
-- separated by strings matching delimiter (which may be a pattern).
-- example: strsplit(",%s*", "Anna, Bob, Charlie,Dolores")
-- Taken from Lua manual: http://lua-users.org/wiki/SplitJoin
function strsplit(delimiter, text)
  local list = {}
	local pos = 1
	if strfind("", delimiter, 1) then
		-- this would result in endless loops
		-- error("delimiter matches empty string!")

		-- return the entire string instead.
		tinsert(list, text)
		return list
	end
	while 1 do
		local first, last = strfind(text, delimiter, pos)
		if first then -- found?
			tinsert(list, strsub(text, pos, first-1))
			pos = last+1
		else
			tinsert(list, strsub(text, pos))
			break
		end
	end
	return list
end


-- Respond to user chat-line commands.
function HandleCommandLine(msg, editbox)
	DebugPrint ("msg is " .. msg);
	local Line = strsplit("%s+", msg);
	-- DumpTable(Line);

	if "hideloot" == Line[1] then
		ChatPrint ("Loot is now " .. Line[2]);
	elseif "hideroll" == Line[1] then
		ChatPrint ("Roll selected");
	elseif "hidevoid" == Line[1] then
		ChatPrint ("Void selected");
	else
		if "help" == Line[1] then
			ChatPrint (L["Allowed commands for"] .. " " .. L["Annoying Pop-up Remover"] .. ":");
		else
			ChatPrint(L["Error: unknown command."])
		end
		-- Print the instructions for the user.
		ChatPrint(L["Allowed commands are:"]);
		ChatPrint("/apr hideloot on/off"); -- not localized on purpose
		ChatPrint("/apr hideroll on/off"); -- not localized on purpose
		ChatPrint("/apr hidevoid on/off"); -- not localized on purpose
		ChatPrint("/apr help"); -- not localized on purpose
	end


	--DumpTable(editbox); -- no clue why the slash command handler passes in info about the message box itself, but it does...
end -- HandleCommandLine()


--#########################################
--# Localization
--#########################################

-- This bit of meta-magic makes it so that if we call L with a key that doesn't yet exist, a key is created automatically, and its value is the name of the key.  For example, if L["MyAddon"] doesn't exist, and I run print (L["MyAddon"]), the __index command causes the L table to automatically create a new key called MyAddon, and its value is set to tostring("MyAddon") -- same as the key name.
L = setmetatable({ }, {__index = function(t, k)
	local v = tostring(k);
	rawset(t, k, v);
	return v;
end})

-- The above system effectively makes it so that we don't have to define the default, English-language values.  Just set the key name as the English value.
-- Set the default strings used here.  Other languages can override these as needed.
-- Not going to localize debug strings for now.

-- In another file, you can override these strings like:
-- if locale == "deDE" then
--		L["APR"] = "German name of APR here";
-- end
-- That way, it preserves the default English strings in case of a missed translation.


--#########################################
--# Event hooks
--#########################################


-- Create the frame to hold our event catcher, and the list of events.
local APR_Frame, events = CreateFrame("Frame"), {};


-- Looting a BOP item triggers this event.
function events:LOOT_BIND_CONFIRM(Frame, ...)
	if (DebugMode) then
		DebugPrint ("In events:LOOT_BIND_CONFIRM");
		DebugPrint ("Frame is ", Frame);
		PrintVarArgs(...);
	end -- if Debugmode

	local id = ...;
	ConfirmLootSlot(id);
end -- events:LOOT_BIND_CONFIRM()


-- Rolling on a BOP item triggers this event.
function events:CONFIRM_LOOT_ROLL(...)
	if (DebugMode) then
		DebugPrint ("In events:CONFIRM_LOOT_ROLL");
		PrintVarArgs(...);
	end -- if Debugmode

	local id, rollType = ...;

	DebugPrint ("id is ", id);
	DebugPrint ("rollType is ", rollType);

	ConfirmLootRoll(id, rollType);
end -- events:CONFIRM_LOOT_ROLL()


-- Depositing an item that's modified (gemmed, enchanted, or transmogged) or a BOP item still tradable in group triggers this event.
function events:VOID_DEPOSIT_WARNING(...)
	if (DebugMode) then
		DebugPrint ("In events:VOID_DEPOSIT_WARNING");
		PrintVarArgs(...);
	end -- if Debugmode

	-- Document the incoming parameters.
	-- local slot, itemLink = ...;

	VoidStorage_UpdateTransferButton(nil);
		-- prior to this event firing, the game triggers "VOID_STORAGE_DEPOSIT_UPDATE", which disables the transfer button and pops up the dialog.
		-- So, we simulate clicking OK with the UpdateTransferButton, and pass "nil" to indicate the warning dialog isn't showing.
end -- events:VOID_DEPOSIT_WARNING()


-- For debugging only.
function events:VOID_STORAGE_DEPOSIT_UPDATE(...)
	-- We don't actually do anything in this function; it's just for debugging.
	if (not DebugMode) then return end;

	DebugPrint ("In events:VOID_STORAGE_DEPOSIT_UPDATE");
	PrintVarArgs(...);

	-- Document the incoming parameters.
	-- local slot = ...;

end -- events:VOID_STORAGE_DEPOSIT_UPDATE()


-- On-load handler for addon initialization.
function events:PLAYER_LOGIN(...)
	-- Announce our load.
	ChatPrint (L["Annoying Pop-up Remover"] .. " " .. APR_Version .. " " .. L["loaded"] .. ".");

	-- Force the default Void Storage frame to load so we can override it.
	local isloaded, reason = LoadAddOn("Blizzard_VoidStorageUI")
	DebugPrint ("Blizzard_VoidStorageUI isloaded is ", isloaded);
	DebugPrint ("Blizzard_VoidStorageUI reason is ", reason);
end -- events:PLAYER_LOGIN()




-- Create the event handler function.
APR_Frame:SetScript("OnEvent", function(self, event, ...)
	events[event](self, ...); -- call one of the functions above
end);

-- Register all events for which handlers have been defined
for k, v in pairs(events) do
	DebugPrint ("Registering event ", k);
	APR_Frame:RegisterEvent(k);
end


--#########################################
--# Dialog management
--#########################################

-- Create a holder to store dialogs we're removing, in case I ever want to implement a per-dialog toggle (which means I'd have to restore the dialogs).
local StoredDialogs = {};

-- Disable the dialog that pops to confirm looting BoP gear yourself.
StoredDialogs["LOOT_BIND"] = StaticPopupDialogs["LOOT_BIND"];
StaticPopupDialogs["LOOT_BIND"] = nil;

-- Disable the dialog for the event that triggers when rolling on BOP items.
StoredDialogs["CONFIRM_LOOT_ROLL"] = StaticPopupDialogs["CONFIRM_LOOT_ROLL"];
StaticPopupDialogs["CONFIRM_LOOT_ROLL"] = nil;

-- Disable the dialog for putting tradable or modified items into void storage.
StoredDialogs["VOID_DEPOSIT_CONFIRM"] = StaticPopupDialogs["VOID_DEPOSIT_CONFIRM"];
StaticPopupDialogs["VOID_DEPOSIT_CONFIRM"] = nil;


--@do-not-package@
-- Curse-specific command to exclude this section from appearing for end users.

--#########################################
--# Local settings for debugging
--#########################################

DebugMode = true;
--@end-do-not-package@
