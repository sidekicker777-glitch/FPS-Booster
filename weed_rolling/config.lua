Config = {}

Config.Debug = false

Config.Rolling = {
    AllowPocket = true,
    RequireStations = false
}

Config.Inventory = {
    Type = 'auto', -- auto | esx | ox | custom
    UseOxMetadata = true
}

Config.Integrations = {
    BunnyWhiteWidow = {
        Enabled = true,
        Resource = 'bunny_whitewidow',
        Event = 'bunny_whitewidow:jointRolled'
    },
    BunnySmoking = {
        Enabled = true,
        Resource = 'bunny_smoking',
        Event = 'bunny_smoking:jointRolled'
    }
}

Config.Bunny = {
    -- Populate with item names from your bunny resources (packs, bags, etc.)
    -- Example: { 'bunny_whitewidow_pack', 'bunny_sour_diesel_pack' }
    WeedPacks = {},
    AutoPopulate = true,
    ResourceFiles = {
        'items.lua',
        'shared/items.lua',
        'config.lua',
        'shared/config.lua'
    },
    PackToken = 'pack'
}

Config.Items = {
    Weed = 'weed_bud',
    Grinder = 'weed_grinder',
    Papers = 'rolling_paper',
    Filter = 'weed_filter',
    Scale = 'digital_scale',
    Tray = 'rolling_tray',
    FinishedJoint = 'weed_joint',
    Shake = 'weed_shake'
}

Config.Quantities = {
    WeedRequired = 1.6, -- grams
    WeedMin = 0.8,
    WeedMax = 2.2,
    ShakeChance = 0.15,
    ShakeAmount = 0.2
}

Config.Timers = {
    PrepTable = 2500,
    Grind = 5500,
    Weigh = 3500,
    Pack = 4500,
    Seal = 3000,
    Finish = 2500
}

Config.Skill = {
    Base = 40,
    Max = 100,
    GainPerRoll = 2,
    FailThreshold = 25,
    PerfectThreshold = 85
}

Config.CooldownSeconds = 10

Config.RollStations = {
    {
        coords = vector3(1121.46, -3194.62, -40.4),
        heading = 268.5,
        radius = 2.0,
        label = 'Rolling Table'
    }
}

Config.Animations = {
    Prep = {
        dict = 'amb@prop_human_bum_bin@idle_b',
        name = 'idle_d'
    },
    Grind = {
        dict = 'amb@world_human_gardener_plant@male@enter',
        name = 'enter'
    },
    Weigh = {
        dict = 'amb@world_human_bum_wash@male@low@base',
        name = 'base'
    },
    Pack = {
        dict = 'anim@amb@business@weed@weed_inspecting_lo_med_hi@',
        name = 'weed_inspecting_lo_med_hi_inspector'
    },
    Seal = {
        dict = 'amb@world_human_clipboard@male@base',
        name = 'base'
    },
    Finish = {
        dict = 'amb@world_human_smoking@male@male_a@base',
        name = 'base'
    }
}

Config.Strings = {
    NotEnough = 'You are missing required rolling supplies.',
    Busy = 'You are already rolling.',
    TooFar = 'Get closer to a rolling station.',
    Cooldown = 'Let the joint settle before rolling another.',
    StartRoll = 'You lay out your rolling tray and start prepping.',
    RollFailed = 'The roll fell apart. You salvaged some shake.',
    RollSuccess = 'You rolled a joint with %s%% quality.',
    RollPerfect = 'You rolled a perfect joint!',
    PocketStart = 'You start rolling a joint from your pocket stash.'
}
