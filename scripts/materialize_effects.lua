
local function touchAttackRoll()
    local rRoll = {}
    rRoll.sDesc = "[TOUCH]"
    rRoll.sType = "attack"
    return rRoll
end

local function flatfootedAttackRoll()
    local rRoll = {}
    rRoll.sDesc = "[FF]"
    rRoll.sType = "attack"
    return rRoll
end

local function processAC(sCommand, sParams)
    Debug.chat("processAC")
    Debug.chat(User.getCurrentIdentity())

    local rSource = nil
    -- local rTarget = "charsheet." .. User.getCurrentIdentity()
    local rTarget = "charsheet.id-00001"
    local rRoll = flatfootedAttackRoll()

    local nDefenseVal, nAtkEffectsBonus, nDefEffectsBonus, nMissChance = ActorManager35E.getDefenseValue(rSource, rTarget, rRoll)
    Debug.chat(nDefenseVal, nAtkEffectsBonus, nDefEffectsBonus, nMissChance)
end

function onInit()
    Comm.registerSlashHandler("ac", processAC)
end
