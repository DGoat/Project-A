from PIL import Image
from pathlib import Path

root = Path(r"D:\FORK\specskill\Project-A\demos\demo-godot-001-action-roguelite\assets\art\toy_repair_prototype\terrain_tiles")
raw_root = root / "raw"
out = Image.new("RGBA", (640, 320), (0, 0, 0, 0))

items = [
    ((0, 4), (2, 1), Image.open(raw_root / "terrain_plank_left_raw.png").convert("RGBA"), "fit"),
    ((2, 4), (2, 1), Image.open(raw_root / "terrain_plank_mid_raw.png").convert("RGBA"), "stretch"),
    ((4, 4), (2, 1), Image.open(raw_root / "terrain_plank_right_raw.png").convert("RGBA"), "fit"),
]

def trim_alpha(image: Image.Image) -> Image.Image:
    alpha_bbox = image.getchannel("A").getbbox()
    if alpha_bbox is None:
        return image
    alpha_pixels = image.load()
    mask_bbox = None
    for y in range(alpha_bbox[1], alpha_bbox[3]):
        for x in range(alpha_bbox[0], alpha_bbox[2]):
            r, g, b, a = alpha_pixels[x, y]
            if a > 40 and not (r > 235 and g > 235 and b > 235) and not (b > r * 1.15 and b > g * 1.05):
                if mask_bbox is None:
                    mask_bbox = [x, y, x + 1, y + 1]
                else:
                    mask_bbox[0] = min(mask_bbox[0], x)
                    mask_bbox[1] = min(mask_bbox[1], y)
                    mask_bbox[2] = max(mask_bbox[2], x + 1)
                    mask_bbox[3] = max(mask_bbox[3], y + 1)
    if mask_bbox is None:
        return image.crop(alpha_bbox)
    return image.crop(tuple(mask_bbox))

for atlas_pos, footprint, image, mode in items:
    x, y = atlas_pos
    fw, fh = footprint
    crop = trim_alpha(image)
    target_w = fw * 64
    target_h = fh * 64
    if mode == "stretch":
        crop = crop.resize((target_w, target_h), Image.Resampling.LANCZOS)
    else:
        crop.thumbnail((target_w, target_h), Image.Resampling.LANCZOS)
    tile = Image.new("RGBA", (target_w, target_h), (0, 0, 0, 0))
    tile.alpha_composite(crop, ((target_w - crop.width) // 2, (target_h - crop.height) // 2))
    out.alpha_composite(tile, (x * 64, y * 64))

out.save(root / "terrain_tileset_grid_64_v2.png")
print(root / "terrain_tileset_grid_64_v2.png")
