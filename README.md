# QBCore + QS-Inventory Food Consumables

This is now configured specifically for **QBCore + qs-inventory**.
When you use any configured food/drink item, your character will play the correct eat/drink animation with a hand prop.

## Included item names (ready for your server)
`burger`, `hotdog`, `donut`, `chocolate`, `sandwich`, `water`, `soda`, `coffee`, `kawaii_sushi`, `cl_frappe`, `cl_boba`, `cl_cupcake`, `cl_donut`, `cl_icecream`, `cl_milkshake`, `cl_pizza`

## What was changed for QBCore + QS
- `Config.Framework` default is now `qb`.
- `Config.Inventory` default is now `qs`.
- Usable items are registered with `QBCore.Functions.CreateUseableItem` for every entry in `Config.Items`.
- `inventory:client:ItemBox` is no longer forced (disabled by default for QS compatibility).
- Added optional event hook: `fpsbooster:server:consumeFromQS`.

## Install
1. Put resource in `resources/[local]/FPS-Booster`
2. Add to `server.cfg`:
   ```cfg
   ensure FPS-Booster
   ```
3. Add all item definitions from `integration/items_qb.lua` into `qb-core/shared/items.lua`.
4. Restart `qb-core` and this resource.

## QS inventory note
Most QBCore + QS setups work directly via `CreateUseableItem` once items are in `qb-core/shared/items.lua`.
If your QS build uses a custom use-item trigger, call:

```lua
TriggerServerEvent('fpsbooster:server:consumeFromQS', itemName)
```

## Free prop packs referenced
- https://forum.cfx.re/t/free-props-kawaii-food-prop-pack/5054189
- https://github.com/NevoSwissa/CL-PropsPacks

## Optional test commands
- `/consumables`
- `/consume [item]`


## Prop image status
- Full source/image tracking is in `PROP_SOURCES.md`.
- Tracked placeholder icons are in `images/items/*.svg`. PNG files are generated locally with `python tools/generate_prop_icons_png.py`.
- After cloning, run `python tools/generate_prop_icons_png.py` to generate PNG icons in `images/items/` for QBCore item images.


### PR note
PNG files are intentionally ignored in git to avoid PR tools that block binary diffs ("Binary files are not supported").
