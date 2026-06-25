# Spec: M2 基础手感强化

## 背景

M1 已完成：玩家可以完整跑通 3 个房间，完成战斗、祝福选择、房间推进和胜利流程。

当前 Demo 已经“能玩”，但还没有“好打”。主要问题：

- 命中反馈弱。
- 攻击命中后没有停顿感。
- 敌人受击没有空间反馈。
- 玩家受击反馈较弱。
- Controls/Settings 没有游戏内展示。
- 祝福选择快捷键仍使用硬编码 `KEY_1/2/3`。

M2 目标是把 Demo 从“能跑通”推进到“基础手感可接受”。

---

## 目标

- 增强攻击命中反馈。
- 增加轻量 Hit Stop。
- 增加敌人受击击退。
- 增强玩家受击反馈。
- 增加 Controls 展示入口。
- 将祝福选择按键从硬编码改为 InputMap 动作。

---

## 非目标

本次不做：

- 完整动画系统。
- 完整粒子/VFX 系统。
- 音效系统。
- 手柄支持。
- 游戏内自由改键。
- 存档/配置保存。
- 大规模 UI 框架。
- 祝福系统重构。
- 新敌人或新房间。

---

## 范围

M2 分为 4 个小块：

1. 命中反馈（Hit Feedback）
2. 击退反馈（Knockback）
3. 输入映射整理（InputMap Cleanup）
4. Controls 展示（Controls Display）

---

## 设计方案

## 1. 命中反馈（Hit Feedback）

### 当前情况

敌人受击时已有短暂变色，但反馈偏弱。

### 方案

保留现有闪色，并新增轻量 Hit Stop。

命中敌人时：

```text
敌人闪色 -> 游戏短暂停顿 -> 敌人被轻微击退
```

### Hit Stop 实现

在玩家攻击命中敌人时调用轻量停顿：

```gdscript
Engine.time_scale = 0.08
await get_tree().create_timer(0.035, true, false, true).timeout
Engine.time_scale = 1.0
```

初始参数：

| 参数 | 值 |
|---|---:|
| time_scale | 0.08 |
| duration | 0.035s |

注意：

- 时间不能太长，否则动作卡顿。
- M2 只做命中敌人时的 Hit Stop。
- 不对远程弹体命中玩家做 Hit Stop。

---

## 2. 击退反馈（Knockback）

### 当前情况

近战敌人命中玩家后会 recoil，但玩家攻击敌人时敌人不会被击退。

### 方案

敌人被玩家攻击命中后，向远离玩家方向短暂击退。

对 `melee_enemy.gd` 和 `ranged_enemy.gd` 增加统一轻量变量：

```gdscript
var knockback_time := 0.0
var knockback_direction := Vector2.ZERO
@export var knockback_speed := 220.0
@export var knockback_duration := 0.12
```

`take_damage(amount, source)` 中：

```gdscript
if source != null:
    knockback_direction = source.global_position.direction_to(global_position).normalized()
    knockback_time = knockback_duration
```

`_physics_process()` 中优先处理：

```text
如果 knockback_time > 0：执行击退
否则：执行原行为
```

### 预期效果

- 攻击敌人后敌人被推开一点。
- 玩家能更直观看到“打中了”。
- 近战黏住感继续降低。

---

## 3. 输入映射整理（InputMap Cleanup）

### 当前情况

祝福选择在 `main.gd` 中使用：

```gdscript
Input.is_key_pressed(KEY_1)
Input.is_key_pressed(KEY_2)
Input.is_key_pressed(KEY_3)
```

这不利于后续自定义键位。

### 方案

在 `project.godot` 中新增动作：

```text
pick_blessing_1 -> 1
pick_blessing_2 -> 2
pick_blessing_3 -> 3
```

将代码改为：

```gdscript
Input.is_action_just_pressed("pick_blessing_1")
Input.is_action_just_pressed("pick_blessing_2")
Input.is_action_just_pressed("pick_blessing_3")
```

### 预期效果

- 所有关键输入都走 InputMap。
- 后续做可配置键位时不需要改玩法逻辑。

---

## 4. Controls 展示（Controls Display）

### 当前情况

玩家只能在 README 或 controls.md 中看到键位。

### 方案

在 `Main.tscn` 的 UI 中增加简短 Controls 文本。

示例：

```text
Move: WASD/Arrows | Attack: Mouse/J | Dash: Space/K | Pick: 1/2/3 | Restart: R
```

位置：屏幕底部或左上角 HUD 下方。

M2 只做只读展示，不做设置界面交互。

---

## 涉及文件

| 文件 | 改动 |
|---|---|
| `scripts/player.gd` | 命中敌人时触发 Hit Stop |
| `scripts/melee_enemy.gd` | 增加受击 knockback |
| `scripts/ranged_enemy.gd` | 增加受击 knockback |
| `scripts/main.gd` | 祝福选择改用 InputMap 动作 |
| `project.godot` | 增加 `pick_blessing_1/2/3` |
| `scenes/Main.tscn` | 增加 Controls 文本 |
| `controls.md` | 标记 M2 输入映射整理 |
| `issue-tracker.md` | 更新 FEEL/CTRL 问题状态 |
| `dev-log.md` | 记录实现过程 |
| `pitfalls.md` | 如踩坑则记录 |

---

## 验收标准

### Hit Feedback

- [ ] 玩家攻击命中敌人时有短暂停顿感。
- [ ] 停顿不影响移动整体流畅性。
- [ ] 连续攻击不会造成明显卡死。

### Knockback

- [ ] 近战敌人被命中后会后退一小段。
- [ ] 远程敌人被命中后会后退一小段。
- [ ] 击退不影响敌人死亡逻辑。
- [ ] 击退不影响 burn 伤害逻辑。

### InputMap

- [ ] 祝福选择 `1/2/3` 仍可用。
- [ ] `main.gd` 不再直接使用 `KEY_1/2/3`。
- [ ] 祝福按钮点击仍可用。

### Controls Display

- [ ] 游戏内能看到基础操作提示。
- [ ] 操作提示不遮挡战斗区域。

### Overall

- [ ] 仍可完成 3 房间通关。
- [ ] Godot 运行无脚本报错。

---

## 风险

| 风险 | 影响 | 应对 |
|---|---|---|
| Hit Stop 过强 | 游戏显得卡顿 | 初始参数很短，必要时调低 duration |
| Knockback 过强 | 敌人被打飞，攻击节奏变怪 | 使用小速度和短时长 |
| InputMap 手写格式出错 | Godot 项目输入配置异常 | 小步修改，运行验证 |
| Controls 文本遮挡 UI | 影响战斗观察 | 放在底部或 HUD 下方，保持短文本 |

---

## 实施步骤

1. 修改 `project.godot`，增加祝福选择动作。
2. 修改 `main.gd`，移除 `KEY_1/2/3` 硬编码。
3. 修改 `melee_enemy.gd`，增加受击 knockback。
4. 修改 `ranged_enemy.gd`，增加受击 knockback。
5. 修改 `player.gd`，命中敌人时触发轻量 Hit Stop。
6. 修改 `Main.tscn`，增加 Controls 文本。
7. Godot 无头加载验证。
8. 用户手测。
9. 更新日志和问题追踪。

---

## 回滚方案

如果 M2 手感改动产生明显问题：

1. 优先回滚 Hit Stop。
2. 保留 InputMap 清理。
3. Knockback 参数降到很小，或暂时关闭。
4. Controls 文本可保留，不影响战斗逻辑。

---

## 日志要求

完成后更新：

- `dev-log.md`
- `issue-tracker.md`
- `milestones.md`

如果出现新坑，更新：

- `pitfalls.md`
