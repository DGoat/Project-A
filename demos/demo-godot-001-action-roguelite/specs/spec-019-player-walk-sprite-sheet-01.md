# Spec 019：主角 Walk Sprite Sheet 接入 0.1

## 背景

用户已上传 `player_walk_sheet.png`。检查结果：

- 路径：`assets/art/toy_repair_prototype/player_actions/player_walk_sheet.png`
- 尺寸：`1024x1024`
- 结构：`2x2` 四帧
- 单帧：`512x512`

当前移动表现是单张 `player_walk_lean.png` + 程序化摆动。本轮改为移动时播放 4 帧 walk sheet。

## 本轮目标

1. 移动时使用 `player_walk_sheet.png` 四帧循环。
2. 停止时回到 `player_idle.png`。
3. 攻击、受击、死亡姿态仍优先于 walk sheet。
4. 保留轻微 bob/scale，但降低左右踏步伪动画，避免和帧动画冲突。

## 非目标

- 不接入完整 `AnimatedSprite2D` 状态机。
- 不做 8 方向行走。
- 不调整攻击/受击/死亡贴图。

## 实现方案

继续使用当前 `Sprite2D Body`，通过设置：

```gdscript
body.texture = walk_sheet_texture
body.hframes = 2
body.vframes = 2
body.frame = walk_frame
```

停止或切姿态时恢复：

```gdscript
body.hframes = 1
body.vframes = 1
body.frame = 0
```

## 验收标准

1. 移动时能看到 4 帧循环。
2. 停止后回 idle。
3. 攻击/受击/死亡不会被 walk sheet 覆盖。
4. `tests/smoke_test.gd` 输出 `AI_TEST_PASS`。
