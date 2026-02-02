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
local uiOpen = false
local previousTimecycle = nil
local modeKey = 'fpsboost:mode'
local previewTimeoutId = nil
local previewPreviousMode = nil

if Config.RememberMode then
  local storedMode = GetResourceKvpString(modeKey)
  if storedMode and Config.Modes[storedMode] then
    activeMode = storedMode
  end
end

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
    if not previousTimecycle then
      previousTimecycle = GetTimecycleModifier()
    end
    SetTimecycleModifier(modeConfig.timecycle)
    SetTimecycleModifierStrength(1.0)
  else
    if previousTimecycle and previousTimecycle ~= '' then
      SetTimecycleModifier(previousTimecycle)
      SetTimecycleModifierStrength(1.0)
    else
      ClearTimecycleModifier()
    end
    previousTimecycle = nil
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

local function applyMode(mode, options)
  options = options or {}
  local modeConfig = Config.Modes[mode]
  if not modeConfig then
    notify(('Unknown mode: %s'):format(mode))
    return
  end

  activeMode = mode
  applyTimecycle(modeConfig)
  applyGraphicsFlags(modeConfig)
  if options.notify ~= false then
    notify(options.message or ('Mode set to %s'):format(modeConfig.label))
  end

  if options.persist ~= false and Config.RememberMode then
    SetResourceKvp(modeKey, mode)
  end
end

local function cancelPreview(restore)
  if previewTimeoutId then
    ClearTimeout(previewTimeoutId)
    previewTimeoutId = nil
  end

  if restore and previewPreviousMode then
    applyMode(previewPreviousMode, { persist = false, notify = false })
  end

  previewPreviousMode = nil
end

local function startPreview(mode)
  cancelPreview(false)
  previewPreviousMode = activeMode
  local modeConfig = Config.Modes[mode]
  if not modeConfig then
    return
  end

  applyMode(mode, {
    persist = false,
    message = ('Previewing %s'):format(modeConfig.label),
  })

  local duration = (Config.PreviewDurationSeconds or 5) * 1000
  previewTimeoutId = SetTimeout(duration, function()
    cancelPreview(true)
  end)
end

local function buildModePayload()
  local modes = {}
  for key, value in pairs(Config.Modes) do
    table.insert(modes, {
      key = key,
      label = value.label,
      description = value.description,
      badge = value.badge,
      timecycle = value.timecycle,
      vehicleDensity = value.vehicleDensity,
      pedestrianDensity = value.pedestrianDensity,
      randomVehicleDensity = value.randomVehicleDensity,
      parkedVehicleDensity = value.parkedVehicleDensity,
      scenarioPedDensity = value.scenarioPedDensity,
      disableShadows = value.disableShadows,
      disableLights = value.disableLights,
      reduceParticles = value.reduceParticles,
    })
  end
  table.sort(modes, function(a, b)
    return a.key < b.key
  end)

  return modes
end

local function setUiVisible(state)
  uiOpen = state
  SetNuiFocus(state, state)
  SendNUIMessage({
    type = 'toggle',
    visible = state,
    current = activeMode,
    modes = buildModePayload(),
    keybind = Config.Ui.keybind or 'F7',
  })
end

local function drawModeIndicator()
  if not Config.ShowHud then
    return
  end

  if activeMode == 'off' or uiOpen then
    return
  end

  SetTextFont(4)
  SetTextScale(0.35, 0.35)
  SetTextColour(255, 255, 255, 200)
  SetTextOutline()
  SetTextEntry('STRING')
  AddTextComponentString(('FPS Booster: %s'):format(Config.Modes[activeMode].label))
  DrawText(0.5, 0.95)
end

CreateThread(function()
  loadESX()
  if activeMode ~= 'off' then
    applyMode(activeMode)
  end

  while true do
    local waitTime = activeMode == 'off' and 500 or 0
    Wait(waitTime)

    if activeMode ~= 'off' then
      local modeConfig = Config.Modes[activeMode]
      if modeConfig then
        SetVehicleDensityMultiplierThisFrame(modeConfig.vehicleDensity)
        SetRandomVehicleDensityMultiplierThisFrame(modeConfig.randomVehicleDensity)
        SetParkedVehicleDensityMultiplierThisFrame(modeConfig.parkedVehicleDensity)
        SetPedDensityMultiplierThisFrame(modeConfig.pedestrianDensity)
        SetScenarioPedDensityMultiplierThisFrame(modeConfig.scenarioPedDensity, modeConfig.scenarioPedDensity)
      end

      drawModeIndicator()
    elseif lastMode and lastMode ~= 'off' then
      applyTimecycle(Config.Modes.off)
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
  cancelPreview(false)
  applyMode(mode)
end)

if Config.Ui.enabled then
  RegisterCommand('fpsboostui', function()
    setUiVisible(not uiOpen)
  end)

  RegisterKeyMapping('fpsboostui', 'Open FPS Booster UI', 'keyboard', Config.Ui.keybind or 'F7')

  RegisterNUICallback('close', function(_, cb)
    setUiVisible(false)
    cb('ok')
  end)

  RegisterNUICallback('setMode', function(data, cb)
    if data and data.mode then
      lastMode = activeMode
      cancelPreview(false)
      applyMode(data.mode)
      SendNUIMessage({
        type = 'update',
        current = activeMode,
      })
    end
    cb('ok')
  end)

  RegisterNUICallback('previewMode', function(data, cb)
    if data and data.mode then
      startPreview(data.mode)
    end
    cb('ok')
  end)
end

RegisterNetEvent('esx:playerLoaded', function()
  loadESX()
end)
