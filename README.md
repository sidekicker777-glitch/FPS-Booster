# ESX FPS Booster

Lightweight FPS booster resource for FiveM with ESX-friendly notifications and presets.

## Features
- Preset modes: `off`, `low`, `medium`, `high`
- Optional ESX notifications (falls back to chat)
- Tunable density and graphics controls

## Installation
1. Drop this folder into your server `resources` directory.
2. Add to `server.cfg`:
   ```
   ensure FPS Booster
   
   ```
3. (Optional) Adjust presets in `config.lua`.

## Usage
Use the in-game command:
```
/fpsboost [off|low|medium|high]
```

## Notes
- Some settings apply every frame for consistency.
- To change default mode or notifications, edit `config.lua`.
