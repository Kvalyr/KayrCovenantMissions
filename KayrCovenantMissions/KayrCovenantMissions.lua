-- ====================================================================================================================
-- =	KayrCovenantMissions - Simple covenent mission success estimates for World of Warcraft: Shadowlands
-- =	Copyright (c) Kvalyr - 2020-2021 - All Rights Reserved
-- ====================================================================================================================
local max = _G["max"]
local gsub = _G["gsub"]
local hooksecurefunc = _G["hooksecurefunc"]
local CreateFrame = _G["CreateFrame"]
-- local IsAddOnLoaded = _G["IsAddOnLoaded"]
-- local UIParentLoadAddOn = _G["UIParentLoadAddOn"]

-- Debugging
local KLib = _G["KLib"]
if not KLib then
    KLib = {Con = function() end} -- No-Op if KLib not available
end


-- --------------------------------------------------------------------------------------------------------------------
-- Addon class
-- --------------------------------------------------------
KayrCovenantMissions = CreateFrame("Frame", "KayrCovenantMissions", UIParent)
KayrCovenantMissions.initDone = false
KayrCovenantMissions.showMissionHookDone = false


-- --------------------------------------------------------------------------------------------------------------------
-- Helpers
-- --------------------------------------------------------
local function CleanNumber(str)
    if not str then return end
    return gsub(str, "%p", "") -- Remove commas, points, etc.
end

local function RoundNumber(num, places)
    if not num then return end
    local mult = 10^(places or 0)
    return math.floor(num * mult + 0.5) / mult
end


-- --------------------------------------------------------------------------------------------------------------------
-- Text Color Helpers
-- --------------------------------------------------------
local goodTextColor = "FF00FF88"
local middlingTextColor = "FFFF8800"
local badTextColor = "FFFF0000"
local warningTextColor = "FFFFFF00"
local colorClose = "|r"

function ColorText(text, colorStr)
    return "|c" .. colorStr .. text .. colorClose
end
KayrCovenantMissions.ColorText = ColorText

local function goodText(text) return ColorText(text, goodTextColor) end
local function midText(text) return ColorText(text, middlingTextColor) end
local function badText(text) return ColorText(text, badTextColor) end
local function warnText(text) return ColorText(text, warningTextColor) end


-- --------------------------------------------------------------------------------------------------------------------
-- GetNumMissionPlayerUnitsTotal
-- --------------------------------------------------------
function KayrCovenantMissions:GetNumMissionPlayerUnitsTotal()
    local numFollowers = 0
    local missionPage = _G["CovenantMissionFrame"]:GetMissionPage()
    for followerFrame in missionPage.Board:EnumerateFollowers() do
        if followerFrame:GetFollowerGUID() then
            numFollowers = numFollowers + 1
        end
    end
    return numFollowers
end


-- --------------------------------------------------------------------------------------------------------------------
-- Main Hook for success calculation
-- --------------------------------------------------------
function KayrCovenantMissions.CMFrame_ShowMission_Hook(...)
    local _i = KayrCovenantMissions.i18n
    local numPlayerUnits = KayrCovenantMissions:GetNumMissionPlayerUnitsTotal()
    if numPlayerUnits < 1 then
        KayrCovenantMissions:UpdateAdviceText(_i("Add some units to your team to begin success estimation."))
        return
    end

    -- KLib:Con("KayrCovenantMissions.CMFrame_ShowMission_Hook")
    local missionPage = _G["CovenantMissionFrame"]:GetMissionPage()

    local allyHealthValue = missionPage.Board.AllyHealthValue:GetText()
    allyHealthValue = CleanNumber(allyHealthValue)

    local allyPowerValue = missionPage.Board.AllyPowerValue:GetText()
    allyPowerValue = CleanNumber(allyPowerValue)

    local enemyHealthValue = missionPage.Stage.EnemyHealthValue:GetText()
    enemyHealthValue = CleanNumber(enemyHealthValue)

    local enemyPowerValue = missionPage.Stage.EnemyPowerValue:GetText()
    enemyPowerValue = CleanNumber(enemyPowerValue)

    -- Don't / 0
    allyHealthValue = max(1, allyHealthValue)
    allyPowerValue = max(1, allyPowerValue)
    enemyHealthValue = max(1, enemyHealthValue)
    enemyPowerValue = max(1, enemyPowerValue)

    local roundsToBeatEnemy = RoundNumber(enemyHealthValue / allyPowerValue)
    if (enemyHealthValue % allyPowerValue) > 0 then roundsToBeatEnemy = roundsToBeatEnemy + 1 end

    local roundsBeforeBeaten = RoundNumber(allyHealthValue / enemyPowerValue)
    if (allyHealthValue % enemyPowerValue) > 0 then roundsBeforeBeaten = roundsBeforeBeaten + 1 end

    local successPossible = roundsToBeatEnemy < roundsBeforeBeaten

    -- KLib:Con(
    --     "KayrCovenantMissions.CMFrame_ShowMissionHook Values:",
    --     allyHealthValue, allyPowerValue, enemyHealthValue, enemyPowerValue
    -- )
    -- KLib:Con(
    --     "KayrCovenantMissions.CMFrame_ShowMissionHook Rounds:",
    --     roundsToBeatEnemy, roundsBeforeBeaten, successPossible
    -- )

    local adviceText = KayrCovenantMissions:ConstructAdviceText(roundsToBeatEnemy, roundsBeforeBeaten, successPossible)
    KayrCovenantMissions:UpdateAdviceText(adviceText)
    return ...
end


local function roundOrRounds(numRounds)
    if numRounds == 1 then
        return KayrCovenantMissions.i18n("round")
    end
    return KayrCovenantMissions.i18n("rounds")
end

-- --------------------------------------------------------------------------------------------------------------------
-- ConstructAdviceText
-- --------------------------------------------------------
function KayrCovenantMissions:ConstructAdviceText(roundsToBeatEnemy, roundsBeforeBeaten, successPossible)
    local _i = self.i18n
    local closeResult = (roundsBeforeBeaten - roundsToBeatEnemy) <= 3
    local numTextColor = badTextColor
    if successPossible then
        numTextColor = goodTextColor
        if closeResult then
            numTextColor = middlingTextColor
        end
    end
    local roundsToBeatEnemyStr = ColorText(roundsToBeatEnemy, numTextColor)
    local roundsBeforeBeatenStr = ColorText(roundsBeforeBeaten, numTextColor)

    local beatEnemytext = _i("It would take ") .. roundsToBeatEnemyStr .. _i(" combat ") .. roundOrRounds(roundsToBeatEnemy) .. _i(" for your current team to beat the enemy team.")
    local beatenByEnemytext = _i("It would take ") .. roundsBeforeBeatenStr .. _i(" combat ") .. roundOrRounds(roundsBeforeBeaten) .. _i(" for the enemy team to beat your current team.")

    if _i.currentLocale == "koKR" then
        -- TODO: This is hacky. Implement better strings with string.format, more suited to i18n.
        -- Korean is surely not the only language with different sentence structure.
        -- Korean structure: "for [y] team to beat [z] team [x] round(s) It would take."
        beatEnemytext = _i(" for your current team to beat the enemy team.") .. " " .. roundsToBeatEnemyStr .. " " .. roundOrRounds(roundsToBeatEnemy) .. " " .. _i("It would take ")
        beatenByEnemytext = _i(" for the enemy team to beat your current team.") .. " " .. roundsBeforeBeatenStr .. " " .. roundOrRounds(roundsBeforeBeaten) .. " " .. _i("It would take ")
    end

    local str = beatEnemytext .. "\n" .. beatenByEnemytext .. "\n"
    if successPossible then
        if closeResult then
            str = str .. midText(_i("\nSuccess is possible with your current units, but it will be close.\n"))
        else
            str = str .. goodText(_i("\nThere is a reasonable chance of success with your current units.\n"))

        end
    else
        str = str .. badText(_i("\nMission success is impossible with your current units.\n"))
    end

    str = str .. warnText(_i("Warning: This guidance is a rough estimate. Unit abilities strongly influence the actual result."))
    return str
end


-- --------------------------------------------------------------------------------------------------------------------
-- UpdateAdviceText
-- --------------------------------------------------------
function KayrCovenantMissions:UpdateAdviceText(newText)
    local adviceFrame = self.adviceFrame
    adviceFrame.text:SetText(newText)
    adviceFrame:Show()
end


-- --------------------------------------------------------------------------------------------------------------------
-- Close Mission Hook
-- --------------------------------------------------------
function KayrCovenantMissions.CMFrame_CloseMission_Hook(...)
    KayrCovenantMissions.adviceFrame:Hide()
    return ...
end

-- --------------------------------------------------------------------------------------------------------------------
-- UpdateAdviceFrameSize
-- --------------------------------------------------------
function KayrCovenantMissions:UpdateAdviceFrameSize(width, height)
    local _i = KayrCovenantMissions.i18n
    local frameWidth = width or 600
    local frameHeight = height or 90
    if _i.currentLocale ~= "enUS" then
        -- Extra size for the frame to prevent string truncation risk when i18n applied
        local localeTable = _i.stringTable[_i.currentLocale] or {}
        frameWidth = localeTable["_adviceFrameWidth"] or 700
        frameHeight = localeTable["_adviceFrameHeight"] or 100
    end
    self.adviceFrame:SetSize(frameWidth, frameHeight)
end

-- --------------------------------------------------------------------------------------------------------------------
-- Init Hook - Fired when the covenant mission table is first accessed
-- --------------------------------------------------------
function KayrCovenantMissions.CMFrame_SetupTabs_Hook(...)
    local _i = KayrCovenantMissions.i18n
    KLib:Con("KayrCovenantMissions.CMFrame_SetupTabs_Hook")
    if KayrCovenantMissions.showMissionHookDone then return end

    hooksecurefunc(_G["CovenantMissionFrame"], "ShowMission", KayrCovenantMissions.CMFrame_ShowMission_Hook)
    hooksecurefunc(_G["CovenantMissionFrame"], "UpdateAllyPower", KayrCovenantMissions.CMFrame_ShowMission_Hook)
    hooksecurefunc(_G["CovenantMissionFrame"], "UpdateEnemyPower", KayrCovenantMissions.CMFrame_ShowMission_Hook)

    hooksecurefunc(_G["CovenantMissionFrame"], "CloseMission", KayrCovenantMissions.CMFrame_CloseMission_Hook)

    local adviceFrame = CreateFrame("Frame", "KayrCovenantMissionsAdvice", _G["CovenantMissionFrame"], "TranslucentFrameTemplate")
    adviceFrame:SetPoint("TOPRIGHT", CovenantMissionFrame, "BOTTOMRIGHT")
    adviceFrame:SetClampedToScreen(true)  -- To keep it on-screen when user has a tiny display resolution
    adviceFrame:SetFrameStrata("TOOLTIP")
    adviceFrame:Hide()
    KayrCovenantMissions.adviceFrame = adviceFrame
    KayrCovenantMissions:UpdateAdviceFrameSize()

    local adviceFrameText = adviceFrame:CreateFontString(adviceFrame, "OVERLAY", "GameTooltipText")
    adviceFrame.text = adviceFrameText
    adviceFrameText:SetPoint("CENTER", 0, 0)
    adviceFrameText:SetPoint("TOPLEFT", adviceFrame, "TOPLEFT", 14, -14)
    adviceFrameText:SetPoint("BOTTOMRIGHT", adviceFrame, "BOTTOMRIGHT", -14, 14)
    adviceFrameText:SetText(_i("[No Mission Selected]"))

    KayrCovenantMissions.showMissionHookDone = true
    return ...
end

-- --------------------------------------------------------------------------------------------------------------------
-- Listen for Blizz Garrison UI being loaded
-- --------------------------------------------------------
function KayrCovenantMissions:ADDON_LOADED(event, addon)
    if addon == "Blizzard_GarrisonUI" then
        KayrCovenantMissions:Init()
    end
end

-- --------------------------------------------------------------------------------------------------------------------
-- Init
-- --------------------------------------------------------
function KayrCovenantMissions:Init()
    KLib:Con("KayrCovenantMissions.Init")
    if self.initDone then return end
    hooksecurefunc(_G["CovenantMissionFrame"], "SetupTabs", self.CMFrame_SetupTabs_Hook)
    self.initDone = true
end

KayrCovenantMissions:RegisterEvent("ADDON_LOADED")
KayrCovenantMissions:SetScript("OnEvent", KayrCovenantMissions.ADDON_LOADED)
