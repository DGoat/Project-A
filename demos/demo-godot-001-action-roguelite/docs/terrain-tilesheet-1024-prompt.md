# 地形 Tilesheet 生成 Prompt（1024x1024 / 16x16）

## 生成规格

- 文件名：`terrain_tilesheet_1024.png`
- 尺寸：`1024x1024 px`
- 网格：`16x16`
- 单格：`64x64 px`
- 背景：透明
- 风格：童话治愈、玩具修理屋、手绘绘本、暖色、柔和圆角
- 要求：每个 tile 必须严格对齐 64x64 网格，不要跨格，不要文字，不要角色，不要背景，不要大投影越界

## 通用生成 Prompt

中文：

```text
生成一张 1024x1024 px 的透明背景 PNG tilesheet，文件名 terrain_tilesheet_1024.png。画面必须严格划分为 16x16 网格，每个格子是 64x64 px。用于 2D 顶视、轻微俯视视角的童话治愈风玩具修理屋游戏。所有 tile 都是手绘绘本风格，暖色，上漆木头、黄铜小配件、玩具修理屋材料，柔和圆角，轮廓清晰。每个 tile 必须完整位于自己的 64x64 格子内，不要跨格，不要文字，不要角色，不要背景，不要在格子外产生明显投影。请按下面的网格布局生成每个 tile。
```

English:

```text
Create a 1024x1024 px transparent PNG tilesheet named terrain_tilesheet_1024.png. The image must be strictly divided into a 16x16 grid, each cell is 64x64 px. It is for a 2D top-down with a slight three-quarter angle cozy fairy-tale toy repair workshop game. All tiles use a hand-painted storybook style, warm colors, varnished wood, brass small parts, toy repair workshop materials, soft rounded edges, readable silhouettes. Every tile must stay fully inside its own 64x64 cell, no crossing cell boundaries, no text, no characters, no background, no strong shadow outside the cell. Generate each tile according to the grid layout below.
```

## 网格布局

坐标格式：`(col,row)`，从左上角开始，`col=0..15`，`row=0..15`。

| 坐标 | 名称 | 内容 |
|---|---|---|
| (0,0) | `terrain_block_corner_tl` | 上漆木头硬阻挡左上角 |
| (1,0) | `terrain_block_edge_top` | 上漆木头硬阻挡上边 |
| (2,0) | `terrain_block_corner_tr` | 上漆木头硬阻挡右上角 |
| (0,1) | `terrain_block_edge_left` | 上漆木头硬阻挡左边 |
| (1,1) | `terrain_block_center` | 上漆木头硬阻挡中心，可无缝平铺 |
| (2,1) | `terrain_block_edge_right` | 上漆木头硬阻挡右边 |
| (0,2) | `terrain_block_corner_bl` | 上漆木头硬阻挡左下角 |
| (1,2) | `terrain_block_edge_bottom` | 上漆木头硬阻挡下边 |
| (2,2) | `terrain_block_corner_br` | 上漆木头硬阻挡右下角 |
| (4,0) | `terrain_toolbox_center` | 红棕色复古工具盒表面中心块 |
| (5,0) | `terrain_woodpile_center` | 玩具木板堆表面中心块 |
| (6,0) | `terrain_toybox_center` | 玩具箱箱沿表面中心块 |
| (4,1) | `terrain_overlay_toolbox_latch` | 居中的黄铜工具盒锁扣，透明周围 |
| (5,1) | `terrain_overlay_toolbox_handle` | 居中的深青铜工具盒把手，透明周围 |
| (6,1) | `terrain_overlay_wood_slats` | 两到三条深棕木板缝线，透明周围 |
| (7,1) | `terrain_overlay_toybox_rim` | 暖金橙色玩具箱边缘高光条，透明周围 |
| (8,1) | `terrain_overlay_screw_heads` | 两个小黄铜螺丝头，透明周围 |
| (0,4) | `terrain_shadow_soft` | 很轻的软接触阴影，用于地形底部，可选 |
| (1,4) | `terrain_highlight_strip` | 柔和暖色高光条，可叠在边缘 |
| (2,4) | `terrain_crack_line` | 细小木纹裂线，透明周围 |
| (3,4) | `terrain_tape_patch` | 小布胶带修补贴，透明周围 |
| (4,4) | `terrain_button_nail` | 小纽扣钉装饰，透明周围 |

其余格子保持完全透明，作为后续扩展预留。

## 切图坐标表

后续接入时按以下像素区域裁切，每格大小 `64x64`：

| 名称 | x | y | w | h |
|---|---:|---:|---:|---:|
| `terrain_block_corner_tl` | 0 | 0 | 64 | 64 |
| `terrain_block_edge_top` | 64 | 0 | 64 | 64 |
| `terrain_block_corner_tr` | 128 | 0 | 64 | 64 |
| `terrain_block_edge_left` | 0 | 64 | 64 | 64 |
| `terrain_block_center` | 64 | 64 | 64 | 64 |
| `terrain_block_edge_right` | 128 | 64 | 64 | 64 |
| `terrain_block_corner_bl` | 0 | 128 | 64 | 64 |
| `terrain_block_edge_bottom` | 64 | 128 | 64 | 64 |
| `terrain_block_corner_br` | 128 | 128 | 64 | 64 |
| `terrain_toolbox_center` | 256 | 0 | 64 | 64 |
| `terrain_woodpile_center` | 320 | 0 | 64 | 64 |
| `terrain_toybox_center` | 384 | 0 | 64 | 64 |
| `terrain_overlay_toolbox_latch` | 256 | 64 | 64 | 64 |
| `terrain_overlay_toolbox_handle` | 320 | 64 | 64 | 64 |
| `terrain_overlay_wood_slats` | 384 | 64 | 64 | 64 |
| `terrain_overlay_toybox_rim` | 448 | 64 | 64 | 64 |
| `terrain_overlay_screw_heads` | 512 | 64 | 64 | 64 |
| `terrain_shadow_soft` | 0 | 256 | 64 | 64 |
| `terrain_highlight_strip` | 64 | 256 | 64 | 64 |
| `terrain_crack_line` | 128 | 256 | 64 | 64 |
| `terrain_tape_patch` | 192 | 256 | 64 | 64 |
| `terrain_button_nail` | 256 | 256 | 64 | 64 |

## 负面约束

中文：

```text
不要九宫格错位，不要跨格绘制，不要把多个 tile 混在一个格子，不要生成文字或编号，不要生成角色，不要生成背景，不要强透视，不要强投影，不要让边缘 tile 和中心 tile 材质不一致。
```

English:

```text
Do not misalign the grid, do not draw across cell boundaries, do not mix multiple tiles in one cell, do not generate text or numbers, do not generate characters, do not generate a background, no strong perspective, no strong cast shadows, do not make edge tiles visually inconsistent with the center tile.
```
