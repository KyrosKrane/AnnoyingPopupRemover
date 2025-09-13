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
L["Annoying Pop-up Remover"] = "Удаление раздражающих всплывающих окон"
L["APR"] = "APR"


-- Version and startup message
L["Version_message"] = APR.Version .. " загружен."
L["Startup_message"] = L["Version_message"] .. " Для помощи и настроек введите /apr"


-- Config options
L["startup_config"] = "Показывать сообщение о запуске в окне чата при входе в игру"
L["status_config"] = "Выводить сводку настроек в окно чата"
L["version_config"] = "Выводить версию APR и краткую справку"


-- Config headers
L["ItemsHeader"] = "Предметы"
L["VendoringHeader"] = "Продажа"
L["NPCInteractionHeader"] = "Взаимодействие с NPC"
L["GameInterfaceHeader"] = "Игровой интерфейс"
L["AddonOptionsHeader"] = L["APR"] .. " Настройки"


-- Status printing
L["startup_printed"] = "Сообщение о запуске будет отображаться в окне чата при входе в игру."
L["startup_not_printed"] = "Сообщение о запуске НЕ будет отображаться в окне чата при входе в игру."

L["Debug mode is now on."] = "Режим отладки включен."
L["Debug mode is now off."] = "Режим отладки выключен."


-- Configuration names and toggles

-- module_loot
L["loot_name"] = "Сбор персональных при поднятии предметов"
L["loot_config"] = "Скрывать всплывающее окно подтверждения при сборе персональных при поднятии предметов"
L["loot_hidden"] = "Всплывающее окно подтверждения при " .. APR.Utilities.CHAT_GREEN .. "сборе" .. FONT_COLOR_CODE_CLOSE .. " персональных при поднятии предметов будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["loot_shown"] = "Всплывающее окно подтверждения при " .. APR.Utilities.CHAT_RED .. "сборе" .. FONT_COLOR_CODE_CLOSE .. " персональных при поднятии предметов будет " .. APR.Utilities.CHAT_RED .. "показано" .. FONT_COLOR_CODE_CLOSE .. "."

-- roll
L["roll_name"] = "Розыгрыш персональных при поднятии предметов"
L["roll_config"] = "Скрывать всплывающее окно подтверждения при розыгрыше персональных при поднятии предметов"
L["roll_hidden"] = "Всплывающее окно подтверждения при " .. APR.Utilities.CHAT_GREEN .. "розыгрыше" .. FONT_COLOR_CODE_CLOSE .. " персональных при поднятии предметов будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["roll_shown"] = "Всплывающее окно подтверждения при " .. APR.Utilities.CHAT_RED .. "розыгрыше" .. FONT_COLOR_CODE_CLOSE .. " персональных при поднятии предметов будет " .. APR.Utilities.CHAT_RED .. "показано" .. FONT_COLOR_CODE_CLOSE .. "."

-- void
L["void_name"] = "Хранение в Хранилище Бездны"
L["void_config"] = "Скрывать всплывающее окно подтверждения при помещении модифицированных предметов в Хранилище Бездны"
L["void_hidden"] = "Всплывающее окно подтверждения при помещении модифицированных предметов в " .. APR.Utilities.CHAT_GREEN .. "Хранилище Бездны" .. FONT_COLOR_CODE_CLOSE .. " будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["void_shown"] = "Всплывающее окно подтверждения при помещении модифицированных предметов в " .. APR.Utilities.CHAT_RED .. "Хранилище Бездны" .. FONT_COLOR_CODE_CLOSE .. " будет " .. APR.Utilities.CHAT_RED .. "показано" .. FONT_COLOR_CODE_CLOSE .. "."

-- vendor
L["vendor_name"] = "Продажа передаваемых предметов"
L["vendor_config"] = "Скрывать всплывающее окно подтверждения при продаже предметов, добытых в группе, торговцу"
L["vendor_hidden"] = "Всплывающее окно подтверждения при продаже предметов, добытых в группе, " .. APR.Utilities.CHAT_GREEN .. "торговцу" .. FONT_COLOR_CODE_CLOSE .. " будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["vendor_shown"] = "Всплывающее окно подтверждения при продаже предметов, добытых в группе, " .. APR.Utilities.CHAT_RED .. "торговцу" .. FONT_COLOR_CODE_CLOSE .. " будет " .. APR.Utilities.CHAT_RED .. "показано" .. FONT_COLOR_CODE_CLOSE .. "."

-- buy_alt_currency
L["buy_name"] = "Покупка за альтернативную валюту (не золото)"
L["buy_config"] = "Скрывать всплывающее окно подтверждения при покупке предмета за альтернативную валюту"
L["buy_hidden"] = "Всплывающее окно подтверждения при " .. APR.Utilities.CHAT_GREEN .. "покупке" .. FONT_COLOR_CODE_CLOSE .. " предмета за альтернативную валюту будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["buy_shown"] = "Всплывающее окно подтверждения при " .. APR.Utilities.CHAT_RED .. "покупке" .. FONT_COLOR_CODE_CLOSE .. " предмета за альтернативную валюту будет " .. APR.Utilities.CHAT_RED .. "показано" .. FONT_COLOR_CODE_CLOSE .. "."

-- buy_nonrefundable
L["nonrefundable_name"] = "Покупка невозвратных предметов"
L["nonrefundable_config"] = "Скрывать всплывающее окно подтверждения при покупке невозвратного предмета"
L["nonrefundable_hidden"] = "Всплывающее окно подтверждения при покупке " .. APR.Utilities.CHAT_GREEN .. "невозвратного" .. FONT_COLOR_CODE_CLOSE .. " предмета будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["nonrefundable_shown"] = "Всплывающее окно подтверждения при покупке " .. APR.Utilities.CHAT_RED .. "невозвратного" .. FONT_COLOR_CODE_CLOSE .. " предмета будет " .. APR.Utilities.CHAT_RED .. "показано" .. FONT_COLOR_CODE_CLOSE .. "."

-- equip
L["equip_name"] = "Экипировка персональных при экипировке предметов"
L["equip_config"] = "Скрывать всплывающее окно подтверждения при экипировке персональных при экипировке предметов"
L["equip_hidden"] = "Всплывающее окно подтверждения при " .. APR.Utilities.CHAT_GREEN .. "экипировке" .. FONT_COLOR_CODE_CLOSE .. " персональных при экипировке предметов будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["equip_shown"] = "Всплывающее окно подтверждения при " .. APR.Utilities.CHAT_RED .. "экипировке" .. FONT_COLOR_CODE_CLOSE .. " персональных при экипировке предметов будет " .. APR.Utilities.CHAT_RED .. "показано" .. FONT_COLOR_CODE_CLOSE .. "."

-- equip_tradable
L["trade_name"] = "Экипировка передаваемых предметов"
L["trade_config"] = "Скрывать всплывающее окно подтверждения при экипировке предметов, добытых в группе, которые всё ещё можно передать."
L["trade_hidden"] = "Всплывающее окно подтверждения при экипировке предметов, добытых в группе, которые всё ещё можно " .. APR.Utilities.CHAT_GREEN .. "передать" .. FONT_COLOR_CODE_CLOSE .. ", будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["trade_shown"] = "Всплывающее окно подтверждения при экипировке предметов, добытых в группе, которые всё ещё можно " .. APR.Utilities.CHAT_RED .. "передать" .. FONT_COLOR_CODE_CLOSE .. ", будет " .. APR.Utilities.CHAT_RED .. "показано" .. FONT_COLOR_CODE_CLOSE .. "."

-- equip_refund
L["refund_name"] = "Экипировка или использование возвратных предметов"
L["refund_config"] = "Скрывать всплывающее окно подтверждения при экипировке или использовании предмета, который всё ещё можно вернуть"
L["refund_hidden"] = "Всплывающее окно подтверждения при экипировке или использовании " .. APR.Utilities.CHAT_GREEN .. "возвратного" .. FONT_COLOR_CODE_CLOSE .. " предмета будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["refund_shown"] = "Всплывающее окно подтверждения при экипировке или использовании " .. APR.Utilities.CHAT_RED .. "возвратного" .. FONT_COLOR_CODE_CLOSE .. " предмета будет " .. APR.Utilities.CHAT_RED .. "показано" .. FONT_COLOR_CODE_CLOSE .. "."

-- mail
L["mail_name"] = "Отправка возвратных предметов по почте"
L["mail_config"] = "Скрывать всплывающее окно подтверждения при отправке возвратных предметов по почте"
L["mail_hidden"] = "Всплывающее окно подтверждения при " .. APR.Utilities.CHAT_GREEN .. "отправке" .. FONT_COLOR_CODE_CLOSE .. " возвратных предметов по почте будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["mail_shown"] = "Всплывающее окно подтверждения при " .. APR.Utilities.CHAT_RED .. "отправке" .. FONT_COLOR_CODE_CLOSE .. " возвратных предметов по почте будет " .. APR.Utilities.CHAT_RED .. "показано" .. FONT_COLOR_CODE_CLOSE .. "."

-- delete
L["delete_name"] = "Облегчение удаления важных предметов"
L["delete_config"] = "При удалении \"хороших\" предметов не требовать ввода слова \"delete\""
L["delete_hidden"] = "При " .. APR.Utilities.CHAT_GREEN .. "удалении" .. FONT_COLOR_CODE_CLOSE .. " \"хорошего\" предмета не будет " .. APR.Utilities.CHAT_GREEN .. "требоваться" .. FONT_COLOR_CODE_CLOSE .. " ввод слова \"delete\"."
L["delete_shown"] = "При " .. APR.Utilities.CHAT_RED .. "удалении" .. FONT_COLOR_CODE_CLOSE .. " \"хорошего\" предмета будет " .. APR.Utilities.CHAT_RED .. "требоваться" .. FONT_COLOR_CODE_CLOSE .. " ввод слова \"delete\"."

-- innkeeper
L["innkeeper_name"] = "Привязка у хозяина таверны"
L["innkeeper_config"] = "Скрывать всплывающее окно подтверждения при привязке у хозяина таверны"
L["innkeeper_hidden"] = "Всплывающее окно подтверждения при привязке у " .. APR.Utilities.CHAT_GREEN .. "хозяина таверны" .. FONT_COLOR_CODE_CLOSE .. " будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["innkeeper_shown"] = "Всплывающее окно подтверждения при привязке у " .. APR.Utilities.CHAT_RED .. "хозяина таверны" .. FONT_COLOR_CODE_CLOSE .. " будет " .. APR.Utilities.CHAT_RED .. "показано" .. FONT_COLOR_CODE_CLOSE .. "."

-- quest
L["quest_name"] = "Отказ от задания"
L["quest_config"] = "Скрывать всплывающее окно при отказе от задания"
L["quest_hidden"] = "Всплывающее окно при отказе от " .. APR.Utilities.CHAT_GREEN .. "задания" .. FONT_COLOR_CODE_CLOSE .. " будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["quest_shown"] = "Всплывающее окно при отказе от " .. APR.Utilities.CHAT_RED .. "задания" .. FONT_COLOR_CODE_CLOSE .. " будет " .. APR.Utilities.CHAT_RED .. "показано" .. FONT_COLOR_CODE_CLOSE .. "."

-- undercut
L["undercut_name"] = "Снижение цены на аукционе"
L["undercut_config"] = "Скрывать напоминание о том, что снижение цены больше не требуется при продаже на аукционе"
L["undercut_hidden"] = "Напоминание о ненужности " .. APR.Utilities.CHAT_GREEN .. "снижения цены" .. FONT_COLOR_CODE_CLOSE .. " на аукционе будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["undercut_shown"] = "Напоминание о ненужности " .. APR.Utilities.CHAT_RED .. "снижения цены" .. FONT_COLOR_CODE_CLOSE .. " на аукционе будет " .. APR.Utilities.CHAT_RED .. "показано" .. FONT_COLOR_CODE_CLOSE .. "."

-- dragonriding
L["dragonriding_name"] = "Изучение талантов драконьей езды"
L["dragonriding_config"] = "Скрывать всплывающее окно подтверждения при выборе таланта драконьей езды"
L["dragonriding_hidden"] = "Всплывающее окно подтверждения при выборе таланта " .. APR.Utilities.CHAT_GREEN .. "драконьей езды" .. FONT_COLOR_CODE_CLOSE .. " будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["dragonriding_shown"] = "Всплывающее окно подтверждения при выборе таланта " .. APR.Utilities.CHAT_RED .. "драконьей езды" .. FONT_COLOR_CODE_CLOSE .. " будет " .. APR.Utilities.CHAT_RED .. "показано" .. FONT_COLOR_CODE_CLOSE .. "."

-- workorder
L["workorder_name"] = "Создание заказа с использованием собственных реагентов"
L["workorder_config"] = "Скрывать всплывающее окно подтверждения при создании заказа, требующего ваших собственных реагентов."
L["workorder_hidden"] = "Всплывающее окно подтверждения при создании " .. APR.Utilities.CHAT_GREEN .. "заказа" .. FONT_COLOR_CODE_CLOSE .. ", использующего ваши реагенты, будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["workorder_shown"] = "Всплывающее окно подтверждения при создании " .. APR.Utilities.CHAT_RED .. "заказа" .. FONT_COLOR_CODE_CLOSE .. ", использующего ваши реагенты, будет " .. APR.Utilities.CHAT_RED .. "показано" .. FONT_COLOR_CODE_CLOSE .. "."

-- actioncam
L["actioncam_name"] = "Использование ActionCam"
L["actioncam_config"] = "Скрывать всплывающее окно предупреждения при использовании ActionCam"
L["actioncam_hidden"] = "Всплывающее окно предупреждения при использовании " .. APR.Utilities.CHAT_GREEN .. "ActionCam" .. FONT_COLOR_CODE_CLOSE .. " будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["actioncam_shown"] = "Всплывающее окно предупреждения при использовании " .. APR.Utilities.CHAT_RED .. "ActionCam" .. FONT_COLOR_CODE_CLOSE .. " будет " .. APR.Utilities.CHAT_RED .. "показано" .. FONT_COLOR_CODE_CLOSE .. "."

-- gossip
L["gossip_name"] = "Разговор с NPC"
L["gossip_config"] = "Скрывать всплывающее окно подтверждения для различных разговоров с NPC"
L["gossip_hidden"] = "Всплывающее окно подтверждения при " .. APR.Utilities.CHAT_GREEN .. "разговоре" .. FONT_COLOR_CODE_CLOSE .. " с некоторыми NPC будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["gossip_shown"] = "Всплывающее окно подтверждения при " .. APR.Utilities.CHAT_RED .. "разговоре" .. FONT_COLOR_CODE_CLOSE .. " с некоторыми NPC будет " .. APR.Utilities.CHAT_RED .. "показано" .. FONT_COLOR_CODE_CLOSE .. "."

-- followers
L["followers_name"] = "Экипировка или улучшение спутников предметами"
L["followers_config"] = "Скрывать всплывающее окно подтверждения при использовании предметов для спутников за столом заданий"
L["followers_hidden"] = "Всплывающее окно подтверждения при улучшении " .. APR.Utilities.CHAT_GREEN .. "спутников" .. FONT_COLOR_CODE_CLOSE .. " за столом заданий будет " .. APR.Utilities.CHAT_GREEN .. "скрыто" .. FONT_COLOR_CODE_CLOSE .. "."
L["followers_shown"] = "Всплывающее окно подтверждения при улучшении " .. APR.Utilities.CHAT_RED .. "спутников" .. FONT_COLOR_CODE_CLOSE .. " за столом заданий будет " .. APR.Utilities.CHAT_RED .. "показано" .. FONT_COLOR_CODE_CLOSE .. "."

-- module specific strings
L["Darkmoon_travel"] = "Поездка в зону подготовки ярмарки будет стоить:"
