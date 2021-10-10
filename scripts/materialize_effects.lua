
local function getNormalAc(sCharNode)
    local rRoll = { sDesc = "", sType = "attack" }
    local nDefenseVal, nAtkEffectsBonus, nDefEffectsBonus, nMissChance = ActorManager35E.getDefenseValue(nil, sCharNode, rRoll)
    return nDefenseVal + nDefEffectsBonus
end

local function getTouchAc(sCharNode)
    local rRoll = { sDesc = "[TOUCH]", sType = "attack" }
    local nDefenseVal, nAtkEffectsBonus, nDefEffectsBonus, nMissChance = ActorManager35E.getDefenseValue(nil, sCharNode, rRoll)
    return nDefenseVal + nDefEffectsBonus
end

local function getFlatfootedAc(sCharNode)
    local rRoll = { sDesc = "[FF]", sType = "attack" }
    local nDefenseVal, nAtkEffectsBonus, nDefEffectsBonus, nMissChance = ActorManager35E.getDefenseValue(nil, sCharNode, rRoll)
    return nDefenseVal + nDefEffectsBonus
end

local function getCharacterNodeByName(sName)
    for _, character in pairs(DB.getChildren("charsheet")) do
        if DB.getValue(character, "name", "") == sName then
            return character
        end
    end
end

local function processAC(sCommand, sParams)
    local rTarget = nil
    if Session.IsHost then
        rTarget = getCharacterNodeByName(sParams)
    else
        rTarget = DB.getChild("charsheet", User.getCurrentIdentity())
    end

    if rTarget then
        local msg = {
            font = "systemfont",
            icon = DB.getValue(rTarget, "token", ""),
            secret = false,
            text = DB.getValue(rTarget, "name", "") .. "\n" ..
            "Normal AC:     " .. getNormalAc(rTarget) .. "\n" ..
            "Flat-footed AC:" .. getFlatfootedAc(rTarget) .. "\n" ..
            "Touch AC:      " .. getTouchAc(rTarget)
        }
        
        Comm.addChatMessage(msg)
    end
end

function onInit()
    Comm.registerSlashHandler("ac", processAC)
end
