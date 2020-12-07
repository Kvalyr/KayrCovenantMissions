local _,tbl = ...
local L = tbl.Locales
if GetLocale() ~= "zhCN" then return end
--[[
    translate by Azpilicuet@CN主宰之剑
    modify by HopeAsd
]]

L["Add some units to your team to begin success estimation."] = "请将一些随从加入到你的队伍中以开始成功估算."
L["Rounds"] = "回合"
L["Round"] = "回合"
L["TeamRound"] = "你当前的队伍需要%s%s后击败敌方队伍.\n"
L["EnemyRound"] = "敌方队伍需要%s%s后击败你当前的队伍.\n"
L["MissionMid"] = "\n你当前的队伍可能会取胜,但双方实力很接近.\n"
L["MissionGood"] = "\n你当前的队伍根据战斗评估应该能获得胜利.\n"
L["MissionBad"] = "\n你当前的队伍不可能获得胜利.\n"
L["GuidanceWarning"] = "警告:本指南只是粗略估计战斗胜率,随从技能对实际战斗结果影响很大."
L["NoMissionSelected"] = "[没有选择任务]"