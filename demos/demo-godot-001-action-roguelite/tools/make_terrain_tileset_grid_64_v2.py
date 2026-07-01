from PIL import Image
from pathlib import Path

root = Path(r"D:\FORK\specskill\Project-A\demos\demo-godot-001-action-roguelite\assets\art\toy_repair_prototype\terrain_tiles")
source = Image.open(root / "terrain_tilesheet_1024_4_clean.png").convert("RGBA")
out = Image.new("RGBA", (512, 256), (0, 0, 0, 0))

items = [
    ((0, 0), (1, 1), (2, 5, 130, 133)),
    ((1, 0), (1, 1), (365, 15, 550, 139)),
    ((2, 0), (1, 1), (591, 15, 793, 137)),
    ((3, 0), (1, 1), (827, 2, 1017, 136)),
    ((0, 1), (3, 1), (1, 185, 489, 340)),
    ((3, 1), (3, 1), (505, 178, 839, 292)),
    ((6, 0), (1, 3), (840, 174, 994, 626)),
    ((0, 2), (1, 1), (6, 405, 160, 558)),
    ((1, 2), (2, 1), (175, 454, 491, 545)),
    ((3, 2), (2, 2), (510, 345, 803, 613)),
    ((5, 2), (1, 1), (4, 663, 169, 725)),
    ((6, 3), (1, 1), (222, 667, 282, 740)),
    ((7, 3), (1, 1), (355, 675, 449, 729)),
]

for atlas_pos, footprint, box in items:
    x, y = atlas_pos
    fw, fh = footprint
    crop = source.crop(box)
    target_w = fw * 64
    target_h = fh * 64
    crop = crop.resize((target_w, target_h), Image.Resampling.LANCZOS)
    out.alpha_composite(crop, (x * 64, y * 64))

out.save(root / "terrain_tileset_grid_64_v2.png")
print(root / "terrain_tileset_grid_64_v2.png")
