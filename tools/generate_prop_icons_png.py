#!/usr/bin/env python3
"""Generate simple PNG placeholder icons for consumable items (no external deps)."""
from pathlib import Path
import struct
import zlib

ITEMS = [
    'burger','hotdog','donut','chocolate','sandwich','water','soda','coffee',
    'kawaii_sushi','cl_frappe','cl_boba','cl_cupcake','cl_donut','cl_icecream','cl_milkshake','cl_pizza'
]

DRINKS = {'water', 'soda', 'coffee', 'cl_frappe', 'cl_boba', 'cl_milkshake'}

BG_EAT = (255, 184, 108)
BG_DRINK = (139, 233, 253)
FG = (17, 17, 17)


def png_chunk(chunk_type: bytes, data: bytes) -> bytes:
    crc = zlib.crc32(chunk_type + data) & 0xffffffff
    return struct.pack('!I', len(data)) + chunk_type + data + struct.pack('!I', crc)


def make_icon(path: Path, drink: bool, size: int = 256):
    bg = BG_DRINK if drink else BG_EAT

    rows = []
    for y in range(size):
        row = bytearray([0])  # filter type 0
        for x in range(size):
            r, g, b = bg

            # Dark border
            if x < 6 or y < 6 or x >= size - 6 or y >= size - 6:
                r, g, b = FG
            
            # Central simple glyph (fork/cup style block)
            if drink:
                if size//3 < x < (2*size)//3 and size//4 < y < (3*size)//4:
                    r, g, b = 235, 235, 235
                if (size//2 - 6) < x < (size//2 + 6) and (size//4 - 28) < y < (size//4 + 18):
                    r, g, b = 235, 235, 235
            else:
                if size//4 < x < (3*size)//4 and size//3 < y < (2*size)//3:
                    r, g, b = 235, 235, 235
                if size//4 < x < (3*size)//4 and (size//3 - 30) < y < (size//3 - 10):
                    r, g, b = 235, 235, 235

            row.extend((r, g, b, 255))
        rows.append(bytes(row))

    raw = b''.join(rows)
    compressed = zlib.compress(raw, level=9)

    png = bytearray()
    png.extend(b'\x89PNG\r\n\x1a\n')
    png.extend(png_chunk(b'IHDR', struct.pack('!IIBBBBB', size, size, 8, 6, 0, 0, 0)))
    png.extend(png_chunk(b'IDAT', compressed))
    png.extend(png_chunk(b'IEND', b''))

    path.write_bytes(png)


def main():
    out = Path('images/items')
    out.mkdir(parents=True, exist_ok=True)

    for item in ITEMS:
        make_icon(out / f'{item}.png', item in DRINKS)


if __name__ == '__main__':
    main()
