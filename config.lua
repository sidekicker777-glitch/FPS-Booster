Config = {}

-- Auto-detect supported framework ('esx' or 'qb') and register all items as usable.
-- Set to 'none' if you only want manual triggering via event/command.
Config.Framework = 'qb' -- 'auto' | 'esx' | 'qb' | 'none'

-- Commands are fallback helpers (useful for testing without inventory integration).
Config.Command = 'consume'
Config.ListCommand = 'consumables'

Config.Notification = 'chat' -- 'chat' | 'esx'
Config.PropDetachDelayMs = 200
Config.DefaultConsumeTimeMs = 4500
Config.CooldownMs = 1500
Config.Inventory = 'qs' -- 'qs' | 'qb' | 'ox' | 'custom'

Config.FrameworkOptions = {
  removeItemOnUse = true,
  esxStatusEvent = nil, -- e.g. 'esx_status:add'
  qbMetadataTick = nil, -- e.g. set hunger/thirst metadata in your bridge
  showItemBox = false -- keep false for qs-inventory unless you use qb-inventory UI event
}

Config.FrameworkHooks = {
  onConsumeStart = nil,
  onConsumeFinish = nil
}

-- Every entry here becomes a usable item when framework auto-registration is enabled.
-- itemType controls default animation behavior: 'eat' or 'drink'.
Config.Items = {
  -- Base GTA props
  burger = {
    label = 'Burger', itemType = 'eat',
    prop = 'prop_cs_burger_01', bone = 60309,
    pos = vec3(0.02, 0.01, -0.01), rot = vec3(10.0, 175.0, 20.0),
    animDict = 'mp_player_inteat@burger', animClip = 'mp_player_int_eat_burger',
    durationMs = 4500, effects = { health = 12 }, sourcePack = 'base-game'
  },
  hotdog = {
    label = 'Hot Dog', itemType = 'eat',
    prop = 'prop_cs_hotdog_01', bone = 60309,
    pos = vec3(0.03, 0.00, -0.02), rot = vec3(12.0, 170.0, 30.0),
    animDict = 'mp_player_inteat@burger', animClip = 'mp_player_int_eat_burger',
    durationMs = 4200, effects = { health = 10 }, sourcePack = 'base-game'
  },
  donut = {
    label = 'Donut', itemType = 'eat',
    prop = 'prop_amb_donut', bone = 60309,
    pos = vec3(0.02, 0.00, -0.02), rot = vec3(0.0, 160.0, 5.0),
    animDict = 'mp_player_inteat@pnq', animClip = 'loop',
    durationMs = 3800, effects = { health = 6 }, sourcePack = 'base-game'
  },
  chocolate = {
    label = 'Chocolate Bar', itemType = 'eat',
    prop = 'prop_choc_meto', bone = 60309,
    pos = vec3(0.02, 0.00, -0.02), rot = vec3(5.0, 165.0, 10.0),
    animDict = 'mp_player_inteat@pnq', animClip = 'loop',
    durationMs = 3600, effects = { health = 4 }, sourcePack = 'base-game'
  },
  sandwich = {
    label = 'Sandwich', itemType = 'eat',
    prop = 'prop_sandwich_01', bone = 60309,
    pos = vec3(0.02, 0.01, -0.02), rot = vec3(12.0, 170.0, 15.0),
    animDict = 'mp_player_inteat@burger', animClip = 'mp_player_int_eat_burger',
    durationMs = 4300, effects = { health = 9 }, sourcePack = 'base-game'
  },
  water = {
    label = 'Water', itemType = 'drink',
    prop = 'prop_ld_flow_bottle', bone = 60309,
    pos = vec3(0.04, -0.02, -0.02), rot = vec3(0.0, 0.0, 130.0),
    animDict = 'mp_player_intdrink', animClip = 'loop_bottle',
    durationMs = 3500, effects = { health = 3 }, sourcePack = 'base-game'
  },
  soda = {
    label = 'Soda', itemType = 'drink',
    prop = 'prop_ecola_can', bone = 60309,
    pos = vec3(0.03, 0.00, -0.02), rot = vec3(0.0, 0.0, 130.0),
    animDict = 'mp_player_intdrink', animClip = 'loop_bottle',
    durationMs = 3600, effects = { health = 4, armor = 2 }, sourcePack = 'base-game'
  },
  coffee = {
    label = 'Coffee', itemType = 'drink',
    prop = 'p_amb_coffeecup_01', bone = 60309,
    pos = vec3(0.01, -0.01, -0.03), rot = vec3(5.0, 0.0, 40.0),
    animDict = 'mp_player_intdrink', animClip = 'loop_bottle',
    durationMs = 3600, effects = { health = 5 }, sourcePack = 'base-game'
  },

  -- Props from free packs found previously
  kawaii_sushi = {
    label = 'Kawaii Sushi Plate', itemType = 'eat',
    prop = 'bostra_sushi_plate', bone = 60309,
    pos = vec3(0.04, 0.00, -0.02), rot = vec3(4.0, 160.0, 20.0),
    animDict = 'mp_player_inteat@pnq', animClip = 'loop',
    durationMs = 5000, effects = { health = 14 }, sourcePack = 'bostra-kawaii-food'
  },
  cl_frappe = {
    label = 'CL Frappe', itemType = 'drink',
    prop = 'cl_frappe', bone = 60309,
    pos = vec3(0.03, 0.00, -0.02), rot = vec3(0.0, 0.0, 140.0),
    animDict = 'mp_player_intdrink', animClip = 'loop_bottle',
    durationMs = 3700, effects = { health = 5 }, sourcePack = 'CL-PropsPacks'
  },
  cl_boba = {
    label = 'CL Boba', itemType = 'drink',
    prop = 'cl_boba', bone = 60309,
    pos = vec3(0.03, 0.00, -0.02), rot = vec3(0.0, 0.0, 140.0),
    animDict = 'mp_player_intdrink', animClip = 'loop_bottle',
    durationMs = 3800, effects = { health = 5 }, sourcePack = 'CL-PropsPacks'
  },
  cl_cupcake = {
    label = 'CL Cupcake', itemType = 'eat',
    prop = 'cl_cupcake', bone = 60309,
    pos = vec3(0.02, 0.00, -0.02), rot = vec3(0.0, 165.0, 12.0),
    animDict = 'mp_player_inteat@pnq', animClip = 'loop',
    durationMs = 3600, effects = { health = 7 }, sourcePack = 'CL-PropsPacks'
  },
  cl_donut = {
    label = 'CL Donut', itemType = 'eat',
    prop = 'cl_donut', bone = 60309,
    pos = vec3(0.02, 0.00, -0.02), rot = vec3(0.0, 165.0, 12.0),
    animDict = 'mp_player_inteat@pnq', animClip = 'loop',
    durationMs = 3600, effects = { health = 7 }, sourcePack = 'CL-PropsPacks'
  },
  cl_icecream = {
    label = 'CL Ice Cream', itemType = 'eat',
    prop = 'cl_icecream', bone = 60309,
    pos = vec3(0.02, 0.00, -0.02), rot = vec3(5.0, 160.0, 20.0),
    animDict = 'mp_player_inteat@pnq', animClip = 'loop',
    durationMs = 3900, effects = { health = 8 }, sourcePack = 'CL-PropsPacks'
  },
  cl_milkshake = {
    label = 'CL Milkshake', itemType = 'drink',
    prop = 'cl_milkshake', bone = 60309,
    pos = vec3(0.03, 0.00, -0.02), rot = vec3(0.0, 0.0, 140.0),
    animDict = 'mp_player_intdrink', animClip = 'loop_bottle',
    durationMs = 3900, effects = { health = 6 }, sourcePack = 'CL-PropsPacks'
  },
  cl_pizza = {
    label = 'CL Pizza Slice', itemType = 'eat',
    prop = 'cl_pizza', bone = 60309,
    pos = vec3(0.03, 0.00, -0.02), rot = vec3(8.0, 165.0, 20.0),
    animDict = 'mp_player_inteat@burger', animClip = 'mp_player_int_eat_burger',
    durationMs = 4200, effects = { health = 10 }, sourcePack = 'CL-PropsPacks'
  }
}
