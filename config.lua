Config = {}

Config.Command = 'fpsboost'
Config.DefaultMode = 'off'
Config.Notification = 'chat'
Config.RememberMode = true
Config.ShowHud = true
Config.PreviewDurationSeconds = 5

Config.Ui = {
  enabled = true,
  keybind = 'F7',
}

Config.Modes = {
  off = {
    label = 'Off',
    description = 'Restore default visuals and densities.',
    badge = 'Default',
    timecycle = nil,
    vehicleDensity = 1.0,
    pedestrianDensity = 1.0,
    randomVehicleDensity = 1.0,
    parkedVehicleDensity = 1.0,
    scenarioPedDensity = 1.0,
    disableShadows = false,
    disableLights = false,
    reduceParticles = false,
  },
  low = {
    label = 'Low',
    description = 'Light tweaks for a small performance boost.',
    badge = 'Light',
    timecycle = 'yell_tunnel_nodirect',
    vehicleDensity = 0.6,
    pedestrianDensity = 0.6,
    randomVehicleDensity = 0.6,
    parkedVehicleDensity = 0.5,
    scenarioPedDensity = 0.6,
    disableShadows = true,
    disableLights = true,
    reduceParticles = true,
  },
  medium = {
    label = 'Medium',
    description = 'Balanced preset with reduced density and effects.',
    badge = 'Recommended',
    timecycle = 'HINT_cam',
    vehicleDensity = 0.4,
    pedestrianDensity = 0.4,
    randomVehicleDensity = 0.4,
    parkedVehicleDensity = 0.35,
    scenarioPedDensity = 0.4,
    disableShadows = true,
    disableLights = true,
    reduceParticles = true,
  },
  high = {
    label = 'High',
    description = 'Aggressive preset for maximum FPS.',
    badge = 'Max',
    timecycle = 'MP_Bull_tod',
    vehicleDensity = 0.2,
    pedestrianDensity = 0.2,
    randomVehicleDensity = 0.2,
    parkedVehicleDensity = 0.2,
    scenarioPedDensity = 0.2,
    disableShadows = true,
    disableLights = true,
    reduceParticles = true,
  },
}
