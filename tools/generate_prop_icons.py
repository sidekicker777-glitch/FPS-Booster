#!/usr/bin/env python3
"""Generate simple SVG placeholder icons for consumable items."""
from pathlib import Path

ITEMS = [
    'burger','hotdog','donut','chocolate','sandwich','water','soda','coffee',
    'kawaii_sushi','cl_frappe','cl_boba','cl_cupcake','cl_donut','cl_icecream','cl_milkshake','cl_pizza'
]

COLORS = {
    'eat': '#ffb86c',
    'drink': '#8be9fd'
}

DRINKS = {'water', 'soda', 'coffee', 'cl_frappe', 'cl_boba', 'cl_milkshake'}

TEMPLATE = """<svg xmlns='http://www.w3.org/2000/svg' width='512' height='512' viewBox='0 0 512 512'>
  <rect width='512' height='512' rx='32' fill='{bg}' />
  <text x='256' y='208' text-anchor='middle' font-family='Arial, sans-serif' font-size='54' fill='#111'>FPS</text>
  <text x='256' y='274' text-anchor='middle' font-family='Arial, sans-serif' font-size='54' fill='#111'>FOOD</text>
  <text x='256' y='356' text-anchor='middle' font-family='Arial, sans-serif' font-size='36' fill='#111'>{item}</text>
</svg>
"""

def main():
    out_dir = Path('images/items')
    out_dir.mkdir(parents=True, exist_ok=True)

    for item in ITEMS:
        kind = 'drink' if item in DRINKS else 'eat'
        svg = TEMPLATE.format(bg=COLORS[kind], item=item.upper())
        (out_dir / f"{item}.svg").write_text(svg, encoding='utf-8')

if __name__ == '__main__':
    main()
