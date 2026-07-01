# 手动摆放地形配置说明

当前先采用“代码内配置”方式，不引入 JSON。

配置位置：`scripts/main.gd` 的 `room_maps`。

## 基础字段

```gdscript
{
	"pos": Vector2(1600, 700),
	"size": Vector2(180, 120),
	"kind": "toolbox"
}
```

| 字段 | 类型 | 说明 |
|---|---|---|
| `pos` | `Vector2` | 地形中心点世界坐标 |
| `size` | `Vector2` | 碰撞矩形尺寸，也是视觉缩放目标尺寸 |
| `kind` | `String` | 视觉类型 |
| `atlas` | `String` | 可选，直接指定 atlas key，优先级高于 `kind` |
| `blocks` | `bool` | 可选，是否创建碰撞，默认 `true` |
| `nav_block` | `bool` | 可选，是否在导航区域挖洞，默认 `true` |

## 当前支持的 `kind`

| kind | 默认 atlas | 说明 |
|---|---|---|
| `block` | `block_center` | 普通木质硬阻挡 |
| `toolbox` | `toolbox_center` | 工具盒主体，自动叠加锁扣和把手 |
| `woodpile` | `woodpile_center` | 木板堆主体 |
| `toybox_edge` | `toybox_panel_gold` | 玩具箱边缘主体，自动叠加高光条 |

## 当前支持的 atlas key

| atlas key | 说明 |
|---|---|
| `block_center` | 普通木质块 |
| `toolbox_center` | 工具盒主体 |
| `woodpile_center` | 木板堆主体 |
| `toybox_panel_gold` | 金色玩具箱面板 |
| `rim_highlight` | 高光条 |
| `toolbox_latch` | 工具盒锁扣 |
| `toolbox_handle` | 工具盒把手 |

## 示例：硬阻挡

```gdscript
{"pos": Vector2(1450, 640), "size": Vector2(180, 120), "kind": "woodpile"}
```

效果：

- 有视觉。
- 阻挡玩家/敌人/投射物。
- 导航挖洞，敌人绕行。

## 示例：只显示装饰，不阻挡

```gdscript
{
	"pos": Vector2(1700, 520),
	"size": Vector2(80, 80),
	"kind": "block",
	"atlas": "block_center",
	"blocks": false,
	"nav_block": false
}
```

效果：

- 只显示 Sprite。
- 不产生碰撞。
- 不影响导航。

## 当前限制

- 当前图片仍是“独立物件 atlas”，不是严格 64x64 拼接 tileset。
- 适合手动摆放完整物件，不适合无缝拼 L 形 / U 形。
- 若要真正拼规则形状，需要新资源严格九宫格 tile。
