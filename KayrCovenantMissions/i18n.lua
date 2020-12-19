-- ====================================================================================================================
-- =	KayrCovenantMissions - Simple covenent mission success estimates for World of Warcraft: Shadowlands
-- =	Copyright (c) Kvalyr - 2020-2021 - All Rights Reserved
-- ====================================================================================================================
local i18n = {}
local stringTable = {}
i18n.stringTable = stringTable
KayrCovenantMissions.i18n = i18n
KayrCovenantMissions.i18n.currentLocale = _G["GetLocale"]()
KayrCovenantMissions.i18n.useCaching = true
-- --------------------------------------------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------------------------------------------
-- Debugging
local KLib = _G["KLib"]
if not KLib then
    KLib = {Con = function() end} -- No-Op if KLib not available
end
-- KayrCovenantMissions.i18n.currentLocale = "koKR" -- DEBUG
-- --------------------------------------------------------------------------------------------------------------------

-- TODO: Use ALIASES instead of passing the enUS str through as stringTable key

function Trim(str)
    local from = str:match"^%s*()"
    return from > #str and "" or str:match(".*%S", from)
end

function i18n.DebugLocale(debugLocaleStr)
    i18n.currentLocale = debugLocaleStr
    i18n.useCaching = false
    KayrCovenantMissions:UpdateAdviceFrameSize()
end

-- --------------------------------------------------------------------------------------------------------------------
-- GetLocalization
-- --------------------------------------------------------
local memoizeResults = {}
function i18n.GetLocalization(str, locale)
    if not locale then locale = i18n.currentLocale end
    if locale == "enUS" then return str end

    local cachedResults = memoizeResults[locale]
    if i18n.useCaching and cachedResults and cachedResults[str] then return cachedResults[str] end

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
-- By JEUD @ Curse
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
-- By Aurantea@SteamwheedleCartelEU
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
-- By Kilberos @ Curse
stringTable["koKR"] = {}
stringTable["koKR"]["_adviceFrameWidth"] = 550
stringTable["koKR"]["_adviceFrameHeight"] = 100
stringTable["koKR"]["Add some units to your team to begin success estimation."] = "성공률 계산을 하기 위해 몇몇의 병력을 추가하세요."
stringTable["koKR"]["round"] = "판"
stringTable["koKR"]["rounds"] = "판들"
stringTable["koKR"]["It would take"] = "걸립니다"
stringTable["koKR"]["combat"] = "전투"
stringTable["koKR"]["for your current team to beat the enemy team."] = "당신의 팀이 적군의 팀을 이기기 위해"
stringTable["koKR"]["for the enemy team to beat your current team."] = "적군의 팀이 당신의 팀을 이기기 위해"
stringTable["koKR"]["Success is possible with your current units, but it will be close."] = "현재의 병력들로 성공이 가능하긴 하지만, 실패 할 수 도 있습니다."
stringTable["koKR"]["There is a reasonable chance of success with your current units."] = "현재의 병력으로 합리적인 임무성공을 할 수 있습니다."
stringTable["koKR"]["Mission success is impossible with your current units."] = "현재의 병력들로는 임무성공이 불가능 합니다."
stringTable["koKR"]["Warning: This guidance is a rough estimate. Unit abilities strongly influence the actual result."] = "경고: 이 수호자는 대략적인 평가입니다. 유닛의 기술이 중요하게 실제결과에 영향을 미칩니다."
stringTable["koKR"]["[No Mission Selected]"] = "[임무가 선택되지 않았습니다]"

-- Simplified Chinese
-- Translation by Azpilicuet@CN主宰之剑
stringTable["zhCN"] = {}
stringTable["zhCN"]["_adviceFrameWidth"] = 550
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
stringTable["zhTW"]["_adviceFrameWidth"] = 550
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
-- By Hubbotu @ Curse
stringTable["ruRU"] = {}
stringTable["ruRU"]["Add some units to your team to begin success estimation."] = "Добавьте несколько отрядов в свою команду, чтобы начать оценку успеха."
stringTable["ruRU"]["round"] = "раунд"
stringTable["ruRU"]["rounds"] = "раунды"
stringTable["ruRU"]["It would take"] = "Это займет"
stringTable["ruRU"]["combat"] = "бой"
stringTable["ruRU"]["for your current team to beat the enemy team."] = "чтобы ваша текущая команда победила команду противника."
stringTable["ruRU"]["for the enemy team to beat your current team."] = "чтобы вражеская команда победила вашу текущую команду."
stringTable["ruRU"]["Success is possible with your current units, but it will be close."] = "Успех возможен с вашими текущими отрядами, но он будет низкий."
stringTable["ruRU"]["There is a reasonable chance of success with your current units."] = "Есть разумный шанс на успех с вашими текущими отрядами."
stringTable["ruRU"]["Mission success is impossible with your current units."] = "Успех миссии невозможен с вашими текущими отрядами."
stringTable["ruRU"]["Warning: This guidance is a rough estimate. Unit abilities strongly influence the actual result."] = "Предупреждение: это приблизительная оценка. Способности соратника сильно влияют на фактический результат."
stringTable["ruRU"]["[No Mission Selected]"] = "[Миссия не выбрана]"

-- Spanish
-- By Araxieel @ Curse
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
-- By bakadeshisho @ Curse
stringTable["esMX"] = {}
stringTable["esMX"]["Add some units to your team to begin success estimation."] = "Envíe algunas unidades a su equipo para comenzar la estimación del éxito."
stringTable["esMX"]["round"] = "ronda"
stringTable["esMX"]["rounds"] = "rondas"
stringTable["esMX"]["It would take"] = "Se necesitan"
stringTable["esMX"]["combat"] = "combate"
stringTable["esMX"]["for your current team to beat the enemy team."] = "para que tu equipo actual derrote al equipo enemigo."
stringTable["esMX"]["for the enemy team to beat your current team."] = "para que el equipo enemigo derrote a tu equipo actual."
stringTable["esMX"]["Success is possible with your current units, but it will be close."] = "Su equipo actual puede ganar, pero por un pequeño margen."
stringTable["esMX"]["There is a reasonable chance of success with your current units."] = "Existe una posibilidad razonable de éxito con sus unidades actuales."
stringTable["esMX"]["Mission success is impossible with your current units."] = "El éxito de la misión es imposible con tus unidades actuales."
stringTable["esMX"]["Warning: This guidance is a rough estimate. Unit abilities strongly influence the actual result."] = "Advertencia: Esta orientación es una estimación aproximada. Las habilidades de las unidades influyen fuertemente en el resultado final."
stringTable["esMX"]["[No Mission Selected]"] = "[No se ha seleccionado ninguna misión]"

-- Portuguese (Brazil)
-- By Mufasto @ Curse
stringTable["ptBR"] = {}
stringTable["ptBR"]["Add some units to your team to begin success estimation."] = "Adicione algumas unidades na sua equipe para obter uma estimativa de sucesso."
stringTable["ptBR"]["round"] = "rodada"
stringTable["ptBR"]["rounds"] = "rodadas"
stringTable["ptBR"]["It would take"] = "Seria preciso"
stringTable["ptBR"]["combat"] = "combate"
stringTable["ptBR"]["for your current team to beat the enemy team."] = "para seu time atual vencer o time inimigo."
stringTable["ptBR"]["for the enemy team to beat your current team."] = "para o time inimigo vencer o seu time atual."
stringTable["ptBR"]["Success is possible with your current units, but it will be close."] = "O sucesso é possível com suas unidades atuais, mas estará próximo."
stringTable["ptBR"]["There is a reasonable chance of success with your current units."] = "Há uma chance razoável de sucesso com suas unidades atuais."
stringTable["ptBR"]["Mission success is impossible with your current units."] = "O sucesso da missão é impossível com suas unidades atuais."
stringTable["ptBR"]["Warning: This guidance is a rough estimate. Unit abilities strongly influence the actual result."] = "Aviso: Esta orientação é uma estimativa aproximada. As habilidades da unidade influenciam fortemente o resultado real."
stringTable["ptBR"]["[No Mission Selected]"] = "[Nenhuma missão selecionada]"