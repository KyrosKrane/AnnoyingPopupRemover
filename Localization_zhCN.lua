-- Localization_zhCN.lua
-- 由 KyrosKrane Sylvanblade (kyros@kyros.info) 编写
-- 中文翻译基于 Klep-Ysondre 的 Github 法文翻译。
-- 版权所有 (c) 2023 KyrosKrane Sylvanblade
-- 遵循随附文件中的 MIT 许可证。

-- 此文件为插件设置简体中文本地化和文本字符串。


--#########################################
--# 参数
--#########################################

-- 获取 WoW 定义的插件文件夹名称和我们插件的存储表
local addonName, APR = ...

-- 如果语言不是简体中文则退出
if "zhCN" ~= APR.locale then return end

-- 获取本地化表的句柄以便于阅读
local L = APR.L


--#########################################
--# 字符串
--#########################################

-- 插件名称
L["Annoying Pop-up Remover"] = "烦人弹窗移除器"
L["APR"] = "APR" -- 缩写保持英文


-- 版本和启动消息
L["Version_message"] = APR.Version .. " 已加载。"
L["Startup_message"] = L["Version_message"] .. " 输入 /apr 查看帮助和选项"


-- 配置选项
L["startup_config"] = "登录时显示欢迎信息"
L["status_config"] = "在聊天窗口打印设置摘要"
L["version_config"] = "显示 APR 版本和帮助摘要"

-- 配置标题
L["ItemsHeader"] = "物品"
L["VendoringHeader"] = "出售"
L["NPCInteractionHeader"] = "NPC 交互"
L["GameInterfaceHeader"] = "游戏界面"
L["AddonOptionsHeader"] = L["APR"] .. " 选项"


-- 状态打印
L["startup_printed"] = "下次登录时将显示公告信息。"
L["startup_not_printed"] = "下次登录时将不会显示公告信息。"

L["Debug mode is now on."] = "调试模式现已开启。"
L["Debug mode is now off."] = "调试模式现已关闭。"


-- 配置名称和开关

-- module_loot
L["loot_name"] = "拾取绑定装备"
L["loot_config"] = "拾取装备绑定物品时隐藏确认窗口"
L["loot_hidden"] = "拾取" .. APR.Utilities.CHAT_GREEN .. "装备绑定" .. FONT_COLOR_CODE_CLOSE .. "物品时的确认窗口将被" .. APR.Utilities.CHAT_GREEN .. "隐藏" .. FONT_COLOR_CODE_CLOSE .. "。"
L["loot_shown"] = "拾取" .. APR.Utilities.CHAT_RED .. "装备绑定" .. FONT_COLOR_CODE_CLOSE .. "物品时的确认窗口将被" .. APR.Utilities.CHAT_RED .. "显示" .. FONT_COLOR_CODE_CLOSE .. "。"

-- roll
L["roll_name"] = "对拾取绑定物品使用贪婪/需求"
L["roll_config"] = "对拾取绑定物品使用贪婪/需求时隐藏确认窗口"
L["roll_hidden"] = "对拾取绑定物品使用" .. APR.Utilities.CHAT_GREEN .. "贪婪/需求" .. FONT_COLOR_CODE_CLOSE .. "时的确认窗口将被" .. APR.Utilities.CHAT_GREEN .. "隐藏" .. FONT_COLOR_CODE_CLOSE .. "。"
L["roll_shown"] = "对拾取绑定物品使用" .. APR.Utilities.CHAT_RED .. "贪婪/需求" .. FONT_COLOR_CODE_CLOSE .. "时的确认窗口将被" .. APR.Utilities.CHAT_RED .. "显示" .. FONT_COLOR_CODE_CLOSE .. "。"

-- void
L["void_name"] = "虚空仓库"
L["void_config"] = "将幻化物品存入虚空仓库时隐藏确认窗口"
L["void_hidden"] = "将幻化物品存入" .. APR.Utilities.CHAT_GREEN .. "虚空仓库" .. FONT_COLOR_CODE_CLOSE .. "时的确认窗口将被" .. APR.Utilities.CHAT_GREEN .. "隐藏" .. FONT_COLOR_CODE_CLOSE .. "。"
L["void_shown"] = "将幻化物品存入" .. APR.Utilities.CHAT_RED .. "虚空仓库" .. FONT_COLOR_CODE_CLOSE .. "时的确认窗口将被" .. APR.Utilities.CHAT_RED .. "显示" .. FONT_COLOR_CODE_CLOSE .. "。"

-- vendor
L["vendor_name"] = "出售可退还物品"
L["vendor_config"] = "出售队伍分配物品时隐藏确认窗口"
L["vendor_hidden"] = "出售队伍分配物品时的确认窗口将被" .. APR.Utilities.CHAT_GREEN .. "隐藏" .. FONT_COLOR_CODE_CLOSE .. "。"
L["vendor_shown"] = "出售队伍分配物品时的确认窗口将被" .. APR.Utilities.CHAT_RED .. "显示" .. FONT_COLOR_CODE_CLOSE .. "。"

-- buy_alt_currency
L["buy_name"] = "用非金币货币购买"
L["buy_config"] = "用非金币货币购买物品时隐藏确认窗口"
L["buy_hidden"] = "用非金币货币" .. APR.Utilities.CHAT_GREEN .. "购买" .. FONT_COLOR_CODE_CLOSE .. "物品时的确认窗口将被" .. APR.Utilities.CHAT_GREEN .. "隐藏" .. FONT_COLOR_CODE_CLOSE .. "。"
L["buy_shown"]  = "用非金币货币" .. APR.Utilities.CHAT_RED .. "购买" .. FONT_COLOR_CODE_CLOSE .. "物品时的确认窗口将被" .. APR.Utilities.CHAT_RED .. "显示" .. FONT_COLOR_CODE_CLOSE .. "。"

-- buy_nonrefundable
L["nonrefundable_name"] = "购买不可退还物品"
L["nonrefundable_config"] = "购买不可退还物品时隐藏确认窗口"
L["nonrefundable_hidden"] = "购买" .. APR.Utilities.CHAT_GREEN .. "不可退还" .. FONT_COLOR_CODE_CLOSE .. "物品时的确认窗口将被" .. APR.Utilities.CHAT_GREEN .. "隐藏" .. FONT_COLOR_CODE_CLOSE .. "。"
L["nonrefundable_shown"]  = "购买" .. APR.Utilities.CHAT_RED .. "不可退还" .. FONT_COLOR_CODE_CLOSE .. "物品时的确认窗口将被" .. APR.Utilities.CHAT_RED .. "显示" .. FONT_COLOR_CODE_CLOSE .. "。"

-- equip
L["equip_name"] = "装备绑定物品"
L["equip_config"] = "装备装备绑定物品时隐藏确认窗口"
L["equip_hidden"] = "装备" .. APR.Utilities.CHAT_GREEN .. "装备绑定" .. FONT_COLOR_CODE_CLOSE .. "物品时的确认窗口将被" .. APR.Utilities.CHAT_GREEN .. "隐藏" .. FONT_COLOR_CODE_CLOSE .. "。"
L["equip_shown"] = "装备" .. APR.Utilities.CHAT_RED .. "装备绑定" .. FONT_COLOR_CODE_CLOSE .. "物品时的确认窗口将被" .. APR.Utilities.CHAT_RED .. "显示" .. FONT_COLOR_CODE_CLOSE .. "。"

-- equip_tradable
L["trade_name"] = "装备仍可交易的物品"
L["trade_config"] = "装备在队伍中拾取且仍可交易的物品时隐藏确认窗口"
L["trade_hidden"] = "装备在队伍中拾取且仍可" .. APR.Utilities.CHAT_GREEN .. "交易" .. FONT_COLOR_CODE_CLOSE .. "的物品时的确认窗口将被" .. APR.Utilities.CHAT_GREEN .. "隐藏" .. FONT_COLOR_CODE_CLOSE .. "。"
L["trade_shown"] = "装备在队伍中拾取且仍可" .. APR.Utilities.CHAT_RED .. "交易" .. FONT_COLOR_CODE_CLOSE .. "的物品时的确认窗口将被" .. APR.Utilities.CHAT_RED .. "显示" .. FONT_COLOR_CODE_CLOSE .. "。"

-- equip_refund
L["refund_name"] = "装备或使用可退还物品"
L["refund_config"] = "装备或使用仍可退还的物品时隐藏确认窗口"
L["refund_hidden"] = "装备或使用仍可" .. APR.Utilities.CHAT_GREEN .. "退还" .. FONT_COLOR_CODE_CLOSE .. "的物品时的确认窗口将被" .. APR.Utilities.CHAT_GREEN .. "隐藏" .. FONT_COLOR_CODE_CLOSE .. "。"
L["refund_shown"] = "装备或使用仍可" .. APR.Utilities.CHAT_RED .. "退还" .. FONT_COLOR_CODE_CLOSE .. "的物品时的确认窗口将被" .. APR.Utilities.CHAT_RED .. "显示" .. FONT_COLOR_CODE_CLOSE .. "。"

-- mail
L["mail_name"] = "邮寄可退还物品"
L["mail_config"] = "邮寄可退还物品时隐藏确认窗口"
L["mail_hidden"] = "邮寄" .. APR.Utilities.CHAT_GREEN .. "可退还物品" .. FONT_COLOR_CODE_CLOSE .. "时的确认窗口将被" .. APR.Utilities.CHAT_GREEN .. "隐藏" .. FONT_COLOR_CODE_CLOSE .. "。"
L["mail_shown"] = "邮寄" .. APR.Utilities.CHAT_RED .. "可退还物品" .. FONT_COLOR_CODE_CLOSE .. "时的确认窗口将被" .. APR.Utilities.CHAT_RED .. "显示" .. FONT_COLOR_CODE_CLOSE .. "。"

-- delete
L["delete_name"] = "快速删除物品"
L["delete_config"] = "删除史诗或精良物品时不再需要输入“DELETE”"
L["delete_hidden"] = "删除" .. APR.Utilities.CHAT_GREEN .. "史诗或精良" .. FONT_COLOR_CODE_CLOSE .. "物品时，" .. APR.Utilities.CHAT_GREEN .. "无需" .. FONT_COLOR_CODE_CLOSE .. "再输入“DELETE”。"
L["delete_shown"] = "删除" .. APR.Utilities.CHAT_RED .. "史诗或精良" .. FONT_COLOR_CODE_CLOSE .. "物品时，" .. APR.Utilities.CHAT_RED .. "需要" .. FONT_COLOR_CODE_CLOSE .. "输入“DELETE”。"

-- innkeeper
L["innkeeper_name"] = "设置新旅店"
L["innkeeper_config"] = "要求旅店老板将此地设为炉石绑定点时隐藏确认窗口"
L["innkeeper_hidden"] = "要求" .. APR.Utilities.CHAT_GREEN .. "旅店老板" .. FONT_COLOR_CODE_CLOSE .. "将此地设为炉石绑定点时的确认窗口将被" .. APR.Utilities.CHAT_GREEN .. "隐藏" .. FONT_COLOR_CODE_CLOSE .. "。"
L["innkeeper_shown"] = "要求" .. APR.Utilities.CHAT_RED .. "旅店老板" .. FONT_COLOR_CODE_CLOSE .. "将此地设为炉石绑定点时的确认窗口将被" .. APR.Utilities.CHAT_RED .. "显示" .. FONT_COLOR_CODE_CLOSE .. "。"

-- quest
L["quest_name"] = "放弃任务"
L["quest_config"] = "放弃任务时隐藏确认窗口"
L["quest_hidden"] = "放弃" .. APR.Utilities.CHAT_GREEN .. "任务" .. FONT_COLOR_CODE_CLOSE .. "时的确认窗口将被" .. APR.Utilities.CHAT_GREEN .. "隐藏" .. FONT_COLOR_CODE_CLOSE .. "。"
L["quest_shown"] = "放弃" .. APR.Utilities.CHAT_RED .. "任务" .. FONT_COLOR_CODE_CLOSE .. "时的确认窗口将被" .. APR.Utilities.CHAT_RED .. "显示" .. FONT_COLOR_CODE_CLOSE .. "。"

-- undercut
L["undercut_name"] = "拍卖行压价提醒"
L["undercut_config"] = "在拍卖行出售物品时隐藏关于不再需要压价的提醒"
L["undercut_hidden"] = "在拍卖行出售物品时，关于无需进行" .. APR.Utilities.CHAT_GREEN .. "压价" .. FONT_COLOR_CODE_CLOSE .. "的提醒将被" .. APR.Utilities.CHAT_GREEN .. "隐藏" .. FONT_COLOR_CODE_CLOSE .. "。"
L["undercut_shown"] = "在拍卖行出售物品时，关于无需进行" .. APR.Utilities.CHAT_RED .. "压价" .. FONT_COLOR_CODE_CLOSE .. "的提醒将被" .. APR.Utilities.CHAT_RED .. "显示" .. FONT_COLOR_CODE_CLOSE .. "。"

-- dragonriding
L["dragonriding_name"] = "驭龙术天赋"
L["dragonriding_config"] = "选择驭龙术天赋时隐藏确认窗口"
L["dragonriding_hidden"] = "选择" .. APR.Utilities.CHAT_GREEN .. "驭龙术" .. FONT_COLOR_CODE_CLOSE .. "天赋时的确认窗口将被" .. APR.Utilities.CHAT_GREEN .. "隐藏" .. FONT_COLOR_CODE_CLOSE .. "。"
L["dragonriding_shown"] = "选择" .. APR.Utilities.CHAT_RED .. "驭龙术" .. FONT_COLOR_CODE_CLOSE .. "天赋时的确认窗口将被" .. APR.Utilities.CHAT_RED .. "显示" .. FONT_COLOR_CODE_CLOSE .. "。"

-- workorder
L["workorder_name"] = "需要自备材料的订单"
L["workorder_config"] = "完成需要消耗自身材料的订单时隐藏确认窗口"
L["workorder_hidden"] = "完成需要消耗自身材料的" .. APR.Utilities.CHAT_GREEN .. "订单" .. FONT_COLOR_CODE_CLOSE .. "时的确认窗口将被" .. APR.Utilities.CHAT_GREEN .. "隐藏" .. FONT_COLOR_CODE_CLOSE .. "。"
L["workorder_shown"] = "完成需要消耗自身材料的" .. APR.Utilities.CHAT_RED .. "订单" .. FONT_COLOR_CODE_CLOSE .. "时的确认窗口将被" .. APR.Utilities.CHAT_RED .. "显示" .. FONT_COLOR_CODE_CLOSE .. "。"

-- actioncam
L["actioncam_name"] = "使用动态镜头(ActionCam)"
L["actioncam_config"] = "使用动态镜头(ActionCam)时隐藏警告窗口"
L["actioncam_hidden"] = "使用" .. APR.Utilities.CHAT_GREEN .. "动态镜头(ActionCam)" .. FONT_COLOR_CODE_CLOSE .. "时的警告窗口将被" .. APR.Utilities.CHAT_GREEN .. "隐藏" .. FONT_COLOR_CODE_CLOSE .. "。"
L["actioncam_shown"] = "使用" .. APR.Utilities.CHAT_RED .. "动态镜头(ActionCam)" .. FONT_COLOR_CODE_CLOSE .. "时的警告窗口将被" .. APR.Utilities.CHAT_RED .. "显示" .. FONT_COLOR_CODE_CLOSE .. "。"

-- gossip
L["gossip_name"] = "与NPC对话"
L["gossip_config"] = "隐藏与某些NPC对话时的确认窗口"
L["gossip_hidden"] = "与某些NPC" .. APR.Utilities.CHAT_GREEN .. "对话" .. FONT_COLOR_CODE_CLOSE .. "时的确认窗口将被" .. APR.Utilities.CHAT_GREEN .. "隐藏" .. FONT_COLOR_CODE_CLOSE .. "。"
L["gossip_shown"] = "与某些NPC" .. APR.Utilities.CHAT_RED .. "对话" .. FONT_COLOR_CODE_CLOSE .. "时的确认窗口将被" .. APR.Utilities.CHAT_RED .. "显示" .. FONT_COLOR_CODE_CLOSE .. "。"

-- followers
L["followers_name"] = "为追随者装备或升级物品"
L["followers_config"] = "在各种指挥台为追随者装备或升级物品时隐藏确认窗口"
L["followers_hidden"] = "在各种指挥台为" .. APR.Utilities.CHAT_GREEN .. "追随者" .. FONT_COLOR_CODE_CLOSE .. "装备或升级物品时的确认窗口将被" .. APR.Utilities.CHAT_GREEN .. "隐藏" .. FONT_COLOR_CODE_CLOSE .. "。"
L["followers_shown"] = "在各种指挥台为" .. APR.Utilities.CHAT_RED .. "追随者" .. FONT_COLOR_CODE_CLOSE .. "装备或升级物品时的确认窗口将被" .. APR.Utilities.CHAT_RED .. "显示" .. FONT_COLOR_CODE_CLOSE .. "。"

-- 模块特定字符串
-- 这是用于使用字符串匹配的 gossip 模块
L["Darkmoon_travel"] = "Travel to the faire staging area will cost:" -- 此行（用于暗月马戏团）在暴雪的lua代码中未本地化。APR中实际未使用。
