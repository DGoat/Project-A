# Terrain Tilesheet Atlas：`terrain_tilesheet_1024_3.png`

图片路径：`res://assets/art/toy_repair_prototype/terrain_tiles/terrain_tilesheet_1024_3.png`

## 图片信息

- 尺寸：`1024x1024`
- 模式：`RGBA`
- 背景：真实透明，空白区域 alpha=0。
- 划区方式：按实际 alpha 连通区域手动划区，不使用固定 16x16 网格切图。

## Atlas 区域表

坐标格式：`x, y, w, h`，单位 px。

| 名称 | x | y | w | h | 用途 |
|---|---:|---:|---:|---:|---|
| `block_corner_tl` | 18 | 15 | 108 | 107 | 通用硬阻挡左上角 |
| `block_edge_top` | 152 | 15 | 135 | 107 | 通用硬阻挡上边 |
| `block_corner_tr` | 312 | 15 | 109 | 107 | 通用硬阻挡右上角 |
| `block_edge_left` | 18 | 139 | 107 | 122 | 通用硬阻挡左边 |
| `block_center` | 152 | 137 | 135 | 125 | 通用硬阻挡中心 |
| `block_edge_right` | 313 | 139 | 107 | 122 | 通用硬阻挡右边 |
| `block_corner_bl` | 18 | 277 | 108 | 108 | 通用硬阻挡左下角 |
| `block_edge_bottom` | 152 | 277 | 135 | 107 | 通用硬阻挡下边 |
| `block_corner_br` | 313 | 277 | 108 | 108 | 通用硬阻挡右下角 |
| `toolbox_center` | 8 | 432 | 190 | 170 | 工具盒主体 |
| `woodpile_center` | 213 | 434 | 184 | 160 | 木板堆主体 |
| `toybox_panel_light` | 425 | 423 | 178 | 182 | 浅色玩具箱面板 |
| `toybox_panel_gold` | 631 | 422 | 184 | 187 | 金色玩具箱面板 |
| `wood_plank_vertical` | 443 | 619 | 141 | 199 | 竖向木板 |
| `rim_highlight` | 616 | 643 | 208 | 36 | 玩具箱边缘高光条 |
| `toolbox_latch` | 63 | 665 | 77 | 98 | 工具盒锁扣 |
| `toolbox_handle` | 236 | 687 | 141 | 62 | 工具盒把手 |
| `small_screw_cross` | 870 | 698 | 39 | 38 | 小十字螺丝 |
| `small_screw_plus` | 943 | 698 | 39 | 39 | 小圆加号螺丝 |
| `gear_patch` | 680 | 880 | 83 | 83 | 齿轮/发条贴片 |
| `button_round` | 897 | 893 | 58 | 57 | 圆纽扣 |

## 接入建议

- 可替换当前 `terrain_tilesheet_1024.png`。
- 本图没有胶水/棋盘布片区域，适合硬阻挡和装饰件，不适合胶水坑。
- 仍不是严格 64x64 网格，必须使用本 atlas 坐标。
