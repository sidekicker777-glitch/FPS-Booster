local ESX = nil

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

local activeMode = Config.DefaultMode or 'off'
local lastMode = nil

local function notify(message)
  if Config.Notification == 'esx' and ESX then
    ESX.ShowNotification(message)
    return
  end

  TriggerEvent('chat:addMessage', {
    args = { '^2FPS Booster', message }
  })
end

local function applyTimecycle(modeConfig)
  if modeConfig.timecycle then
    SetTimecycleModifier(modeConfig.timecycle)
    SetTimecycleModifierStrength(1.0)
  else
    ClearTimecycleModifier()
  end
end

local function applyGraphicsFlags(modeConfig)
  if modeConfig.disableShadows then
    CascadeShadowsClearShadowSampleType()
    CascadeShadowsSetAircraftMode(true)
    CascadeShadowsEnableEntityTracker(true)
    CascadeShadowsSetDynamicDepthMode(false)
    CascadeShadowsSetEntityTrackerScale(0.0)
    CascadeShadowsSetDynamicDepthValue(0.0)
    CascadeShadowsSetCascadeBoundsScale(0.0)
  end

  if modeConfig.disableLights then
    SetArtificialLightsState(true)
    SetArtificialLightsStateAffectsVehicles(false)
  else
    SetArtificialLightsState(false)
  end

  if modeConfig.reduceParticles then
    DisableVehicleDistantlights(true)
    SetForceVehicleTrails(false)
    SetForcePedFootstepsTracks(false)
  else
    DisableVehicleDistantlights(false)
  end
end

local function applyMode(mode)
  local modeConfig = Config.Modes[mode]
  if not modeConfig then
    notify(('Unknown mode: %s'):format(mode))
    return
  end

  activeMode = mode
  applyTimecycle(modeConfig)
  applyGraphicsFlags(modeConfig)
  notify(('Mode set to %s'):format(modeConfig.label))
end

CreateThread(function()
  loadESX()
  if activeMode ~= 'off' then
    applyMode(activeMode)
  end

  while true do
    Wait(0)

    if activeMode ~= 'off' then
      local modeConfig = Config.Modes[activeMode]
      if modeConfig then
        SetVehicleDensityMultiplierThisFrame(modeConfig.vehicleDensity)
        SetRandomVehicleDensityMultiplierThisFrame(modeConfig.randomVehicleDensity)
        SetParkedVehicleDensityMultiplierThisFrame(modeConfig.parkedVehicleDensity)
        SetPedDensityMultiplierThisFrame(modeConfig.pedestrianDensity)
        SetScenarioPedDensityMultiplierThisFrame(modeConfig.scenarioPedDensity, modeConfig.scenarioPedDensity)
      end
    elseif lastMode and lastMode ~= 'off' then
      ClearTimecycleModifier()
      SetArtificialLightsState(false)
      DisableVehicleDistantlights(false)
      lastMode = nil
    end
  end
end)

RegisterCommand(Config.Command, function(_, args)
  local mode = args[1] and args[1]:lower() or 'off'
  if not Config.Modes[mode] then
    local options = {}
    for key in pairs(Config.Modes) do
      table.insert(options, key)
    end
    table.sort(options)
    notify(('Usage: /%s [%s]'):format(Config.Command, table.concat(options, ', ')))
    return
  end

  lastMode = activeMode
  applyMode(mode)
end)

RegisterNetEvent('esx:playerLoaded', function()
  loadESX()
end)
