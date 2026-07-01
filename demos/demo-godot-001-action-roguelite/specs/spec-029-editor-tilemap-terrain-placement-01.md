# Spec 029：编辑器 TileMapLayer 地形摆放

## 背景

用户希望在 Godot 编辑器中生成网格，并直接摆放图片生成地形，而不是只通过 `room_maps` 代码配置坐标。

## 目标

- 使用 Godot 内置 `TileMapLayer` / `TileSet` 支持编辑器内网格摆放。
- 先建立可用的地形 TileSet 资源和 TileMapLayer 节点。
- 保留当前运行时代码生成障碍逻辑，不立刻迁移房间数据。
- 后续可逐步从 TileMapLayer 读取 tile，生成碰撞/导航或直接使用 TileSet 碰撞。

## 关键判断

当前 `terrain_tilesheet_1024.png` 是实际 atlas 物件合集，不是严格 64x64 网格 tilesheet。Godot TileSet 更适合严格网格资源。因此先生成一个派生网格图：

- 从当前 atlas 区域裁切。
- 统一缩放进 64x64 单元格。
- 输出 `terrain_tileset_grid_64.png`。
- 再用它创建 TileSet。

## 方案

1. 生成 `terrain_tileset_grid_64.png`：
   - 4 列 x 4 行。
   - 单元格 64x64。
   - 放入常用硬阻挡视觉块。

2. 创建 `terrain_tileset_grid_64.tres`：
   - tile size 64x64。
   - atlas source 使用 `terrain_tileset_grid_64.png`。

3. 在 `Main.tscn` 添加 `ManualTerrainLayer`：
   - 类型：`TileMapLayer`。
   - 默认隐藏或空层。
   - 后续可在编辑器中直接绘制。

## 验证

- smoke test 检查 `ManualTerrainLayer` 存在。
- Godot headless 通过。
