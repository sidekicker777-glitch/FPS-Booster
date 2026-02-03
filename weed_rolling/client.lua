local isRolling = false
local lastRollAt = 0

local function debugLog(message)
    if Config.Debug then
        print(('[weed_rolling] %s'):format(message))
    end
end

local function notify(message)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(message)
    DrawNotification(false, true)
end

local function playAnim(anim)
    RequestAnimDict(anim.dict)
    while not HasAnimDictLoaded(anim.dict) do
        Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), anim.dict, anim.name, 2.0, 2.0, -1, 49, 0.0, false, false, false)
end

local function stopAnim(anim)
    StopAnimTask(PlayerPedId(), anim.dict, anim.name, 1.0)
end

local function distanceToStation(station)
    local coords = GetEntityCoords(PlayerPedId())
    return #(coords - station.coords)
end

local function isNearStation()
    for _, station in ipairs(Config.RollStations) do
        if distanceToStation(station) <= station.radius then
            return true
        end
    end
    return false
end

local function enforceCooldown()
    local now = GetGameTimer()
    if (now - lastRollAt) < (Config.CooldownSeconds * 1000) then
        return false
    end
    return true
end

local function runStage(label, anim, duration)
    debugLog(('Stage %s started'):format(label))
    playAnim(anim)
    local finished = exports['progressBars'] and exports['progressBars']:startUI(duration, label)
    if not finished then
        Wait(duration)
    end
    stopAnim(anim)
    debugLog(('Stage %s finished'):format(label))
end

local function rollWeed()
    if isRolling then
        notify(Config.Strings.Busy)
        return
    end

    if not enforceCooldown() then
        notify(Config.Strings.Cooldown)
        return
    end

    if Config.Rolling.RequireStations and not isNearStation() then
        notify(Config.Strings.TooFar)
        return
    end

    isRolling = true

    TriggerServerEvent('weed_rolling:checkSupplies')
end

RegisterNetEvent('weed_rolling:startRolling', function(skillLevel)
    if not isRolling then
        return
    end

    if Config.Rolling.AllowPocket and not Config.Rolling.RequireStations then
        notify(Config.Strings.PocketStart)
    else
        notify(Config.Strings.StartRoll)
    end

    runStage('Setting up tray', Config.Animations.Prep, Config.Timers.PrepTable)
    runStage('Grinding bud', Config.Animations.Grind, Config.Timers.Grind)
    runStage('Weighing dose', Config.Animations.Weigh, Config.Timers.Weigh)
    runStage('Packing cone', Config.Animations.Pack, Config.Timers.Pack)
    runStage('Sealing joint', Config.Animations.Seal, Config.Timers.Seal)
    runStage('Finishing touches', Config.Animations.Finish, Config.Timers.Finish)

    TriggerServerEvent('weed_rolling:finishRolling', skillLevel)
end)

RegisterNetEvent('weed_rolling:rollResult', function(result)
    isRolling = false
    lastRollAt = GetGameTimer()

    if result.failed then
        notify(Config.Strings.RollFailed)
        return
    end

    if result.perfect then
        notify(Config.Strings.RollPerfect)
    else
        notify(Config.Strings.RollSuccess:format(result.quality))
    end
end)

RegisterNetEvent('weed_rolling:rollDenied', function()
    isRolling = false
    notify(Config.Strings.NotEnough)
end)

RegisterCommand('rollweed', function()
    rollWeed()
end, false)

RegisterKeyMapping('rollweed', 'Roll a weed joint', 'keyboard', 'J')
