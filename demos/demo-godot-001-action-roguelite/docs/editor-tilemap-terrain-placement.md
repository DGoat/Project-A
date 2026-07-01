# 编辑器 TileMapLayer 地形摆放说明

## 目标

你可以在 Godot 编辑器里用网格摆放地形图片，而不是只通过代码坐标生成。

## 当前资源

已生成派生网格图：

```text
res://assets/art/toy_repair_prototype/terrain_tiles/terrain_tileset_grid_64.png
```

它来自当前 `terrain_tilesheet_1024.png` 的 atlas 区域，重新排成：

- `4x4` 网格。
- 单格 `64x64`。
- 透明背景。

TileSet：

```text
res://assets/art/toy_repair_prototype/terrain_tiles/terrain_tileset_grid_64.tres
```

场景节点：

```text
Main
└── MapRoot
    └── ManualTerrainLayer  (TileMapLayer)
```

## 怎么在编辑器里摆

1. 打开 `scenes/Main.tscn`。
2. 选中 `MapRoot/ManualTerrainLayer`。
3. 在 TileMap 编辑面板里选择 tile。
4. 在场景视图中按网格绘制。

## 当前 tile 排列

`terrain_tileset_grid_64.png` 是 4 列网格：

| 坐标 | 内容 |
|---|---|
| `(0,0)` | 普通木块 |
| `(1,0)` | 工具盒主体 |
| `(2,0)` | 木板堆主体 |
| `(3,0)` | 玩具箱面板 |
| `(0,1)` | 高光条 |
| `(1,1)` | 工具盒锁扣 |
| `(2,1)` | 工具盒把手 |
| `(3,1)` | 深色玩具箱面板 |

## 当前限制

- 现在 `ManualTerrainLayer` 只是编辑器摆放视觉层。
- 它暂时不会自动生成碰撞和导航阻挡。
- 碰撞和导航仍由 `room_maps.obstacles` 控制。

## 后续可做

下一步可以增加 TileMapLayer → 碰撞/导航转换：

- 读取 `ManualTerrainLayer.get_used_cells()`。
- 按 tile 坐标生成 `StaticBody2D` 碰撞。
- 同步给导航区域挖洞。
- 这样你在编辑器里画的 tile 就能真正阻挡玩家/敌人/投射物。
