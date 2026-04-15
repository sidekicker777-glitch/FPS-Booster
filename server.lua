local ESX = nil
local QBCore = nil
local activeFramework = nil

local function detectFramework()
  local target = Config.Framework or 'auto'
  if target == 'none' then
    return nil
  end

  if target == 'auto' or target == 'esx' then
    local ok, obj = pcall(function()
      return exports['es_extended']:getSharedObject()
    end)
    if ok and obj then
      ESX = obj
      return 'esx'
    end
  end

  if target == 'auto' or target == 'qb' then
    local ok, obj = pcall(function()
      return exports['qb-core']:GetCoreObject()
    end)
    if ok and obj then
      QBCore = obj
      return 'qb'
    end
  end

  return nil
end

local function itemExists(itemName)
  return itemName and Config.Items[itemName] ~= nil
end

local function consumeFromServer(src, itemName)
  TriggerClientEvent('fpsbooster:client:consume', src, itemName)
end

local function removeItemIfConfigured(src, itemName)
  if not Config.FrameworkOptions.removeItemOnUse then
    return
  end

  if activeFramework == 'esx' and ESX then
    local player = ESX.GetPlayerFromId(src)
    if player and player.getInventoryItem then
      local invItem = player.getInventoryItem(itemName)
      if invItem and invItem.count and invItem.count > 0 then
        player.removeInventoryItem(itemName, 1)
      end
    end
  elseif activeFramework == 'qb' and QBCore then
    local player = QBCore.Functions.GetPlayer(src)
    if player and player.Functions and player.Functions.RemoveItem then
      local removed = player.Functions.RemoveItem(itemName, 1)
      if removed and Config.FrameworkOptions.showItemBox and Config.Inventory == 'qb' then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemName], 'remove')
      end
    end
  end
end

local function registerUsables()
  if activeFramework == 'esx' and ESX then
    for itemName in pairs(Config.Items) do
      ESX.RegisterUsableItem(itemName, function(source)
        removeItemIfConfigured(source, itemName)
        consumeFromServer(source, itemName)
      end)
    end
    return
  end

  if activeFramework == 'qb' and QBCore then
    for itemName in pairs(Config.Items) do
      QBCore.Functions.CreateUseableItem(itemName, function(source)
        removeItemIfConfigured(source, itemName)
        consumeFromServer(source, itemName)
      end)
    end
  end
end

RegisterNetEvent('fpsbooster:server:requestConsume', function(itemName)
  local src = source
  if type(itemName) ~= 'string' then
    return
  end

  itemName = itemName:lower()
  if not itemExists(itemName) then
    TriggerClientEvent('chat:addMessage', src, {
      args = { '^1Consumables', ('Unknown item: %s'):format(itemName) }
    })
    return
  end

  removeItemIfConfigured(src, itemName)
  consumeFromServer(src, itemName)
end)

-- Generic event for ox_inventory or custom inventory callback wiring.
RegisterNetEvent('fpsbooster:server:consumeItem', function(itemName)
  local src = source
  if type(itemName) ~= 'string' then
    return
  end

  itemName = itemName:lower()
  if not itemExists(itemName) then
    return
  end

  removeItemIfConfigured(src, itemName)
  consumeFromServer(src, itemName)
end)


-- Optional direct hook if your qs-inventory use item triggers this event.
RegisterNetEvent('fpsbooster:server:consumeFromQS', function(itemName)
  local src = source
  if type(itemName) ~= 'string' then
    return
  end

  itemName = itemName:lower()
  if not itemExists(itemName) then
    return
  end

  removeItemIfConfigured(src, itemName)
  consumeFromServer(src, itemName)
end)

CreateThread(function()
  activeFramework = detectFramework()
  registerUsables()
end)
