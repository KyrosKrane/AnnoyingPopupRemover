-- AutoLootBOP.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Licensed under the MIT License, as below.
--
-- Copyright (c) 2015 KyrosKrane Sylvanblade
--
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

-- Define whether we're in debug mode or production mode. True means debug; false means production.
local DebugMode = true;


-- Print debug output to the chat frame.
function DebugPrint(...)
	if (DebugMode) then
		print (...);
	end
end


-- Figure out what sort of variable we're dealing with.
function typeof(var)
    local _type = type(var);
    if(_type ~= "table" and _type ~= "userdata") then
        return _type;
    end
    local _meta = getmetatable(var);
    if(_meta ~= nil and _meta._NAME ~= nil) then
        return _meta._NAME;
    else
        return _type;
    end
end -- typeof()


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

-- Create the frame to hold our event catcher, and the list of events.
local AutoLootBOP_Frame, events = CreateFrame("Frame"), {};

-- Looting a BOP item triggers this event.
function events:LOOT_BIND_CONFIRM(Self, ...)
	if (DebugMode) then
		DebugPrint ("In events:LOOT_BIND_CONFIRM");
		DebugPrint ("Self is ", Self);
		--DebugPrint ("typeof Self is ", typeof(Self));
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

	-- local id, rollType;
	-- id = select(1, ...);
	-- rollType = select(2, ...);
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


-- Create the event handler function.
AutoLootBOP_Frame:SetScript("OnEvent", function(self, event, ...)
	events[event](self, ...); -- call one of the functions above
end);

-- Register all events for which handlers have been defined
for k, v in pairs(events) do
	DebugPrint ("Registering event ", k);
	AutoLootBOP_Frame:RegisterEvent(k);
end

-- Disable the dialog that pops to confirm looting BoP gear yourself.
StaticPopupDialogs["LOOT_BIND"] = nil;

-- Disable the dialog for the event that triggers when rolling on BOP items.
StaticPopupDialogs["CONFIRM_LOOT_ROLL"] = nil;

-- Disable the dialog for putting tradable or modified items into void storage.
StaticPopupDialogs["VOID_DEPOSIT_CONFIRM"] = nil;
