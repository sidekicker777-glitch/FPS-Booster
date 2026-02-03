# Weed Rolling (FiveM)

A realistic, step-by-step weed rolling flow that uses multiple animation stages, a skill system, and quality outcomes.

## Features
- **Multi-stage rolling flow**: prep, grind, weigh, pack, seal, finish.
- **Skill-based quality**: improves per roll and affects joint quality.
- **Configurable supplies**: define required items and quantities in `config.lua`.
- **Inventory hooks**: replace placeholder functions with your inventory API.
- **Pocket rolling**: allow rolling anywhere or restrict to stations.
- **Bunny integrations**: optional hooks for `bunny_whitewidow` and `bunny_smoking`.

## Installation
1. Drop the `weed_rolling` folder into your server `resources` directory.
2. Add `ensure weed_rolling` to your `server.cfg`.
3. Update the inventory hooks in `server.lua` for your framework.

## Usage
- Use `/rollweed` or press **J** near a rolling station.
- Configure station locations in `config.lua` (`Config.RollStations`).
- Toggle pocket rolling in `Config.Rolling`.

## Inventory Integration
The script supports **ESX** and **ox_inventory** out of the box.

Update these settings in `config.lua`:
- `Config.Inventory.Type = 'auto' | 'esx' | 'ox' | 'custom'`
- `Config.Inventory.UseOxMetadata = true` to store metadata on ox_inventory items.

If you use a different inventory, edit `server.lua`:
- `hasItem(source, item, amount)`
- `removeItem(source, item, amount)`
- `addItem(source, item, amount, metadata)`

## Bunny Integrations
If you use **bunny_whitewidow** or **bunny_smoking**, the script can trigger events after a joint is rolled.

Configure in `config.lua`:
- `Config.Integrations.BunnyWhiteWidow.Enabled` and `Event`
- `Config.Integrations.BunnySmoking.Enabled` and `Event`
- `Config.Bunny.WeedPacks` with item names from your bunny resources
- `Config.Bunny.AutoPopulate` to auto-load pack names from bunny resource item files

Event payload:
```lua
{
  source = playerId,
  item = 'weed_joint',
  metadata = {
    quality = 92,
    thc = 24,
    weight = 1.5,
    rolledAt = '2024-01-01 12:00:00'
  }
}
```

## Notes
- If you use a progress bar resource, the script will attempt to use `progressBars` if present.
- You can tune the realism in `Config.Quantities` and `Config.Timers`.
