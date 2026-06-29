# Spec 018：主角动作资源接入 Animation 0.2

## 背景

主角动作资源已放入：

```text
assets/art/toy_repair_prototype/player_actions/
```

资源命名已与 `spec-017-player-action-assets-01.md` 对齐：

- `player_idle.png`
- `player_walk_lean.png`
- `player_attack_pose.png`
- `player_hurt_pose.png`
- `player_down_pose.png`

本轮将这些单张动作姿态接入当前主角脚本，替代纯粹 bob/缩放伪动画。

## 本轮目标

1. 默认状态使用 `player_idle.png`。
2. 移动时切换到 `player_walk_lean.png`。
3. 攻击时短暂切换到 `player_attack_pose.png`。
4. 受击时短暂切换到 `player_hurt_pose.png`。
5. 死亡时切换到 `player_down_pose.png`。
6. 保留现有攻击木尺、Dash 残影、受击抖动、血条逻辑。

## 非目标

- 不做多帧动画。
- 不做 8 方向 Sprite。
- 不改碰撞判定。
- 不改攻击数值。

## 实现方案

### Player.tscn

将 `Body` 默认贴图改为：

```text
res://assets/art/toy_repair_prototype/player_actions/player_idle.png
```

### player.gd

新增 preload：

```gdscript
var idle_texture := preload(...)
var walk_texture := preload(...)
var attack_texture := preload(...)
var hurt_texture := preload(...)
var down_texture := preload(...)
```

新增状态：

```gdscript
var action_pose_time := 0.0
var action_pose_locked := false
```

行为：

- 攻击：设置 attack pose，持续约 `0.18s`。
- 受击：设置 hurt pose，持续约 `0.16s`。
- 死亡：设置 down pose 并锁定，不再回到 idle/walk。
- 普通移动：根据速度在 idle/walk 之间切换。

## 验收标准

1. 主角站立使用 idle 图。
2. 主角移动时能看到 walk lean 图。
3. 攻击时主角姿态明显变化。
4. 受击时主角姿态明显变化。
5. 死亡时切换为倒下图。
6. `tests/smoke_test.gd` 输出 `AI_TEST_PASS`。
