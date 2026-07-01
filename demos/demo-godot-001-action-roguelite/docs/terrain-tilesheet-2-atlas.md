# Terrain Tilesheet Atlas：`terrain_tilesheet_1024_2_cutout_v2.png`

图片路径：`res://assets/art/toy_repair_prototype/terrain_tiles/terrain_tilesheet_1024_2_cutout_v2.png`

## 图片信息

- 尺寸：`1024x1024`
- 模式：`RGBA`
- 背景：已通过脚本去除，空白区域 alpha=0。
- 划区方式：按实际 alpha 连通区域手动划区，不使用固定 16x16 网格切图。

## Atlas 区域表

坐标格式：`x, y, w, h`，单位 px。

| 名称 | x | y | w | h | 用途 |
|---|---:|---:|---:|---:|---|
| `block_corner_tl` | 18 | 19 | 107 | 105 | 通用硬阻挡左上角 |
| `block_edge_top` | 151 | 19 | 134 | 106 | 通用硬阻挡上边 |
| `block_corner_tr` | 312 | 19 | 108 | 106 | 通用硬阻挡右上角 |
| `block_edge_left` | 18 | 142 | 106 | 122 | 通用硬阻挡左边 |
| `block_center` | 150 | 140 | 136 | 125 | 通用硬阻挡中心 |
| `block_edge_right` | 312 | 142 | 107 | 122 | 通用硬阻挡右边 |
| `block_corner_bl` | 18 | 281 | 106 | 106 | 通用硬阻挡左下角 |
| `block_edge_bottom` | 151 | 281 | 134 | 106 | 通用硬阻挡下边 |
| `block_corner_br` | 312 | 280 | 107 | 107 | 通用硬阻挡右下角 |
| `toolbox_center` | 8 | 434 | 187 | 170 | 工具盒主体 |
| `woodpile_center` | 212 | 436 | 184 | 160 | 木板堆主体 |
| `toybox_panel_dark` | 423 | 424 | 180 | 183 | 深色玩具箱面板 |
| `toybox_panel_gold` | 628 | 423 | 185 | 189 | 金色玩具箱面板 |
| `wood_plank_vertical` | 442 | 620 | 140 | 200 | 竖向木板 |
| `rim_highlight` | 614 | 644 | 207 | 36 | 玩具箱边缘高光条 |
| `toolbox_latch` | 63 | 667 | 76 | 97 | 工具盒锁扣 |
| `toolbox_handle` | 236 | 689 | 138 | 59 | 工具盒把手 |
| `small_screw_cross` | 868 | 700 | 37 | 37 | 小十字螺丝 |
| `small_screw_plus` | 941 | 700 | 38 | 38 | 小圆加号螺丝 |
| `glue_strip` | 246 | 826 | 124 | 198 | 胶水竖条 / 胶带状区域 |
| `checker_patch` | 0 | 827 | 205 | 197 | 棋盘布片 / 地面补丁 |
| `gear_patch` | 679 | 880 | 80 | 82 | 齿轮/发条贴片 |
| `button_round` | 895 | 894 | 56 | 56 | 圆纽扣 |

## 接入建议

- 当前硬阻挡可切换到本图版本，效果与第一张接近，但多了胶水/布片/齿轮/纽扣资源。
- 胶水坑第一版可使用 `glue_strip`，按胶水区域尺寸缩放并降低透明度。
- `checker_patch` 可用于未来布片软阻挡或可破坏物底图。
- 碰撞仍使用现有 Area2D / StaticBody2D，不使用图片透明区域做碰撞。
