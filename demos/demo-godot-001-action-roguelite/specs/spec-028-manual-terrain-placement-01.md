# Spec 028：手动摆放地形配置 0.1

## 背景

当前硬阻挡由 `room_maps.obstacles` 按矩形数据生成。后续用户希望自己摆放地形，因此需要功能上支持“手动摆放”：明确位置、尺寸、视觉类型、碰撞类型。

## 目标

- 先切回 `terrain_tilesheet_1024.png`。
- 支持在代码内配置手动摆放地形。
- 每个摆放项可独立选择视觉、位置、尺寸、是否阻挡、是否影响导航。
- 保留当前房间硬阻挡表现和导航逻辑。

## 方案

- 继续使用 `room_maps.obstacles`，扩展字段语义：
  - `pos`: 世界坐标中心点。
  - `size`: 碰撞/导航矩形尺寸。
  - `kind`: 视觉类型。
  - `atlas`: 可选，直接指定 atlas key。
  - `blocks`: 是否创建 `StaticBody2D` 碰撞，默认 true。
  - `nav_block`: 是否在导航中挖洞，默认 true。
- 新增辅助函数：
  - `_get_obstacle_atlas_key(data)`。
  - `_create_manual_terrain(data)`。
- 当前先不拆 JSON，不引入编辑器插件。

## 验证

- smoke test 通过。
- 手测可通过调整 `room_maps` 中坐标和尺寸摆放地形。
