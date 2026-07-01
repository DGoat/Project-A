# 每房间 TileMapLayer 地形摆放说明

## 层级

`Main.tscn` 中现在有三个编辑器摆放层：

```text
Main
└── MapRoot
    ├── ManualTerrainRoom1
    ├── ManualTerrainRoom2
    └── ManualTerrainRoom3
```

## 房间归属

- 画在 `ManualTerrainRoom1`：只在房间 1 显示。
- 画在 `ManualTerrainRoom2`：只在房间 2 显示。
- 画在 `ManualTerrainRoom3`：只在房间 3 显示。

运行时 `_spawn_room_map(index)` 会自动显示当前房间对应层，并隐藏其他房间层。

## 编辑器可见性

三个 `ManualTerrainRoomX` 在编辑器里默认都可见，方便你随时选中任意房间层编辑。

运行时才会按当前房间自动切换显示：只显示当前房间层，隐藏其他层。

如果你在编辑器里手动把某个房间层隐藏，TileMap 编辑器会提示“正在编辑的图层已禁用或已隐藏”，此时需要重新点开该层左侧眼睛图标。

## 如何摆放

1. 打开 `res://scenes/Main.tscn`。
2. 选中目标房间层，例如 `MapRoot/ManualTerrainRoom2`。
3. 在 Godot 底部 TileMap 编辑面板中选择 tile。
4. 在 2D 视图点击或拖拽绘制。

## 移动

- 移动单个 tile：擦掉后在新格子重画。
- 批量移动：在 TileMap 编辑工具中框选后移动。
- 整层移动：移动 `ManualTerrainRoomX` 节点本身。

## 旋转 / 翻转

使用 Godot TileMap 编辑器中的 brush transform：

- 旋转 brush。
- 水平翻转。
- 垂直翻转。

不同 Godot 布局里按钮位置可能不同，一般在 TileMap 面板或 2D 顶部工具栏附近。

## 已同步的测试地形

当前已把 `room_maps` 中测试用的硬阻挡近似同步到三个 `ManualTerrainRoomX` 层里。

- 房间 1：木板堆、工具盒。
- 房间 2：普通木块、木板堆、玩具箱面板。
- 房间 3：木板堆、普通木块、工具盒、玩具箱面板。

同步脚本：

```text
res://tools/sync_manual_terrain_layers.gd
```

需要重新同步时运行：

```bat
"C:\Users\wb.zhanghuaxia02\AppData\Local\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7-stable_win64_console.exe" --headless --path "D:\FORK\specskill\Project-A\demos\demo-godot-001-action-roguelite" --script "res://tools/sync_manual_terrain_layers.gd"
```

## 当前限制

- 这三层目前是视觉层。
- 不自动生成碰撞和导航阻挡。
- 真正阻挡仍由 `room_maps.obstacles` 控制。

## 下一步建议

如果要“编辑器里摆放后就能阻挡”，下一步做：

- 读取当前房间的 `ManualTerrainRoomX.get_used_cells()`。
- 按 tile cell 生成 `StaticBody2D`。
- 给导航区域挖洞。
- 投射物、玩家、敌人都按生成的碰撞阻挡。
