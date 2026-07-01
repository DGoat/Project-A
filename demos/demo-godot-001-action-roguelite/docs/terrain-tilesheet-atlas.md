# Terrain Tilesheet Atlas：`terrain_tilesheet_1024.png`

图片路径：`res://assets/art/toy_repair_prototype/terrain_tiles/terrain_tilesheet_1024.png`

## 图片信息

- 尺寸：`1024x1024`
- 模式：`RGBA`
- 背景：真实透明
- 划区方式：按实际 alpha 连通区域手动划区，不使用固定 16x16 网格切图。

## Atlas 区域表

坐标格式：`x, y, w, h`，单位 px。

| 名称 | x | y | w | h | 用途 |
|---|---:|---:|---:|---:|---|
| `block_corner_tl` | 17 | 17 | 109 | 109 | 通用硬阻挡左上角 |
| `block_edge_top` | 150 | 18 | 136 | 108 | 通用硬阻挡上边 |
| `block_corner_tr` | 311 | 17 | 109 | 109 | 通用硬阻挡右上角 |
| `block_edge_left` | 18 | 138 | 108 | 126 | 通用硬阻挡左边 |
| `block_center` | 150 | 138 | 137 | 127 | 通用硬阻挡中心 |
| `block_edge_right` | 311 | 138 | 108 | 127 | 通用硬阻挡右边 |
| `block_corner_bl` | 17 | 278 | 109 | 109 | 通用硬阻挡左下角 |
| `block_edge_bottom` | 150 | 278 | 136 | 109 | 通用硬阻挡下边 |
| `block_corner_br` | 311 | 277 | 109 | 110 | 通用硬阻挡右下角 |
| `toolbox_center` | 7 | 432 | 191 | 173 | 工具盒主体 |
| `woodpile_center` | 211 | 435 | 186 | 161 | 木板堆主体 |
| `toybox_panel_dark` | 423 | 423 | 179 | 185 | 深色玩具箱面板 |
| `toybox_panel_gold` | 628 | 422 | 184 | 189 | 金色玩具箱面板 |
| `wood_plank_vertical` | 441 | 620 | 142 | 200 | 竖向木板 |
| `rim_highlight` | 614 | 643 | 207 | 37 | 玩具箱边缘高光条 |
| `toolbox_latch` | 63 | 665 | 76 | 100 | 工具盒锁扣 |
| `toolbox_handle` | 235 | 687 | 141 | 63 | 工具盒把手 |

## 接入建议

- 第一版接入可先只用主题主体：
  - `toolbox_center`
  - `woodpile_center`
  - `toybox_panel_dark` / `toybox_panel_gold`
- 九宫格区域可用于未来 tiled obstacle，但当前图块尺寸不是 64x64，需要先通过 `Sprite2D.region_rect` 裁切后按目标尺寸缩放。
- 对当前矩形硬阻挡，推荐用 `Sprite2D` 显示主体图，并按障碍 `size` 做等比或非等比缩放。
- 碰撞仍沿用当前 `RectangleShape2D`，不要用图片透明区域做碰撞。

## 注意

- 图片虽然来自 1024x1024 tilesheet，但生成结果未严格对齐 16x16 网格。
- 不建议用固定格子坐标自动切。
- 必须使用本表坐标作为 atlas 区域。
