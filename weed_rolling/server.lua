local playerSkills = {}
local ESX = nil
local detectedBunnyPacks = false

local function detectInventoryType()
    if Config.Inventory.Type ~= 'auto' then
        return Config.Inventory.Type
    end

    if GetResourceState('ox_inventory') == 'started' then
        return 'ox'
    end

    if GetResourceState('es_extended') == 'started' then
        return 'esx'
    end

    return 'custom'
end

local function getESX()
    if ESX then
        return ESX
    end

    if exports['es_extended'] and exports['es_extended'].getSharedObject then
        ESX = exports['es_extended']:getSharedObject()
    else
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
    end

    return ESX
end

local function debugLog(message)
    if Config.Debug then
        print(('[weed_rolling] %s'):format(message))
    end
end

local function normalizePackName(itemName)
    if not itemName then
        return nil
    end
    if string.find(itemName, Config.Bunny.PackToken, 1, true) then
        return itemName
    end
    return nil
end

local function readResourceFile(resourceName, filePath)
    local content = LoadResourceFile(resourceName, filePath)
    if not content then
        return nil
    end
    return content
end

local function extractPackNames(content)
    local packs = {}
    for name in string.gmatch(content, "name%s*=%s*['\"]([^'\"]+)['\"]") do
        local normalized = normalizePackName(name)
        if normalized then
            packs[normalized] = true
        end
    end
    return packs
end

local function populateBunnyPacksFromResource(resourceName)
    local files = Config.Bunny.ResourceFiles or {}
    local found = {}

    for _, path in ipairs(files) do
        local content = readResourceFile(resourceName, path)
        if content then
            local packs = extractPackNames(content)
            for packName in pairs(packs) do
                found[packName] = true
            end
        end
    end

    return found
end

local function mergePackList(sourceTable)
    if not sourceTable then
        return
    end

    local existing = {}
    for _, name in ipairs(Config.Bunny.WeedPacks) do
        existing[name] = true
    end

    for packName in pairs(sourceTable) do
        if not existing[packName] then
            table.insert(Config.Bunny.WeedPacks, packName)
            existing[packName] = true
        end
    end
end

local function autoPopulateBunnyPacks()
    if detectedBunnyPacks then
        return
    end

    detectedBunnyPacks = true

    if not Config.Bunny or not Config.Bunny.AutoPopulate then
        return
    end

    if #Config.Bunny.WeedPacks > 0 then
        return
    end

    local resources = {
        Config.Integrations.BunnyWhiteWidow.Resource,
        Config.Integrations.BunnySmoking.Resource
    }

    local aggregated = {}
    for _, resourceName in ipairs(resources) do
        if resourceName and GetResourceState(resourceName) == 'started' then
            local packs = populateBunnyPacksFromResource(resourceName)
            for packName in pairs(packs) do
                aggregated[packName] = true
            end
        end
    end

    mergePackList(aggregated)

    if next(aggregated) then
        debugLog(('Auto-populated bunny weed packs: %s'):format(table.concat(Config.Bunny.WeedPacks, ', ')))
    end
end

local function getSkillLevel(source)
    return playerSkills[source] or Config.Skill.Base
end

local function setSkillLevel(source, value)
    playerSkills[source] = math.min(Config.Skill.Max, value)
end

local function hasItem(source, item, amount)
    local invType = detectInventoryType()

    if invType == 'ox' then
        local count = exports.ox_inventory:Search(source, 'count', item)
        return count >= amount
    end

    if invType == 'esx' then
        local esx = getESX()
        if not esx then
            return false
        end
        local xPlayer = esx.GetPlayerFromId(source)
        if not xPlayer then
            return false
        end
        local itemData = xPlayer.getInventoryItem(item)
        return itemData and itemData.count >= amount
    end

    -- Replace with your inventory system
    return true
end

local function removeItem(source, item, amount)
    local invType = detectInventoryType()

    if invType == 'ox' then
        return exports.ox_inventory:RemoveItem(source, item, amount)
    end

    if invType == 'esx' then
        local esx = getESX()
        if not esx then
            return false
        end
        local xPlayer = esx.GetPlayerFromId(source)
        if not xPlayer then
            return false
        end
        xPlayer.removeInventoryItem(item, amount)
        return true
    end

    -- Replace with your inventory system
    return true
end

local function addItem(source, item, amount, metadata)
    local invType = detectInventoryType()

    if invType == 'ox' then
        if Config.Inventory.UseOxMetadata then
            return exports.ox_inventory:AddItem(source, item, amount, metadata)
        end
        return exports.ox_inventory:AddItem(source, item, amount)
    end

    if invType == 'esx' then
        local esx = getESX()
        if not esx then
            return false
        end
        local xPlayer = esx.GetPlayerFromId(source)
        if not xPlayer then
            return false
        end
        xPlayer.addInventoryItem(item, amount)
        return true
    end

    -- Replace with your inventory system
    return true
end

local function checkSupplies(source)
    return hasItem(source, Config.Items.Weed, Config.Quantities.WeedRequired)
        and hasItem(source, Config.Items.Grinder, 1)
        and hasItem(source, Config.Items.Papers, 1)
        and hasItem(source, Config.Items.Filter, 1)
        and hasItem(source, Config.Items.Scale, 1)
        and hasItem(source, Config.Items.Tray, 1)
end

local function consumeSupplies(source)
    removeItem(source, Config.Items.Weed, Config.Quantities.WeedRequired)
    removeItem(source, Config.Items.Papers, 1)
    removeItem(source, Config.Items.Filter, 1)
    return true
end

local function rollQuality(skillLevel)
    local base = math.random(Config.Skill.Base, Config.Skill.Max)
    local quality = math.floor((base + skillLevel) / 2)
    return math.min(Config.Skill.Max, quality)
end

local function resolveOutcome(source, skillLevel)
    local quality = rollQuality(skillLevel)
    local failed = quality < Config.Skill.FailThreshold
    local perfect = quality >= Config.Skill.PerfectThreshold

    if failed then
        if math.random() <= Config.Quantities.ShakeChance then
            addItem(source, Config.Items.Shake, Config.Quantities.ShakeAmount)
        end
        return { failed = true }
    end

    local metadata = {
        quality = quality,
        thc = math.random(18, 29),
        weight = math.random(Config.Quantities.WeedMin * 10, Config.Quantities.WeedMax * 10) / 10,
        rolledAt = os.date('%Y-%m-%d %H:%M:%S')
    }

    addItem(source, Config.Items.FinishedJoint, 1, metadata)
    local integrationPayload = {
        source = source,
        item = Config.Items.FinishedJoint,
        metadata = metadata
    }

    if Config.Integrations.BunnyWhiteWidow.Enabled
        and GetResourceState(Config.Integrations.BunnyWhiteWidow.Resource) == 'started' then
        TriggerEvent(Config.Integrations.BunnyWhiteWidow.Event, integrationPayload)
    end

    if Config.Integrations.BunnySmoking.Enabled
        and GetResourceState(Config.Integrations.BunnySmoking.Resource) == 'started' then
        TriggerEvent(Config.Integrations.BunnySmoking.Event, integrationPayload)
    end

    return {
        failed = false,
        perfect = perfect,
        quality = quality
    }
end

RegisterNetEvent('weed_rolling:checkSupplies', function()
    local source = source

    autoPopulateBunnyPacks()

    if not checkSupplies(source) then
        TriggerClientEvent('weed_rolling:rollDenied', source)
        return
    end

    local skill = getSkillLevel(source)
    TriggerClientEvent('weed_rolling:startRolling', source, skill)
end)

RegisterNetEvent('weed_rolling:finishRolling', function(skillLevel)
    local source = source

    if not checkSupplies(source) then
        TriggerClientEvent('weed_rolling:rollDenied', source)
        return
    end

    consumeSupplies(source)

    local outcome = resolveOutcome(source, skillLevel)
    local newSkill = skillLevel + Config.Skill.GainPerRoll
    setSkillLevel(source, newSkill)

    TriggerClientEvent('weed_rolling:rollResult', source, outcome)
    debugLog(('Player %s rolled with quality %s'):format(source, outcome.quality or 'failed'))
end)

AddEventHandler('playerDropped', function()
    local source = source
    playerSkills[source] = nil
end)
