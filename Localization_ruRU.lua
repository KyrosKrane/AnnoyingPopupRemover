-- Localization_ruRU.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- Russian translations by ZamestoTV (Hubbotu on Github)
-- Copyright (c) 2015-2025 KyrosKrane Sylvanblade & ZamestoTV
-- Licensed under the MIT License, as per the included file.
-- Addon version: @project-version@

-- This file sets up localization and text strings for the addon in Russian.

--#########################################
--# Parameters
--#########################################

-- Grab the WoW-defined addon folder name and storage table for our addon
local addonName, APR = ...

-- Bail out if it's the wrong language.
if "ruRU" ~= APR.locale then return end

-- Get a handle to the localization table for easier reading
local L = APR.L

--Перевод ZamestoTV
--#########################################
--# Strings
--#########################################

-- Addon name
L["Annoying Pop-up Remover"] = "Annoying Pop-up Remover"
L["APR"] = "APR"


-- Version and startup message
L["Version_message"] = APR.Version .. " загружен."
L["Startup_message"] = L["Version_message"] .. " Для справки и настройки введите /apr"


-- Config options
L["startup_config"] = "Показывать сообщение о запуске аддона в окне чата при входе в игру"
L["status_config"] = "Вывести сводку текущих настроек в окно чата"
L["version_config"] = "Вывести версию APR и краткую справку"


-- Config headers
L["ItemsHeader"] = "Предметы"
L["VendoringHeader"] = "Торговля"
L["NPCInteractionHeader"] = "Взаимодействие с НПС"
L["GameInterfaceHeader"] = "Игровой интерфейс"
L["AddonOptionsHeader"] = "Параметры " .. L["APR"]


-- Status printing
L["startup_printed"] = "Сообщение о запуске аддона будет выводиться в окно чата при входе в игру."
L["startup_not_printed"] = "Сообщение о запуске аддона НЕ будет выводиться в окно чата при входе в игру."

L["Debug mode is now on."] = "Режим отладки включён."
L["Debug mode is now off."] = "Режим отладки отключён."


-- Configuration names and toggles

-- module_loot
L["loot_name"] = "Получение персонального при получении предмета"
L["loot_config"] = "Скрывать окно подтверждения при получении предметов, становящихся персональными при получении"
L["loot_hidden"] = "Окно подтверждения при " .. APR.Utilities.CHAT_GREEN .. "получении" .. FONT_COLOR_CODE_CLOSE .. " персональных при получении предметов будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["loot_shown"] = "Окно подтверждения при " .. APR.Utilities.CHAT_RED .. "получении" .. FONT_COLOR_CODE_CLOSE .. " персональных при получении предметов будет " .. APR.Utilities.CHAT_RED .. "отображаться" .. FONT_COLOR_CODE_CLOSE .. "."

-- roll
L["roll_name"] = "Розыгрыш персонального при получении предмета"
L["roll_config"] = "Скрывать окно подтверждения при розыгрыше предметов, становящихся персональными при получении"
L["roll_hidden"] = "Окно подтверждения при " .. APR.Utilities.CHAT_GREEN .. "розыгрыше" .. FONT_COLOR_CODE_CLOSE .. " персональных при получении предметов будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["roll_shown"] = "Окно подтверждения при " .. APR.Utilities.CHAT_RED .. "розыгрыше" .. FONT_COLOR_CODE_CLOSE .. " персональных при получении предметов будет " .. APR.Utilities.CHAT_RED .. "отображаться" .. FONT_COLOR_CODE_CLOSE .. "."

-- void
L["void_name"] = "Помещение в хранилище Бездны"
L["void_config"] = "Скрывать окно подтверждения при помещении улучшенных предметов в хранилище Бездны"
L["void_hidden"] = "Окно подтверждения при помещении улучшенных предметов в " .. APR.Utilities.CHAT_GREEN .. "хранилище Бездны" .. FONT_COLOR_CODE_CLOSE .. " будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["void_shown"] = "Окно подтверждения при помещении улучшенных предметов в " .. APR.Utilities.CHAT_RED .. "хранилище Бездны" .. FONT_COLOR_CODE_CLOSE .. " будет " .. APR.Utilities.CHAT_RED .. "отображаться" .. FONT_COLOR_CODE_CLOSE .. "."

-- vendor
L["vendor_name"] = "Продажа торговцу передаваемых предметов"
L["vendor_config"] = "Скрывать окно подтверждения при продаже торговцу предметов с возможностью обмена"
L["vendor_hidden"] = "Окно подтверждения при продаже " .. APR.Utilities.CHAT_GREEN .. "торговцу" .. FONT_COLOR_CODE_CLOSE .. " предметов с возможностью обмена будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["vendor_shown"] = "Окно подтверждения при продаже " .. APR.Utilities.CHAT_RED .. "торговцу" .. FONT_COLOR_CODE_CLOSE .. " предметов с возможностью обмена будет " .. APR.Utilities.CHAT_RED .. "отображаться" .. FONT_COLOR_CODE_CLOSE .. "."

-- buy_alt_currency
L["buy_name"] = "Покупка за альтернативную валюту (не за золото)"
L["buy_config"] = "Скрывать окно подтверждения при покупке предмета за альтернативную валюту"
L["buy_hidden"] = "Окно подтверждения при " .. APR.Utilities.CHAT_GREEN .. "покупке" .. FONT_COLOR_CODE_CLOSE .. " предмета за альтернативную валюту будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["buy_shown"] = "Окно подтверждения при " .. APR.Utilities.CHAT_RED .. "покупке" .. FONT_COLOR_CODE_CLOSE .. " предмета за альтернативную валюту будет " .. APR.Utilities.CHAT_RED .. "отображаться" .. FONT_COLOR_CODE_CLOSE .. "."

-- buy_nonrefundable
L["nonrefundable_name"] = "Покупка невозвратного предмета"
L["nonrefundable_config"] = "Скрывать окно подтверждения при покупке предмета, не подлежащего возврату"
L["nonrefundable_hidden"] = "Окно подтверждения при покупке " .. APR.Utilities.CHAT_GREEN .. "невозвратного" .. FONT_COLOR_CODE_CLOSE .. " предмета будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["nonrefundable_shown"] = "Окно подтверждения при покупке " .. APR.Utilities.CHAT_RED .. "невозвратного" .. FONT_COLOR_CODE_CLOSE .. " предмета будет " .. APR.Utilities.CHAT_RED .. "отображаться" .. FONT_COLOR_CODE_CLOSE .. "."

-- equip
L["equip_name"] = "Экипировка персональных при надевании предметов"
L["equip_config"] = "Скрывать окно подтверждения при экипировке предметов, становящихся персональными при надевании"
L["equip_hidden"] = "Окно подтверждения при " .. APR.Utilities.CHAT_GREEN .. "экипировке" .. FONT_COLOR_CODE_CLOSE .. " персональных при надевании предметов будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["equip_shown"] = "Окно подтверждения при " .. APR.Utilities.CHAT_RED .. "экипировке" .. FONT_COLOR_CODE_CLOSE .. " персональных при надевании предметов будет " .. APR.Utilities.CHAT_RED .. "отображаться" .. FONT_COLOR_CODE_CLOSE .. "."

-- equip_tradable
L["trade_name"] = "Экипировка или использование передаваемых предметов"
L["trade_config"] = "Скрывать окно подтверждения при экипировке или использовании предмета, полученного в группе, который всё ещё можно передать."
L["trade_hidden"] = "Окно подтверждения при экипировке или использовании полученных в группе предметов, которыми всё ещё можно " .. APR.Utilities.CHAT_GREEN .. "обменяться" .. FONT_COLOR_CODE_CLOSE .. ", будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["trade_shown"] = "Окно подтверждения при экипировке или использовании полученных в группе предметов, которыми всё ещё можно " .. APR.Utilities.CHAT_RED .. "обменяться" .. FONT_COLOR_CODE_CLOSE .. ", будет " .. APR.Utilities.CHAT_RED .. "отображаться" .. FONT_COLOR_CODE_CLOSE .. "."


-- equip_refund
L["refund_name"] = "Экипировка или использование возвратных предметов"
L["refund_config"] = "Скрывать окно подтверждения при экипировке или использовании предмета, который ещё можно вернуть торговцу"
L["refund_hidden"] = "Окно подтверждения при экипировке или использовании " .. APR.Utilities.CHAT_GREEN .. "возвратного" .. FONT_COLOR_CODE_CLOSE .. " предмета будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["refund_shown"] = "Окно подтверждения при экипировке или использовании " .. APR.Utilities.CHAT_RED .. "возвратного" .. FONT_COLOR_CODE_CLOSE .. " предмета будет " .. APR.Utilities.CHAT_RED .. "отображаться" .. FONT_COLOR_CODE_CLOSE .. "."

-- mail
L["mail_name"] = "Отправка возвратных предметов по почте"
L["mail_config"] = "Скрывать окно подтверждения при отправке возвратных предметов по почте"
L["mail_hidden"] = "Окно подтверждения при " .. APR.Utilities.CHAT_GREEN .. "отправке по почте" .. FONT_COLOR_CODE_CLOSE .. " возвратных предметов будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["mail_shown"] = "Окно подтверждения при " .. APR.Utilities.CHAT_RED .. "отправке по почте" .. FONT_COLOR_CODE_CLOSE .. " возвратных предметов будет " .. APR.Utilities.CHAT_RED .. "отображаться" .. FONT_COLOR_CODE_CLOSE .. "."

-- delete
L["delete_name"] = "Упрощение удаления важных предметов"
L["delete_config"] = "При удалении \"ценных\" предметов не требовать ввода слова \"удалить\""
L["delete_hidden"] = "При " .. APR.Utilities.CHAT_GREEN .. "удалении" .. FONT_COLOR_CODE_CLOSE .. " \"ценного\" предмета ввод слова \"удалить\" " .. APR.Utilities.CHAT_GREEN .. "не потребуется" .. FONT_COLOR_CODE_CLOSE .. "."
L["delete_shown"] = "При " .. APR.Utilities.CHAT_RED .. "удалении" .. FONT_COLOR_CODE_CLOSE .. " \"ценного\" предмета " .. APR.Utilities.CHAT_RED .. "потребуется" .. FONT_COLOR_CODE_CLOSE .. " ввод слова \"удалить\"."

-- innkeeper
L["innkeeper_name"] = "Привязка камня возвращения у хозяина таверны"
L["innkeeper_config"] = "Скрывать окно подтверждения при привязке камня возвращения у хозяина таверны"
L["innkeeper_hidden"] = "Окно подтверждения при привязке камня возвращения у " .. APR.Utilities.CHAT_GREEN .. "хозяина таверны" .. FONT_COLOR_CODE_CLOSE .. " будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["innkeeper_shown"] = "Окно подтверждения при привязке камня возвращения у " .. APR.Utilities.CHAT_RED .. "хозяина таверны" .. FONT_COLOR_CODE_CLOSE .. " будет " .. APR.Utilities.CHAT_RED .. "отображаться" .. FONT_COLOR_CODE_CLOSE .. "."

-- quest
L["quest_name"] = "Отмена задания"
L["quest_config"] = "Скрывать окно подтверждения при отмене задания"
L["quest_hidden"] = "Окно подтверждения при отмене " .. APR.Utilities.CHAT_GREEN .. "задания" .. FONT_COLOR_CODE_CLOSE .. " будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["quest_shown"] = "Окно подтверждения при отмене " .. APR.Utilities.CHAT_RED .. "задания" .. FONT_COLOR_CODE_CLOSE .. " будет " .. APR.Utilities.CHAT_RED .. "отображаться" .. FONT_COLOR_CODE_CLOSE .. "."

-- undercut
L["undercut_name"] = "Снижение цены на аукционе"
L["undercut_config"] = "Скрывать напоминание о том, что снижать цену при продаже на аукционе больше не требуется"
L["undercut_hidden"] = "Напоминание о том, что не нужно " .. APR.Utilities.CHAT_GREEN .. "снижать цену" .. FONT_COLOR_CODE_CLOSE .. " на аукционе, будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["undercut_shown"] = "Напоминание о том, что не нужно " .. APR.Utilities.CHAT_RED .. "снижать цену" .. FONT_COLOR_CODE_CLOSE .. " на аукционе, будет " .. APR.Utilities.CHAT_RED .. "отображаться" .. FONT_COLOR_CODE_CLOSE .. "."

-- dragonriding
L["dragonriding_name"] = "Изучение талантов полетов на драконах"
L["dragonriding_config"] = "Скрывать окно подтверждения при выборе таланта полетов на драконах"
L["dragonriding_hidden"] = "Окно подтверждения при выборе таланта " .. APR.Utilities.CHAT_GREEN .. "полетов на драконах" .. FONT_COLOR_CODE_CLOSE .. " будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["dragonriding_shown"] = "Окно подтверждения при выборе таланта " .. APR.Utilities.CHAT_RED .. "полетов на драконах" .. FONT_COLOR_CODE_CLOSE .. " будет " .. APR.Utilities.CHAT_RED .. "отображаться" .. FONT_COLOR_CODE_CLOSE .. "."

-- workorder
L["workorder_name"] = "Craft a work order with your own reagents"
L["workorder_config"] = "Hide the confirmation pop-up when crafting a work order that requires some of your own reagents."
L["workorder_hidden"] = "Confirmation pop-up when crafting a " .. APR.Utilities.CHAT_GREEN .. "workorder" .. FONT_COLOR_CODE_CLOSE .. " that uses your own reagents will be " .. APR.Utilities.CHAT_GREEN .. "hidden" .. FONT_COLOR_CODE_CLOSE .. "."
L["workorder_shown"] = "Confirmation pop-up when crafting a " .. APR.Utilities.CHAT_RED .. "workorder" .. FONT_COLOR_CODE_CLOSE .. " that uses your own reagents will be " .. APR.Utilities.CHAT_RED .. "shown" .. FONT_COLOR_CODE_CLOSE .. "."

-- actioncam
L["actioncam_name"] = "Использование экшн-камеры"
L["actioncam_config"] = "Скрывать окно предупреждения при использовании экшн-камеры"
L["actioncam_hidden"] = "Окно предупреждения при использовании " .. APR.Utilities.CHAT_GREEN .. "экшн-камеры" .. FONT_COLOR_CODE_CLOSE .. " будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["actioncam_shown"] = "Окно предупреждения при использовании " .. APR.Utilities.CHAT_RED .. "экшн-камеры" .. FONT_COLOR_CODE_CLOSE .. " будет " .. APR.Utilities.CHAT_RED .. "отображаться" .. FONT_COLOR_CODE_CLOSE .. "."

-- gossip
L["gossip_name"] = "Диалоги с НПС"
L["gossip_config"] = "Скрывать окна подтверждения в различных диалогах с НПС"
L["gossip_hidden"] = "Окна подтверждения при " .. APR.Utilities.CHAT_GREEN .. "разговоре" .. FONT_COLOR_CODE_CLOSE .. " с некоторыми НПС будут " .. APR.Utilities.CHAT_GREEN .. "скрыты" .. FONT_COLOR_CODE_CLOSE .. "."
L["gossip_shown"] = "Окна подтверждения при " .. APR.Utilities.CHAT_RED .. "разговоре" .. FONT_COLOR_CODE_CLOSE .. " с некоторыми НПС будут " .. APR.Utilities.CHAT_RED .. "отображаться" .. FONT_COLOR_CODE_CLOSE .. "."

-- followers
L["followers_name"] = "Управление соратниками за столом заданий"
L["followers_config"] = "Скрывать окно подтверждения при взаимодействии с соратниками за столом заданий"
L["followers_hidden"] = "Окно подтверждения при взаимодействии с " .. APR.Utilities.CHAT_GREEN .. "соратниками" .. FONT_COLOR_CODE_CLOSE .. " за столом заданий будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["followers_shown"] = "Окно подтверждения при взаимодействии с " .. APR.Utilities.CHAT_RED .. "соратниками" .. FONT_COLOR_CODE_CLOSE .. " за столом заданий будет " .. APR.Utilities.CHAT_RED .. "отображаться" .. FONT_COLOR_CODE_CLOSE .. "."

-- summon
L["summon_name"] = "Призыв с близкого расстояния"
L["summon_config"] = "Скрывать окно подтверждения при получении призыва от игрока поблизости. Удерживайте клавишу Shift, чтобы принять призыв"
L["summon_hidden"] = "Окно подтверждения при получении " .. APR.Utilities.CHAT_GREEN .. "призыва" .. FONT_COLOR_CODE_CLOSE .. " с близкого расстояния будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. ". Удерживайте клавишу Shift, чтобы принять призыв."
L["summon_shown"] = "Окно подтверждения при получении " .. APR.Utilities.CHAT_RED .. "призыва" .. FONT_COLOR_CODE_CLOSE .. " с близкого расстояния будет " .. APR.Utilities.CHAT_RED .. "отображаться" .. FONT_COLOR_CODE_CLOSE .. "."
L["summon_announce_auto_cancel"] = "Призыв от находящегося рядом игрока %s был автоматически отменён." -- %s is the name of the player who tried to summon the user.

-- warbank
L["warbank_name"] = "Помещение возвратного предмета в банк отряда"
L["warbank_config"] = "Скрывать окно подтверждения при помещении возвратного предмета в банк отряда"
L["warbank_hidden"] = "Окно подтверждения при помещении возвратного предмета в " .. APR.Utilities.CHAT_GREEN .. "банк отряда" .. FONT_COLOR_CODE_CLOSE .. " будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["warbank_shown"] = "Окно подтверждения при помещении возвратного предмета в " .. APR.Utilities.CHAT_RED .. "банк отряда" .. FONT_COLOR_CODE_CLOSE .. " будет " .. APR.Utilities.CHAT_RED .. "отображаться" .. FONT_COLOR_CODE_CLOSE .. "."

-- expensive
L["expensive_name"] = "Покупка предмета или завершение задания стоимостью до SUBSTITUTE_ME_LATER |TInterface\\MoneyFrame\\UI-GoldIcon:14:14:2:0|t"
L["expensive_config"] = "Скрывать окно подтверждения при покупке предмета или завершении задания стоимостью до SUBSTITUTE_ME_LATER |TInterface\\MoneyFrame\\UI-GoldIcon:14:14:2:0|t"
L["expensive_hidden"] = "Окно подтверждения при покупке " .. APR.Utilities.CHAT_GREEN .. "дорогого" .. FONT_COLOR_CODE_CLOSE .. " предмета или завершении задания, требующего золота, стоимостью до SUBSTITUTE_ME_LATER|TInterface\\MoneyFrame\\UI-GoldIcon:14:14:2:0|t будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["expensive_shown"] = "Окно подтверждения при покупке " .. APR.Utilities.CHAT_RED .. "дорогого" .. FONT_COLOR_CODE_CLOSE .. " предмета или завершении задания, требующего золота, стоимостью до SUBSTITUTE_ME_LATER|TInterface\\MoneyFrame\\UI-GoldIcon:14:14:2:0|t будет " .. APR.Utilities.CHAT_RED .. "отображаться" .. FONT_COLOR_CODE_CLOSE .. "."

-- prey
L["prey_name"] = "Участие в событиях Охоты в Midnight"
L["prey_config"] = "Скрывать окно подтверждения при начале или участии в Охоте в Midnight"
L["prey_hidden"] = "Окно подтверждения при начале или участии в " .. APR.Utilities.CHAT_GREEN .. "Охоте" .. FONT_COLOR_CODE_CLOSE .. " в Midnight будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["prey_shown"] = "Окно подтверждения при начале или участии в " .. APR.Utilities.CHAT_RED .. "Охоте" .. FONT_COLOR_CODE_CLOSE .. " в Midnight будет " .. APR.Utilities.CHAT_RED .. "отображаться" .. FONT_COLOR_CODE_CLOSE .. "."

-- equipment
L["equipment_name"] = "Использование управления экипировкой"
L["equipment_config"] = "Скрывать окно подтверждения при сохранении комплекта экипировки в управлении экипировкой"
L["equipment_hidden"] = "Окно подтверждения при сохранении комплекта экипировки в управлении " .. APR.Utilities.CHAT_GREEN .. "экипировкой" .. FONT_COLOR_CODE_CLOSE .. " будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["equipment_shown"] = "Окно подтверждения при сохранении комплекта экипировки в управлении " .. APR.Utilities.CHAT_RED .. "экипировкой" .. FONT_COLOR_CODE_CLOSE .. " будет " .. APR.Utilities.CHAT_RED .. "отображаться" .. FONT_COLOR_CODE_CLOSE .. "."
