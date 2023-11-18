# No more "Mother, may I?"
Ever get annoyed by those pop-ups in the game that make you feel like it's an over-protective parent scolding you each time you try something? This add-on is for you! It removes several annoying confirmation dialogs that pop up to warn you you're about to do something, even though it's mostly inconsequential.

- Looting a bind-on-pickup item.
- Rolling on a bind-on-pickup item.
- Depositing a modified item (one that's enchanted, gemmed, or still tradable) into void storage. 
- Selling an item looted in a group while it is still tradable with others who were in the group.
- Buying an item with an alternate currency cost.
- Buying an item that is not refundable.
- Mailing an item you purchased from a vendor while it can still be returned for a refund.
- Setting your hearthstone location at an innkeeper.
- Undercutting when selling an item on the auction house. (This is off by default - please don't undercut, it's not needed!)
- Equipping an item you can return to a vendor for a refund.
- Equipping an item looted in a group while it is still tradable with others who were in the group.
- Equipping a bind-on-equip item. (This is off by default; you can turn it on in the settings.)
- Abandoning a quest.
- Buying a dragonriding talent.
- Crafting a profession work order using your own reagents or materials.
- Enabling the ActionCam or other experimental settings.
- Chatting with NPCs, such as teleporting to the Darkmoon Faire, healing pets at a stable master, or starting pet battles.

In addition, it simplifies the following dialog:

- Changing the dialog that requires you to type "delete" when deleting a good item into a simple yes/no box.

You can change your settings using the standard addon options screen, or using the command line options in the game. Your settings are saved separately for each character, so you can set it up as you like.

## Configuration
The easiest way to configure the addon is through the standard Blizzard addon interface. If you want to use the command line instead, type `/apr` to see your options.

## Version Notes
Version 19 revamps the options window and adds French localization - thanks Klep-Ysondre!

Version 18 adds the option to hide the pop-up when you chat with some NPCs, and when using the ActionCam.

So far, I've tested this add-on in a variety of situations, and it seems to work well for all scenarios I've encountered. If you encounter any errors, PLEASE [open an issue](https://github.com/KyrosKrane/AnnoyingPopupRemover/issues) on Github including the FULL error message and what you were doing when it happened. I also need to know whether you were solo, in a group, or in a raid; and what the group/raid loot settings were (e.g., master loot, NBG, etc., and what the loot threshold was).

## Known errors
I tried to include the most common stable masters and pet battles, but I might have missed some. If you see a popup asking you to confirm healing your pets at a stable master or to confirm starting a pet battle, please report it in [my Discord server](https://discord.gg/YRBDrxQ). I'll need to know your player faction (Horde/Alliance) and the name of the pet tamer or stable master you got the popup from.

I've had reports that the addon can interfere with picking up bind-on-pickup items on Classic Era and Wrath Classic servers. Reported examples are fishing up Old Ironjaw or Old Crafty. I've never been able to reproduce this properly, so I don't know what the root cause is or how to fix it. If you are trying for those fish, I suggest disabling the options for looting bind-on-pickup items.

I don't have a toon high enough to test thoroughly on WoW Classic, so if you find any errors, please report them! Preferably [open an issue](https://github.com/KyrosKrane/AnnoyingPopupRemover/issues) on Github, or if you don't have a Github account, you can post a comment here.

## Future update plans
Let me know what you'd like to see in the comments section. Or for live support, [visit my Discord server](https://discord.gg/YRBDrxQ)!
