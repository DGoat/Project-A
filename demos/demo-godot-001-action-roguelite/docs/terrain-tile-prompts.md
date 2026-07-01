# 地形拼接图片生成 Prompt（中英对照）

目录建议：`res://assets/art/toy_repair_prototype/terrain_tiles/`

## 通用要求

中文：

```text
生成一张 64x64 px 的透明背景 PNG 地形 tile，用于 2D 顶视，轻微俯视视角的童话治愈风玩具修理屋游戏。手绘绘本风格，暖木色，柔和圆角，轮廓清晰，不要文字，不要角色，不要背景，不要在 tile 外产生强投影。该 tile 必须适合基于网格拼接地形，并能与相邻 tile 无缝或近似无缝拼接。
```

English:

```text
Create a 64x64 px transparent PNG tile for a 2D top-down with a slight three-quarter angle cozy fairy-tale toy repair workshop game. Hand-painted storybook style, warm wooden colors, soft rounded edges, readable silhouette, no text, no characters, no background, no strong cast shadow outside the tile. The tile must be suitable for grid-based terrain assembly and seamless or near-seamless tiling with matching neighbor tiles.
```

## 九宫格硬阻挡 Tile

### `terrain_block_center.png`

中文：

```text
生成 terrain_block_center.png：64x64 透明背景 PNG，用作硬阻挡物的中心填充 tile。场景是温暖的玩具修理屋，材质为上漆木头，有轻微手绘笔触纹理，左上方柔和高光，不要边框，能在上下左右方向无缝重复平铺。不要文字、角色、背景。
```

English:

```text
Create terrain_block_center.png: a 64x64 transparent PNG center fill tile for a hard blocker object in a cozy toy repair workshop. Warm varnished wood material, subtle brush texture, soft highlights from top-left, no border, designed to repeat seamlessly in all directions. No text, no characters, no background.
```

### `terrain_block_edge_top.png`

中文：

```text
生成 terrain_block_edge_top.png：64x64 透明背景 PNG，用作硬阻挡物的上边缘 tile。暖木色上漆木头材质，上边有圆润凸起边沿，中部和底部区域与 terrain_block_center 匹配，上边沿有柔和手绘高光，横向可无缝拼接。不要文字、角色、背景。
```

English:

```text
Create terrain_block_edge_top.png: a 64x64 transparent PNG top edge tile for a hard blocker object. Warm varnished wood material, rounded top rim along the upper edge, center/bottom area matches terrain_block_center, soft hand-painted highlight on the top rim, seamless horizontally. No text, no characters, no background.
```

### `terrain_block_edge_bottom.png`

中文：

```text
生成 terrain_block_edge_bottom.png：64x64 透明背景 PNG，用作硬阻挡物的下边缘 tile。暖木色上漆木头材质，下边有圆润边沿，中部和上部区域与 terrain_block_center 匹配，下边缘略暗，横向可无缝拼接。不要文字、角色、背景。
```

English:

```text
Create terrain_block_edge_bottom.png: a 64x64 transparent PNG bottom edge tile for a hard blocker object. Warm varnished wood material, rounded lower rim along the bottom edge, center/top area matches terrain_block_center, slightly darker lower edge, seamless horizontally. No text, no characters, no background.
```

### `terrain_block_edge_left.png`

中文：

```text
生成 terrain_block_edge_left.png：64x64 透明背景 PNG，用作硬阻挡物的左边缘 tile。暖木色上漆木头材质，左侧有圆润竖向边沿，内部区域与 terrain_block_center 匹配，左上附近有柔和高光，纵向可无缝拼接。不要文字、角色、背景。
```

English:

```text
Create terrain_block_edge_left.png: a 64x64 transparent PNG left edge tile for a hard blocker object. Warm varnished wood material, rounded vertical rim along the left edge, inner area matches terrain_block_center, soft highlight near upper-left, seamless vertically. No text, no characters, no background.
```

### `terrain_block_edge_right.png`

中文：

```text
生成 terrain_block_edge_right.png：64x64 透明背景 PNG，用作硬阻挡物的右边缘 tile。暖木色上漆木头材质，右侧有圆润竖向边沿，内部区域与 terrain_block_center 匹配，右侧略暗，纵向可无缝拼接。不要文字、角色、背景。
```

English:

```text
Create terrain_block_edge_right.png: a 64x64 transparent PNG right edge tile for a hard blocker object. Warm varnished wood material, rounded vertical rim along the right edge, inner area matches terrain_block_center, slightly darker right side, seamless vertically. No text, no characters, no background.
```

### `terrain_block_corner_tl.png`

中文：

```text
生成 terrain_block_corner_tl.png：64x64 透明背景 PNG，用作硬阻挡物的左上角 tile。圆润木质角块，上边沿和左边沿干净连接，暖色上漆木头材质，柔和手绘高光，内部区域与 terrain_block_center 匹配。不要文字、角色、背景。
```

English:

```text
Create terrain_block_corner_tl.png: a 64x64 transparent PNG top-left corner tile for a hard blocker object. Rounded wooden corner with top and left rims meeting cleanly, warm varnished wood material, soft hand-painted highlight, inner area matches terrain_block_center. No text, no characters, no background.
```

### `terrain_block_corner_tr.png`

中文：

```text
生成 terrain_block_corner_tr.png：64x64 透明背景 PNG，用作硬阻挡物的右上角 tile。圆润木质角块，上边沿和右边沿干净连接，暖色上漆木头材质，右侧略暗，内部区域与 terrain_block_center 匹配。不要文字、角色、背景。
```

English:

```text
Create terrain_block_corner_tr.png: a 64x64 transparent PNG top-right corner tile for a hard blocker object. Rounded wooden corner with top and right rims meeting cleanly, warm varnished wood material, subtle darker right side, inner area matches terrain_block_center. No text, no characters, no background.
```

### `terrain_block_corner_bl.png`

中文：

```text
生成 terrain_block_corner_bl.png：64x64 透明背景 PNG，用作硬阻挡物的左下角 tile。圆润木质角块，下边沿和左边沿干净连接，暖色上漆木头材质，下边缘略暗，内部区域与 terrain_block_center 匹配。不要文字、角色、背景。
```

English:

```text
Create terrain_block_corner_bl.png: a 64x64 transparent PNG bottom-left corner tile for a hard blocker object. Rounded wooden corner with bottom and left rims meeting cleanly, warm varnished wood material, slightly darker lower edge, inner area matches terrain_block_center. No text, no characters, no background.
```

### `terrain_block_corner_br.png`

中文：

```text
生成 terrain_block_corner_br.png：64x64 透明背景 PNG，用作硬阻挡物的右下角 tile。圆润木质角块，下边沿和右边沿干净连接，暖色上漆木头材质，右下边缘更暗，内部区域与 terrain_block_center 匹配。不要文字、角色、背景。
```

English:

```text
Create terrain_block_corner_br.png: a 64x64 transparent PNG bottom-right corner tile for a hard blocker object. Rounded wooden corner with bottom and right rims meeting cleanly, warm varnished wood material, darker lower-right edge, inner area matches terrain_block_center. No text, no characters, no background.
```

## 主题覆盖件 Prompt

### `terrain_overlay_toolbox_latch.png`

中文：

```text
生成 terrain_overlay_toolbox_latch.png：64x64 透明背景 PNG，用作玩具修理屋地形 tile 的装饰覆盖件。画一个居中的小型黄铜或旧金色金属锁扣，造型圆润，手绘风格，顶视，轻微俯视，小尺寸下也要清晰可读。透明背景，不要文字，不要角色。
```

English:

```text
Create terrain_overlay_toolbox_latch.png: a 64x64 transparent PNG decorative overlay for a toy repair workshop terrain tile. Small brass or worn-gold metal latch centered in the tile, rounded shape, hand-painted, top-down with a slight three-quarter angle, readable at small size. Transparent background, no text, no characters.
```

### `terrain_overlay_toolbox_handle.png`

中文：

```text
生成 terrain_overlay_toolbox_handle.png：64x64 透明背景 PNG，用作工具盒地形 tile 的装饰覆盖件。画一个小型弧形把手或支架，深青铜金属材质，带温暖高光，居中摆放，轮廓清晰，手绘绘本风格。透明背景，不要文字，不要角色。
```

English:

```text
Create terrain_overlay_toolbox_handle.png: a 64x64 transparent PNG decorative overlay for a toolbox terrain tile. Small curved handle or bracket, dark bronze metal with warm highlight, centered, readable silhouette, hand-painted storybook style. Transparent background, no text, no characters.
```

### `terrain_overlay_wood_slats.png`

中文：

```text
生成 terrain_overlay_wood_slats.png：64x64 透明背景 PNG，装饰覆盖件，表现两到三条简单的木板缝线。使用偏深的暖棕色笔触，带轻微手绘不规则感，适合覆盖在木块堆 tile 上。透明背景，不要文字，不要角色。
```

English:

```text
Create terrain_overlay_wood_slats.png: a 64x64 transparent PNG decorative overlay showing two or three simple wooden seam lines. Warm darker brown strokes, subtle hand-painted irregularity, designed to sit over woodpile tiles. Transparent background, no text, no characters.
```

### `terrain_overlay_toybox_rim.png`

中文：

```text
生成 terrain_overlay_toybox_rim.png：64x64 透明背景 PNG，装饰覆盖件，表现明亮的玩具箱边缘高光。暖金橙色长条，柔和圆角，手绘风格，适合沿长条地形边缘重复摆放。透明背景，不要文字，不要角色。
```

English:

```text
Create terrain_overlay_toybox_rim.png: a 64x64 transparent PNG decorative overlay showing a bright toy-box rim highlight. Warm golden-orange strip, soft rounded edges, hand-painted, suitable for repeated placement along long terrain edges. Transparent background, no text, no characters.
```

### `terrain_overlay_screw_heads.png`

中文：

```text
生成 terrain_overlay_screw_heads.png：64x64 透明背景 PNG，装饰覆盖件，包含两个小螺丝头或钉头。黄铜材质，柔和高光，小尺寸下清晰可读，符合玩具修理屋氛围。透明背景，不要文字，不要角色。
```

English:

```text
Create terrain_overlay_screw_heads.png: a 64x64 transparent PNG decorative overlay with two small screw heads or nail heads. Brass material, soft highlight, readable at small size, toy repair workshop mood. Transparent background, no text, no characters.
```

## 可选主题中心块 Prompt

### `terrain_toolbox_center.png`

中文：

```text
生成 terrain_toolbox_center.png：64x64 透明背景 PNG，无缝中心 tile，用于红棕色复古工具盒表面。童话治愈风玩具修理屋风格，柔和笔触纹理，轻微旧漆磨损感，不要明显硬边框，可无缝重复。不要文字、角色、背景。
```

English:

```text
Create terrain_toolbox_center.png: a 64x64 transparent PNG seamless center tile for a red-brown vintage toolbox surface. Cozy fairy-tale toy repair workshop style, soft brush texture, subtle worn paint, no hard border, repeats seamlessly. No text, no characters, no background.
```

### `terrain_woodpile_center.png`

中文：

```text
生成 terrain_woodpile_center.png：64x64 透明背景 PNG，无缝中心 tile，用于玩具木板堆表面。暖色天然木头，细微木纹，柔和手绘纹理，不要明显硬边框，可无缝重复。不要文字、角色、背景。
```

English:

```text
Create terrain_woodpile_center.png: a 64x64 transparent PNG seamless center tile for a toy wooden plank pile. Warm natural wood, subtle grain, soft hand-painted texture, no hard border, repeats seamlessly. No text, no characters, no background.
```

### `terrain_toybox_center.png`

中文：

```text
生成 terrain_toybox_center.png：64x64 透明背景 PNG，无缝中心 tile，用于玩具箱箱沿表面。暖蜂蜜棕色上漆木头，柔和圆润的玩具材质，轻微高光，可无缝重复。不要文字、角色、背景。
```

English:

```text
Create terrain_toybox_center.png: a 64x64 transparent PNG seamless center tile for a toy box rim surface. Warm honey-brown painted wood, soft rounded toy-like material, subtle highlight, repeats seamlessly. No text, no characters, no background.
```
