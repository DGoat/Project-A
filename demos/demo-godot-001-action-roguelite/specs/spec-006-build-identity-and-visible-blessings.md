# Spec: M3 现有祝福表现强化

## 背景

M2 已验收通过，Demo 已从“能跑”推进到“能打”。

M3 目标是让祝福不只是数值变化，而是玩家在下一房间能立刻感到战斗方式发生变化。

当前已有 6 个祝福：

| ID | 名称 | 当前效果 | 问题 |
|---|---|---|---|
| `attack_up` | Sharpened Edge | 攻击伤害 +20% | 数值变化不可见 |
| `attack_speed_up` | Quick Hands | 攻击冷却 -15% | 变化偏弱，缺少提示 |
| `dash_strike` | Wind Step | Dash 后下一击 +50% | 是否已充能不明显 |
| `kill_heal` | Blood Warmth | 击杀回血 8 | 回血缺少明确反馈 |
| `burn_attack` | Ember Mark | 攻击附加燃烧 | 只有闪色，缺少持续感 |
| `range_up` | Long Reach | 攻击范围 +20% | 只改变攻击位置，未同步矩形长度 |

## 目标

- 保留现有 6 个祝福，不新增祝福池规模。
- 让每个祝福至少有一个可观察表现。
- 优先强化战斗中可见反馈。
- 让 `range_up` 同步改变矩形攻击提示和实际判定长度。
- 让 `dash_strike` 有明确充能/消耗提示。
- 让 `burn_attack` 的持续伤害更容易被看到。
- 让 `kill_heal` 回血更明确。

## 非目标

- 不做完整粒子系统。
- 不做最终美术特效。
- 不新增 Boss。
- 不做复杂 Buff UI。
- 不做祝福稀有度。
- 不做新的房间事件系统。
- 不做音效。

## 设计方案

### 1. 攻击范围可成长

当前：

```gdscript
attack_range *= multiplier
```

只会让攻击区域离玩家更远，但矩形本身长度不变。

调整为：

- 增加 `attack_length`。
- `range_up` 同时扩大：
  - `attack_length`
  - `AttackArea/CollisionShape2D.shape.size.x`
  - `AttackPreview.polygon`
- 攻击区域中心位置根据长度重新计算。

建议初始值：

```gdscript
var attack_length := 50.0
var attack_width := 36.0
```

攻击位置：

```gdscript
attack_area.position = facing * (attack_length * 0.5 + 10.0)
```

矩形视觉：

```text
(-8, -18) -> (attack_length - 8, 18)
```

### 2. Dash Strike 充能提示

当前：

- Dash 后设置 `dash_strike_ready = true`。
- 下一次攻击消耗。
- 玩家难以确认是否已充能。

调整：

- Dash Strike 充能时，玩家主体改为偏蓝/青色描边式占位表现。
- 下一击命中后恢复普通颜色。
- 如果没有 `dash_strike` 祝福，不显示该提示。

短期不用新增 UI，只改 `Body.modulate`。

### 3. Burn 持续表现

当前：

- burn tick 时橙色闪色。

调整：

- 被燃烧敌人在 burn 持续期间保持轻微橙色 tint。
- tick 时加深橙色闪色。
- burn 结束后恢复原本颜色。

不新增火焰粒子，避免 M3 范围膨胀。

### 4. Kill Heal 回血提示

当前：

- 击杀后回血，血条变化可见但不够明确。

调整：

- 回血时玩家主体短暂绿色亮闪。
- 保留头顶血条变化。

短期不做飘字。

### 5. Attack Up / Attack Speed Up 轻量反馈

这两个祝福偏数值，M3 起步先做选择后的即时反馈：

- 选择 `attack_up` 后，下一次攻击提示颜色更深。
- 选择 `attack_speed_up` 后，攻击提示持续时间略短，体现出手更快。

如果实现复杂，允许只保留为后续 M3.2。

## 涉及文件

| 文件 | 改动 |
|---|---|
| `scripts/player.gd` | 增加攻击长度/宽度变量，更新 Blessing 表现逻辑 |
| `scenes/Player.tscn` | 攻击矩形 shape 保持矩形，允许脚本动态调整 |
| `scripts/melee_enemy.gd` | 燃烧期间 tint 表现 |
| `scripts/ranged_enemy.gd` | 燃烧期间 tint 表现 |
| `data/blessings.json` | 如需调整描述，保持与表现一致 |
| `milestones.md` | M3 进度更新 |
| `issue-tracker.md` | 更新 `BUILD-001`，新增必要 M3 问题 |
| `dev-log.md` | 记录实现过程 |

## 验收标准

- [ ] `range_up` 后，攻击矩形显示长度变长。
- [ ] `range_up` 后，实际命中判定长度同步变长。
- [ ] Dash Strike 充能状态可见。
- [ ] Dash Strike 命中后充能提示消失。
- [ ] 燃烧敌人在持续期间有橙色状态感。
- [ ] 燃烧 tick 不触发 knockback。
- [ ] Kill Heal 触发时有回血闪色。
- [ ] 现有 3 房间流程仍可通关。
- [ ] Godot 运行无脚本错误。

## 风险

| 风险 | 影响 | 应对 |
|---|---|---|
| 动态修改 Shape 影响所有实例 | 攻击判定异常 | Player 只有一个实例，可接受；如后续多玩家再复制 Shape |
| 颜色反馈互相覆盖 | 读不清状态 | 优先级：受伤 > Dash Strike > 回血 > 普通 |
| Burn tint 和受击闪色冲突 | 反馈混乱 | tick 闪色结束后恢复 burn tint，而非普通色 |
| Range Up 过强 | 难度下降 | 先保持 +20%，只修表现一致 |

## 实施步骤

1. 修改 `player.gd`：
   - 增加 `attack_length` / `attack_width`。
   - 增加 `_update_attack_shape()`。
   - `range_up` 调整长度并刷新矩形 shape / preview。
2. 修改 `player.gd`：
   - Dash Strike 充能时更新玩家颜色。
   - 命中消耗后恢复颜色。
   - 回血时短暂绿色闪色。
3. 修改敌人脚本：
   - burn 持续期间保持橙色 tint。
   - tick 时加深闪色。
4. 更新文档：
   - `milestones.md`
   - `issue-tracker.md`
   - `dev-log.md`
5. 用户复测 M3 手感。

## 回滚方案

如果表现混乱：

1. 保留 `range_up` 判定同步修复。
2. 回滚颜色状态叠加。
3. 将 Dash Strike / Burn / Kill Heal 表现拆成独立 M3 小任务逐个推进。
