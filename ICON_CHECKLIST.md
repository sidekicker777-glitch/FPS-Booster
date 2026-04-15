# QBCore / QS Inventory Icon Checklist

Use this checklist to fill your real PNG icons in your inventory image folder.

## Target folder
- Typical path: `qb-inventory/html/images/`
- For qs-inventory, use your configured image folder path.

## Required files (matches `integration/items_qb.lua`)

| Item key | Required PNG filename | Status | Source suggestion |
|---|---|---|---|
| burger | `burger.png` | ☐ pending | existing qb-core food icon packs |
| hotdog | `hotdog.png` | ☐ pending | existing qb-core food icon packs |
| donut | `donut.png` | ☐ pending | existing qb-core food icon packs |
| chocolate | `chocolate.png` | ☐ pending | existing qb-core food icon packs |
| sandwich | `sandwich.png` | ☐ pending | existing qb-core food icon packs |
| water | `water.png` | ☐ pending | existing qb-core drink icon packs |
| soda | `soda.png` | ☐ pending | existing qb-core drink icon packs |
| coffee | `coffee.png` | ☐ pending | existing qb-core drink icon packs |
| kawaii_sushi | `kawaii_sushi.png` | ☐ pending | Kawaii pack previews (see `PROP_SOURCES.md`) |
| cl_frappe | `cl_frappe.png` | ☐ pending | CL-PropsPacks (Discord previews) |
| cl_boba | `cl_boba.png` | ☐ pending | CL-PropsPacks (Discord previews) |
| cl_cupcake | `cl_cupcake.png` | ☐ pending | CL-PropsPacks (Discord previews) |
| cl_donut | `cl_donut.png` | ☐ pending | CL-PropsPacks (Discord previews) |
| cl_icecream | `cl_icecream.png` | ☐ pending | CL-PropsPacks (Discord previews) |
| cl_milkshake | `cl_milkshake.png` | ☐ pending | CL-PropsPacks (Discord previews) |
| cl_pizza | `cl_pizza.png` | ☐ pending | CL-PropsPacks (Discord previews) |

## Fast validation
After you copy images into the folder, check file names exactly match.

Example PowerShell check (run from images folder):
```powershell
$required = @(
  'burger.png','hotdog.png','donut.png','chocolate.png','sandwich.png','water.png','soda.png','coffee.png',
  'kawaii_sushi.png','cl_frappe.png','cl_boba.png','cl_cupcake.png','cl_donut.png','cl_icecream.png','cl_milkshake.png','cl_pizza.png'
)
$missing = $required | Where-Object { -not (Test-Path $_) }
if ($missing.Count -eq 0) { 'All icon files present.' } else { 'Missing:'; $missing }
```

## Notes
- File names are case-sensitive on Linux servers.
- Keep PNG dimensions consistent (e.g., 128x128 or 256x256).
- Restart inventory/resource after adding or replacing image files.
