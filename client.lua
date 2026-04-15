local ESX = nil
local isBusy = false
local lastConsumeAt = 0

local function loadESX()
  if ESX then
    return
  end

  local ok, esx = pcall(function()
    return exports['es_extended']:getSharedObject()
  end)

  if ok then
    ESX = esx
  end
end

local function notify(message)
  if Config.Notification == 'esx' then
    loadESX()
    if ESX then
      ESX.ShowNotification(message)
      return
    end
  end

  TriggerEvent('chat:addMessage', {
    args = { '^2Consumables', message }
  })
end

local function requestAnimDict(dict)
  RequestAnimDict(dict)
  local timeout = GetGameTimer() + 5000

  while not HasAnimDictLoaded(dict) and GetGameTimer() < timeout do
    Wait(0)
  end

  return HasAnimDictLoaded(dict)
end

local function requestModel(model)
  local hash = type(model) == 'number' and model or joaat(model)
  if not IsModelValid(hash) then
    return nil
  end

  RequestModel(hash)
  local timeout = GetGameTimer() + 5000

  while not HasModelLoaded(hash) and GetGameTimer() < timeout do
    Wait(0)
  end

  if not HasModelLoaded(hash) then
    return nil
  end

  return hash
end


local function resolveAnimation(itemConfig)
  if itemConfig.animDict and itemConfig.animClip then
    return itemConfig.animDict, itemConfig.animClip
  end

  if itemConfig.itemType == 'drink' then
    return 'mp_player_intdrink', 'loop_bottle'
  end

  return 'mp_player_inteat@pnq', 'loop'
end

local function applyEffects(itemName, itemConfig)
  local ped = PlayerPedId()
  local effects = itemConfig.effects or {}

  if effects.health and effects.health > 0 then
    local maxHealth = GetEntityMaxHealth(ped)
    local nextHealth = math.min(maxHealth, GetEntityHealth(ped) + effects.health)
    SetEntityHealth(ped, nextHealth)
  end

  if effects.armor and effects.armor > 0 then
    local nextArmor = math.min(100, GetPedArmour(ped) + effects.armor)
    SetPedArmour(ped, nextArmor)
  end

  if Config.FrameworkHooks.onConsumeFinish then
    TriggerEvent(Config.FrameworkHooks.onConsumeFinish, itemName, effects)
  end
end

local function playConsume(itemName)
  local now = GetGameTimer()
  if isBusy then
    notify('You are already consuming an item.')
    return
  end

  if now - lastConsumeAt < Config.CooldownMs then
    notify('Please wait a moment before consuming another item.')
    return
  end

  local itemConfig = Config.Items[itemName]
  if not itemConfig then
    notify(('Unknown consumable: %s'):format(itemName))
    return
  end

  local animDict, animClip = resolveAnimation(itemConfig)
  local animLoaded = requestAnimDict(animDict)
  if not animLoaded then
    notify(('Animation dictionary failed to load: %s'):format(animDict))
    return
  end

  local modelHash = requestModel(itemConfig.prop)
  if not modelHash then
    notify(('Prop model not found: %s (install source pack: %s)'):format(itemConfig.prop, itemConfig.sourcePack or 'unknown'))
    return
  end

  local ped = PlayerPedId()
  local coords = GetEntityCoords(ped)
  local obj = CreateObject(modelHash, coords.x, coords.y, coords.z + 0.2, true, true, false)

  local pos = itemConfig.pos or vec3(0.03, 0.0, -0.02)
  local rot = itemConfig.rot or vec3(0.0, 0.0, 0.0)
  local bone = itemConfig.bone or 60309
  local duration = itemConfig.durationMs or Config.DefaultConsumeTimeMs

  AttachEntityToEntity(
    obj,
    ped,
    GetPedBoneIndex(ped, bone),
    pos.x,
    pos.y,
    pos.z,
    rot.x,
    rot.y,
    rot.z,
    true,
    true,
    false,
    true,
    1,
    true
  )

  if Config.FrameworkHooks.onConsumeStart then
    TriggerEvent(Config.FrameworkHooks.onConsumeStart, itemName)
  end

  isBusy = true
  TaskPlayAnim(ped, animDict, animClip, 3.0, -1.0, duration, itemConfig.flags or 49, 0, false, false, false)

  local endAt = GetGameTimer() + duration
  while GetGameTimer() < endAt do
    Wait(0)
    if IsEntityDead(ped) then
      break
    end
  end

  ClearPedTasks(ped)
  Wait(Config.PropDetachDelayMs)

  if DoesEntityExist(obj) then
    DetachEntity(obj, true, true)
    DeleteObject(obj)
  end

  SetModelAsNoLongerNeeded(modelHash)
  RemoveAnimDict(animDict)

  applyEffects(itemName, itemConfig)
  notify(('Consumed: %s'):format(itemConfig.label))

  isBusy = false
  lastConsumeAt = GetGameTimer()
end

RegisterNetEvent('fpsbooster:client:consume', function(itemName)
  if type(itemName) ~= 'string' then
    return
  end

  playConsume(itemName:lower())
end)

RegisterCommand(Config.Command, function(_, args)
  local itemName = args[1] and args[1]:lower() or nil
  if not itemName then
    notify(('Usage: /%s [item]'):format(Config.Command))
    return
  end

  TriggerServerEvent('fpsbooster:server:requestConsume', itemName)
end)

RegisterCommand(Config.ListCommand, function()
  local names = {}
  for key, item in pairs(Config.Items) do
    table.insert(names, ('%s (%s)'):format(key, item.label or key))
  end

  table.sort(names)
  notify(('Available items: %s'):format(table.concat(names, ', ')))
end)

RegisterNetEvent('esx:playerLoaded', function()
  loadESX()
end)


-- ox_inventory client export support:
-- in items.lua set: client = { export = 'FPS-Booster.consumeItem' }
exports('consumeItem', function(data, slot)
  local itemName = nil
  if type(data) == 'table' then
    itemName = data.name or data.item or data.value
  elseif type(data) == 'string' then
    itemName = data
  end

  if not itemName and type(slot) == 'table' then
    itemName = slot.name
  end

  if not itemName then
    return false
  end

  TriggerServerEvent('fpsbooster:server:consumeItem', tostring(itemName):lower())
  return true
end)
