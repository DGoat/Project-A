# Spec 031：三段式地形资源规范

## 背景

当前 TileMapLayer 更适合用规则 tile 摆放。已有 atlas 资源更像独立物件，拉伸后观感不稳定。下一批地形资源应改为模块化拼接资源。

## 目标

- 支持横向长条地形拼接：左端、中段、右端。
- 中段可重复平铺。
- 尽量支持 90° 旋转复用为竖向拼接。
- 资源优先服务编辑器 TileMapLayer 摆放。

## 推荐规格

- 单 tile：`64x64 px`。
- 透明 PNG。
- 每组 3 个 tile：
  - `left`
  - `mid`
  - `right`
- `mid` 必须能横向无缝重复。
- 边缘不要跨出格子。
- 阴影不要越界。
- 光照尽量均匀，便于旋转复用。

## 推荐资源组

- `terrain_toolbox_left/mid/right`
- `terrain_woodpile_left/mid/right`
- `terrain_toybox_edge_left/mid/right`
- `terrain_glue_strip_left/mid/right`
- `terrain_cloth_strip_left/mid/right`
- `terrain_track_left/mid/right`

## 后续接入方式

- 将三段式 tile 放入 `terrain_tileset_grid_64.png` 或新 tileset。
- 在编辑器中用 TileMapLayer 摆放：
  - 开头放 left。
  - 中间重复 mid。
  - 末尾放 right。
- 需要竖向时，优先使用 TileMap brush 旋转 90°。

## 限制

- 如果某类资源有明显方向性，例如工具盒把手、锁扣、固定投影，则不建议旋转复用。
- 这类需要单独生成竖向版本：`top/mid/bottom`。
