-- ====================================================================================================================
-- =	KayrCovenantMissions - Simple covenent mission success estimates for World of Warcraft: Shadowlands
-- =	Copyright (c) Kvalyr - 2020-2021 - All Rights Reserved
-- ====================================================================================================================
local i18n = {}
local stringTable = {}
i18n.stringTable = stringTable
KayrCovenantMissions.i18n = i18n
KayrCovenantMissions.i18n.currentLocale = _G["GetLocale"]()
-- --------------------------------------------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------------------------------------------
-- Debugging
local KLib = _G["KLib"]
if not KLib then
    KLib = {Con = function() end} -- No-Op if KLib not available
end
-- KayrCovenantMissions.i18n.currentLocale = "frFR" -- DEBUG
-- --------------------------------------------------------------------------------------------------------------------

-- TODO: Use ALIASES instead of passing the enUS str through as stringTable key

function Trim(str)
    local from = str:match"^%s*()"
    return from > #str and "" or str:match(".*%S", from)
end

-- --------------------------------------------------------------------------------------------------------------------
-- GetLocalization
-- --------------------------------------------------------
local memoizeResults = {}
function i18n.GetLocalization(str, locale)
    if not locale then locale = i18n.currentLocale end
    if locale == "enUS" then return str end

    local cachedResults = memoizeResults[locale]
    if cachedResults and cachedResults[str] then return cachedResults[str] end

    local whitespaceStart, cleanedStr, whitespaceEnd = string.match(str, "^(%s*)(.-)(%s*)$")

    -- KLib:Con("whitespaceStart:", "'"..whitespaceStart.."'")
    -- KLib:Con("cleanedStr:", "'"..cleanedStr.."'")
    -- KLib:Con("whitespaceEnd:", "'"..whitespaceEnd.."'")
    -- cleanedStr = Trim(cleanedStr) -- Just in case

    local i18nTable = i18n.stringTable[locale] or i18n.stringTable["enUS"]
    local result = i18nTable[cleanedStr] or i18n.stringTable["enUS"][cleanedStr] or cleanedStr
    if result and result ~= "" then
        result = (whitespaceStart or "") .. result .. (whitespaceEnd or "")
    end

    if not memoizeResults[locale] then memoizeResults[locale] = {} end
    memoizeResults[locale][str] = result
    return result
end

-- --------------------------------------------------------------------------------------------------------------------
-- Access the i18n func by calling the table itself for convenience
local mt = {}
function mt.__call(...)
    local str = select(2, ...)
    local locale = select(3, ...)
    return i18n.GetLocalization(str, locale)
end
setmetatable(i18n, mt)

-- --------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------------

-- French
stringTable["frFR"] = {}
stringTable["frFR"]["_adviceFrameWidth"] = 700
stringTable["frFR"]["_adviceFrameHeight"] = 90
stringTable["frFR"]["Add some units to your team to begin success estimation."] = "Ajoutez des troupes à votre équipe pour commencer l'estimation."
stringTable["frFR"]["round"] = " tour"
stringTable["frFR"]["rounds"] = " tours"
stringTable["frFR"]["It would take"] = "Il faudrait"
stringTable["frFR"]["combat"] = ""
stringTable["frFR"]["for your current team to beat the enemy team."] = "à votre équipe actuelle pour battre l'équipe adverse."
stringTable["frFR"]["for the enemy team to beat your current team."] = "à l'équipe adverse pour battre votre équipe actuelle."
stringTable["frFR"]["Success is possible with your current units, but it will be close."] = "Votre équipe actuelle peut gagner, mais de peu."
stringTable["frFR"]["There is a reasonable chance of success with your current units."] = "Il existe une chance raisonnable de victoire pour votre équipe actuelle."
stringTable["frFR"]["Mission success is impossible with your current units."] = "Vous ne gagnerez pas avec la composition actuelle."
stringTable["frFR"]["Warning: This guidance is a rough estimate. Unit abilities strongly influence the actual result."] = "Attention: Ceci est donné à titre indicatif. Les capacités adverses peuvent fortement influencer le résultat final."
stringTable["frFR"]["[No Mission Selected]"] = "[Pas d'aventure sélectionnée]"

-- German
stringTable["deDE"] = {}
stringTable["deDE"]["_adviceFrameWidth"] = 600
stringTable["deDE"]["_adviceFrameHeight"] = 100
stringTable["deDE"]["Add some units to your team to begin success estimation."] = "Fügt Einheiten der Mission hinzu um die Erfolgschancenberechnung zu beginnen."
stringTable["deDE"]["round"] = " Runde"
stringTable["deDE"]["rounds"] = " Runden"
stringTable["deDE"]["It would take"] = "Es benötigt"
stringTable["deDE"]["combat"] = ""--Gefecht
stringTable["deDE"]["for your current team to beat the enemy team."] = "bis Euer aktuelles Team den Gegner besiegt."
stringTable["deDE"]["for the enemy team to beat your current team."] = "bis der Gegner Euer aktuelles Team besiegt."
stringTable["deDE"]["Success is possible with your current units, but it will be close."] = "Eure aktuellen Einheiten können das Gefecht gewinnen, aber es wird sehr knapp."
stringTable["deDE"]["There is a reasonable chance of success with your current units."] = "Eure aktuellen Einheiten haben eine gute Chance das Gefecht zu gewinnen."
stringTable["deDE"]["Mission success is impossible with your current units."] = "Eure aktuellen Einheiten haben keine Chance das Gefecht zu gewinnen."
stringTable["deDE"]["Warning: This guidance is a rough estimate. Unit abilities strongly influence the actual result."] = "Achtung: Diese Richtlinien sind nur eine ungefähre Einschätzung.\nFähigkeiten individueller Einheiten können das Ergebnis stark beeinflussen."
stringTable["deDE"]["[No Mission Selected]"] = "[Keine Mission ausgewählt]"

-- English
stringTable["enUS"] = {}
stringTable["enGB"] = stringTable["enUS"]
-- stringTable["enUS"]["combat"] = "wombat" -- DEBUG

-- Italian
-- stringTable["itIT"] = {}

-- Korean (RTL)
-- stringTable["koKR"] = {}

-- Simplified Chinese
-- Translation by Azpilicuet@CN主宰之剑
stringTable["zhCN"] = {}
stringTable["zhCN"]["_adviceFrameWidth"] = 500
stringTable["zhCN"]["_adviceFrameHeight"] = 100
stringTable["zhCN"]["Add some units to your team to begin success estimation."] = "将一些随从加入到你的队伍中以开始成功估算。"
stringTable["zhCN"]["round"] = "回合"
stringTable["zhCN"]["rounds"] = "回合"
stringTable["zhCN"]["It would take"] = "这大概需要"
stringTable["zhCN"]["combat"] = "个战斗"
stringTable["zhCN"]["for your current team to beat the enemy team."] = "让你当前的队伍击败敌方队伍。"
stringTable["zhCN"]["for the enemy team to beat your current team."] = "让敌方队伍击败你当前的队伍。"
stringTable["zhCN"]["Success is possible with your current units, but it will be close."] = "你当前的队伍有可能取得成功，但是双方实力很接近。"
stringTable["zhCN"]["There is a reasonable chance of success with your current units."] = "你当前的队伍有合理的成功机会。"
stringTable["zhCN"]["Mission success is impossible with your current units."] = "你当前的队伍不可能成功完成任务。"
stringTable["zhCN"]["Warning: This guidance is a rough estimate. Unit abilities strongly influence the actual result."] = "警告：本指南只是粗略估计。随从技能对实际效果影响很大。"
stringTable["zhCN"]["[No Mission Selected]"] = "[没有选择任务]"


-- Traditional Chinese
-- Translation by BNS (三皈依 - 暗影之月)@miliui
-- Arranged by Azpilicuet@CN主宰之剑
stringTable["zhTW"] = {}
stringTable["zhTW"]["_adviceFrameWidth"] = 500
stringTable["zhTW"]["_adviceFrameHeight"] = 100
stringTable["zhTW"]["Add some units to your team to begin success estimation."] = "將一些單位加入到您的隊伍以開始成功估算。"
stringTable["zhTW"]["round"] = "回合"
stringTable["zhTW"]["rounds"] = "回合"
stringTable["zhTW"]["It would take"] = "這大概需要"
stringTable["zhTW"]["combat"] = "個戰鬥"
stringTable["zhTW"]["for your current team to beat the enemy team."] = "讓您當前的隊伍擊敗敵方的隊伍。"
stringTable["zhTW"]["for the enemy team to beat your current team."] = "讓敵方隊伍擊敗您當前的隊伍。"
stringTable["zhTW"]["Success is possible with your current units, but it will be close."] = "您當前的單位有可能取得成功，但是雙方實力很接近。"
stringTable["zhTW"]["There is a reasonable chance of success with your current units."] = "您當前的單位有合理的成功機會。"
stringTable["zhTW"]["Mission success is impossible with your current units."] = "您當前的單位不可能成功完成任務。"
stringTable["zhTW"]["Warning: This guidance is a rough estimate. Unit abilities strongly influence the actual result."] = "警告: 該指導是一個粗略的估計。 單位技能強烈影響實際結果。"
stringTable["zhTW"]["[No Mission Selected]"] = "[沒有選擇的任務]"

-- Russian
stringTable["ruRU"] = {}

-- Spanish
stringTable["esES"] = {}
stringTable["esES"]["Add some units to your team to begin success estimation."] = "Añade tropas a tu equipo para empezar la estimación."
stringTable["esES"]["round"] = "ronda"
stringTable["esES"]["rounds"] = "rondas"
stringTable["esES"]["It would take"] = "Se necesita(n)"
stringTable["esES"]["combat"] = "combate"
stringTable["esES"]["for your current team to beat the enemy team."] = "para que tu equipo actual venza al equipo enemigo."
stringTable["esES"]["for the enemy team to beat your current team."] = "para que el equipo enemigo venza a tu equipo actual."
stringTable["esES"]["Success is possible with your current units, but it will be close."] = "Su equipo actual puede ganar, pero por un pequeño margen."
stringTable["esES"]["There is a reasonable chance of success with your current units."] = "Hay una posibilidad razonable de éxito con sus unidades actuales."
stringTable["esES"]["Mission success is impossible with your current units."] = "El éxito de la misión es imposible con sus unidades actuales."
stringTable["esES"]["Warning: This guidance is a rough estimate. Unit abilities strongly influence the actual result."] = "Advertencia: Esta orientación es una estimación aproximada. Las habilidades de las unidades influyen fuertemente en el resultado real."
stringTable["esES"]["[No Mission Selected]"] = "[No se ha seleccionado ninguna misión]"

-- Spanish (Mexico)
-- stringTable["esMX"] = {}

-- Portuguese (Brazil)
-- stringTable["ptBR"] = {}
