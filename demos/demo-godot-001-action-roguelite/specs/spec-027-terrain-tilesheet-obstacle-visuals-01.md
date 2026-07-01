# Spec 027：地形 Tilesheet 接入硬阻挡

## 背景

已获得 `terrain_tilesheet_1024.png`，并按实际图像生成 `terrain-tilesheet-atlas.md`。当前硬阻挡仍使用 `ColorRect`，视觉语义弱。

## 目标

- 将当前硬阻挡视觉从 `ColorRect` 替换为 tilesheet atlas 图块。
- 碰撞、投射物阻挡、导航挖洞逻辑保持不变。
- 不改房间流程和敌人逻辑。

## 方案

- 在 `main.gd` preload `terrain_tilesheet_1024.png`。
- 新增 atlas 坐标常量。
- `_create_obstacle()` 根据 `kind` 选择 atlas 区域：
  - `toolbox` → `toolbox_center`
  - `woodpile` → `woodpile_center`
  - `toybox_edge` → `toybox_panel_gold`
  - `block` → `block_center`
- 使用 `Sprite2D.region_enabled = true` 和 `region_rect` 裁切。
- 按障碍 `size` 缩放到碰撞尺寸附近。
- 对工具盒增加锁扣/把手 overlay。
- 对玩具箱边缘增加 rim highlight overlay。

## 验证

- smoke test 通过。
- 手测验证硬阻挡视觉变为图片资源，碰撞/导航不变。
