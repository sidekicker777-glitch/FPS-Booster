# ESX FPS Booster

Lightweight FPS booster resource for FiveM with ESX-friendly notifications and presets.

## Features
- Preset modes: `off`, `low`, `medium`, `high`
- Optional ESX notifications (falls back to chat)
- Tunable density and graphics controls
- F7 UI with preset details and confirmation on disable
- Optional HUD indicator and remembered mode
- Advanced UI toggle with extra preset stats and keyboard shortcuts
- Preview mode with temporary apply

## Installation
1. Drop this folder into your server `resources` directory.
2. Add to `server.cfg`:
   ```
   ensure idk
   ```
3. (Optional) Adjust presets in `config.lua`.

## Usage
Open the UI with **F7** or use the in-game command:
```
/fpsboost [off|low|medium|high]
```

## Notes
- Some settings apply every frame for consistency.
- To change default mode, keybind, or notifications, edit `config.lua`.
- Disable the UI or HUD indicator via `Config.Ui.enabled` and `Config.ShowHud`.
- Preview duration is configured via `Config.PreviewDurationSeconds`.
