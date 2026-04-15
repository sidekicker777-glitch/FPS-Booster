# Prop Sources & Image Availability

This file tracks where each configured custom prop came from and whether public preview images are available.

## Source packs checked

### 1) Kawaii Food Prop Pack (bostra)
- Source: https://forum.cfx.re/t/free-props-kawaii-food-prop-pack/5054189
- Public preview images: **Yes**
  - https://forum-cfx-re.akamaized.net/original/5X/e/3/c/5/e3c5e0cbb2da96f8f7648fbd0a17ebd0b53d3328.png
  - https://forum-cfx-re.akamaized.net/original/5X/7/c/6/3/7c636f4ac2ad6c226f8f583754dc64485d4cf7bc.png

### 2) CL-PropsPacks (CloudDevelopment)
- Source: https://github.com/NevoSwissa/CL-PropsPacks
- Public preview images in repo: **No** (README points users to Discord for previews)
- Preview note: https://raw.githubusercontent.com/NevoSwissa/CL-PropsPacks/main/README.md

## Configured custom props in this resource
- `bostra_sushi_plate` (kawaii pack)
- `cl_frappe`, `cl_boba`, `cl_cupcake`, `cl_donut`, `cl_icecream`, `cl_milkshake`, `cl_pizza` (CL-PropsPacks)

## Generated images
Because not every pack provides direct downloadable item icons, generated placeholder item images are included in:
- `images/items/*.svg` (tracked)
- `images/items/*.png` (generated locally via `python tools/generate_prop_icons_png.py`)

This keeps pull requests text-only while still letting you use PNG item icons in-game.
