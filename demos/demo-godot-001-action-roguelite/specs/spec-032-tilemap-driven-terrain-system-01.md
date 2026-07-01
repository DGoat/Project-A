# Spec 032：TileMap 驱动地形系统

## 背景

当前存在两套地形：

- 代码中的 `room_maps.obstacles/glue` 运行时生成。
- 编辑器中的 `ManualTerrainRoom1/2/3` TileMapLayer。

这导致运行时出现重复地形。后续地图应以 TileMap 为唯一来源：先定义 tile 的地形属性，再摆到地图上，运行时按属性生成逻辑。

## 目标

- 删除旧 `room_maps` 运行时地形生成路径。
- 保留边界提示。
- 从当前房间 `ManualTerrainRoomX` 读取 tile。
- 根据 tile 类型生成：
  - 硬障碍：阻挡玩家/敌人/投射物，并参与导航挖洞。
  - 减速区：Area2D，进入后减速。
  - 可破坏物：预留接口，当前先按硬障碍处理或无效果。
- 图片展示由 TileMapLayer 自身负责。

## Tile 类型初版

Tile 属性定义在 `scripts/main.gd` 的 `terrain_tile_properties` 中，key 使用 TileSet atlas 坐标，例如 `Vector2i(0, 0)`。

```gdscript
Vector2i(0, 0): {"type": "hard", "footprint": Vector2i(1, 1)}
```

- `type`：逻辑属性，当前支持 `hard` / `slow` / `decor`。
- `footprint`：该图片占地格子大小，单位是 TileMap 格子数，例如 `Vector2i(3, 1)` 表示横向占 3 格、纵向占 1 格。

图片与 atlas 坐标的对应关系定义在 `assets/art/toy_repair_prototype/terrain_tiles/terrain_tileset_grid_64.tres`，当前使用 `terrain_tileset_grid_64.png`，每格 `64x64`。

当前 `terrain_tileset_grid_64.png` tile 坐标：

| atlas coords | 属性 | 说明 |
|---|---|---|
| `(0,0)` | `hard` | 普通木块 |
| `(1,0)` | `hard` | 工具盒 |
| `(2,0)` | `hard` | 木板堆 |
| `(3,0)` | `hard` | 玩具箱面板 |
| `(0,1)` | `decor` | 高光条 |
| `(1,1)` | `decor` | 锁扣 |
| `(2,1)` | `decor` | 把手 |
| `(3,1)` | `hard` | 深色面板 |

后续新资源加入后再扩展：

- `slow`
- `breakable`
- `spring`
- `track`

## 已实现

- `_spawn_room_map()` 不再读取 `room_maps.obstacles/glue` 生成旧地形。
- `ManualTerrainRoomX` 是运行时地形唯一来源。
- `terrain_tile_properties` 定义 tile 属性。
- `hard` tile 生成 `TileTerrainBody`，位于 terrain layer `8`，阻挡玩家、敌人、投射物。
- `slow` tile 已预留并复用胶水减速 Area2D 创建逻辑。
- 导航洞改为根据 TileMap 硬地形连通块生成，避免逐格轮廓互相重叠。
- TileMapLayer 继续负责地形图片显示。

## 验证

- smoke test 检查不再生成旧 `Obstacle` 节点。
- smoke test 检查 TileMap 硬障碍会生成 `TileTerrainBody`。
- smoke test 检查 NavigationRegion2D 仍存在。
- `AI_TEST_PASS`。
