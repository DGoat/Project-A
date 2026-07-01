# Spec 026：地形拼接图片资源规范 0.1

## 背景

当前硬阻挡区使用 `ColorRect` 无资源绘制，功能清楚，但视觉上不够直观。后续应引入一组可拼接图片资源，用少量规则形状 tile 拼出工具盒、木块堆、玩具箱边缘等地形。

## 目标

- 一组图片能拼凑多种规则形状硬地形。
- 支持矩形、长条、L 形、U 形等简单组合。
- 资源语义清楚：边、角、中心、装饰件。
- 尺寸统一，方便 Godot 中按网格拼接。
- 暂不接入代码，先定义资源规格和生成 prompt。

## 推荐规格

- 推荐生成：单张 `1024x1024 px` tilesheet。
- 网格：`16x16`。
- 单 tile：`64x64 px`。
- 输出格式：透明背景 PNG。
- 视角：2D 顶视 / 轻微俯视。
- 风格：童话治愈、玩具修理屋、手绘绘本、暖木色、柔和边缘。
- 明暗：顶部略亮，底部/右侧略暗，便于拼接后有体积感。
- 边缘：不要强透视，不要明显投影越界，避免拼接断层。

## 推荐文件

- `terrain_tilesheet_1024.png`：所有地形组件放在同一张 1024x1024 图上。
- `docs/terrain-tilesheet-1024-prompt.md`：中英对照生成 prompt 与切图坐标表。

## Tile 组合

### 通用九宫格硬阻挡

用于拼任意矩形障碍。

| 文件名 | 说明 |
|---|---|
| `terrain_block_center.png` | 中心块，可重复平铺 |
| `terrain_block_edge_top.png` | 上边 |
| `terrain_block_edge_bottom.png` | 下边 |
| `terrain_block_edge_left.png` | 左边 |
| `terrain_block_edge_right.png` | 右边 |
| `terrain_block_corner_tl.png` | 左上角 |
| `terrain_block_corner_tr.png` | 右上角 |
| `terrain_block_corner_bl.png` | 左下角 |
| `terrain_block_corner_br.png` | 右下角 |

### 主题装饰覆盖件

用于让同一套基础 tile 变成不同地形。

| 文件名 | 说明 |
|---|---|
| `terrain_overlay_toolbox_latch.png` | 工具盒金属扣/锁扣 |
| `terrain_overlay_toolbox_handle.png` | 工具盒把手 |
| `terrain_overlay_wood_slats.png` | 木块堆横向木纹/分隔 |
| `terrain_overlay_toybox_rim.png` | 玩具箱边缘高光条 |
| `terrain_overlay_screw_heads.png` | 螺丝/钉头点缀 |

### 可选主题底块

如果想让主题差异更明显，可额外做三套中心块。

| 文件名 | 说明 |
|---|---|
| `terrain_toolbox_center.png` | 红棕工具盒主体 |
| `terrain_woodpile_center.png` | 木块堆主体 |
| `terrain_toybox_center.png` | 玩具箱边缘主体 |

## 推荐目录

```text
res://assets/art/toy_repair_prototype/terrain_tiles/
```

## 接入思路

后续代码可新增 `TiledObstacle` 生成函数：

- 输入：`pos`、`grid_size`、`kind`、`pattern`。
- 碰撞：仍用一个 `RectangleShape2D` 或多个矩形碰撞。
- 视觉：根据宽高按九宫格铺 tile。
- 导航：仍按碰撞矩形给 `NavigationPolygon` 挖洞。

## 生成要求

- 每张图片必须是独立 PNG。
- 透明背景。
- 不要包含文字。
- 不要包含人物、动物、复杂场景。
- 单张 tile 不要自带大阴影，避免拼接重复脏边。
- 边缘能无缝或近似无缝拼接。
