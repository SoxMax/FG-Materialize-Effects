
local function getNormalAc(charNode)
    local rRoll = { sDesc = "", sType = "attack" }
    local nDefenseVal, nAtkEffectsBonus, nDefEffectsBonus, nMissChance = ActorManager35E.getDefenseValue(nil, charNode, rRoll)
    return nDefenseVal + nDefEffectsBonus
end

local function getTouchAc(charNode)
    local rRoll = { sDesc = "[TOUCH]", sType = "attack" }
    local nDefenseVal, nAtkEffectsBonus, nDefEffectsBonus, nMissChance = ActorManager35E.getDefenseValue(nil, charNode, rRoll)
    return nDefenseVal + nDefEffectsBonus
end

local function getFlatfootedAc(charNode)
    local rRoll = { sDesc = "[FF]", sType = "attack" }
    local nDefenseVal, nAtkEffectsBonus, nDefEffectsBonus, nMissChance = ActorManager35E.getDefenseValue(nil, charNode, rRoll)
    return nDefenseVal + nDefEffectsBonus
end

local function getAbilityScoreBonus(charNode, sAbilityScore)
    local abilityScoreBonus = ActorManager35E.getAbilityBonus(charNode, sAbilityScore) + ActorManager35E.getAbilityEffectsBonus(charNode, sAbilityScore)
    if abilityScoreBonus >= 0 then
        return "+" .. abilityScoreBonus
    else
        return "" .. abilityScoreBonus
    end
end

local function getCharacterNodeByName(sName)
    for _, character in pairs(DB.getChildren("charsheet")) do
        if DB.getValue(character, "name", "") == sName then
            return character
        end
    end
end

local function getCharacterNode(charName)
    local rTarget = nil
    if Session.IsHost then
        rTarget = getCharacterNodeByName(charName)
    else
        rTarget = DB.getChild("charsheet", User.getCurrentIdentity())
    end
    return rTarget
end

local function getAcString(rTarget)
    return "Normal AC:     " .. getNormalAc(rTarget) .. "\r" ..
           "Flat-footed AC:" .. getFlatfootedAc(rTarget) .. "\r" ..
           "Touch AC:      " .. getTouchAc(rTarget)
end

local function getAbilityScoresString(rTarget)
    return "Strength:     " .. getAbilityScoreBonus(rTarget, "strength") .. "\r" ..
           "Dexterity:    " .. getAbilityScoreBonus(rTarget, "dexterity") .. "\r" ..
           "Constitution: " .. getAbilityScoreBonus(rTarget, "constitution") .. "\r" ..
           "Intelligence: " .. getAbilityScoreBonus(rTarget, "intelligence") .. "\r" ..
           "Wisdom:       " .. getAbilityScoreBonus(rTarget, "wisdom") .. "\r" ..
           "Charisma:     " .. getAbilityScoreBonus(rTarget, "charisma")
end

local function processStats(sCommand, sParams)
    local rTarget = getCharacterNode(sParams)

    if rTarget then
        local statsString = ""
        if sCommand == "ac" then
            statsString = getAcString(rTarget)
        elseif sCommand == "abilityscores" then
            statsString = getAbilityScoresString(rTarget)
        elseif sCommand == "materializestats" then
            statsString = getAbilityScoresString(rTarget) .. "\r" .. getAcString(rTarget)
        end

        Comm.addChatMessage({
            font = "systemfont",
            icon = DB.getValue(rTarget, "token", ""),
            secret = false,
            text = DB.getValue(rTarget, "name", "") .. "\r" .. statsString
        })
    end
end

function onInit()
    Comm.registerSlashHandler("ac", processStats)
    Comm.registerSlashHandler("abilityscores", processStats)
    Comm.registerSlashHandler("materializestats", processStats)
end
