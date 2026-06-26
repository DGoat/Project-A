# 操作映射与键位配置（Controls）

## 当前默认键位

| 动作名 | 说明 | 默认输入 |
|---|---|---|
| `move_up` | 向上移动 | `W` / `↑` |
| `move_down` | 向下移动 | `S` / `↓` |
| `move_left` | 向左移动 | `A` / `←` |
| `move_right` | 向右移动 | `D` / `→` |
| `attack` | 普通攻击 | 鼠标左键 / `J` |
| `dash` | 闪避 | `Space` |
| `restart` | 重开 | `R` |
| `toggle_debug_panel` | 显示/隐藏 Debug 面板 | `·` |

## 当前实现方式

当前键位配置写在 Godot 项目文件：

```text
project.godot
```

位置：

```text
[input]
```

代码中不直接读取具体按键，而是读取动作名（Action Name）：

```gdscript
Input.get_vector("move_left", "move_right", "move_up", "move_down")
Input.is_action_just_pressed("attack")
Input.is_action_just_pressed("dash")
Input.is_action_just_pressed("restart")
```

这样后续可以替换按键，而不需要改玩家移动、攻击、闪避逻辑。

## 设计原则

### 1. 先固定默认键位

M1 阶段优先验证玩法闭环，不做游戏内改键。

原因：

- 降低实现复杂度
- 避免设置系统干扰核心玩法验证
- 先确认移动、攻击、闪避是否成立

### 2. 动作名稳定，按键可变

代码应始终依赖动作名，而不是具体按键。

正确：

```gdscript
Input.is_action_just_pressed("dash")
```

避免：

```gdscript
Input.is_key_pressed(KEY_SPACE)
```

例外：

- M1 当前祝福选择暂时使用 `KEY_1/2/3` 快捷键。
- 后续应统一改成 `pick_blessing_1`、`pick_blessing_2`、`pick_blessing_3`。

### 3. 支持键鼠优先，后续支持手柄

当前优先支持：

- 键盘
- 鼠标

后续可支持：

- Xbox 手柄
- PlayStation 手柄
- Steam Deck / 掌机布局

## 调试面板

M3 调试阶段，按 `·` 显示/隐藏右侧 Debug 面板。面板内按钮可直接添加指定赐福，避免完全依赖随机三选一。

当前按钮：

| 按钮 | 赐福 |
|---|---|
| 锋刃打磨 | 攻击伤害 +20% |
| 迅捷出手 | 攻击冷却 -15% |
| 疾风步 | 闪避后下一次攻击伤害 +50% |
| 血暖余烬 | 击杀敌人后回复 8 点生命 |
| 余火印记 | 攻击附加持续燃烧伤害 |
| 长柄之势 | 攻击范围 +20% |

这些按钮只用于测试，不代表正式玩法。

## 后续可配置键位规划

### M1：默认键位可用

目标：

- 默认键位跑通完整 Demo。
- 文档记录默认操作。

不做：

- 游戏内改键
- 手柄支持
- 本地保存配置

### M2：设置界面雏形

目标：

- 增加 `Controls` 或 `Settings` 简单界面。
- 展示当前键位。
- 暂不一定支持修改。

可能界面：

```text
Move: WASD / Arrow Keys
Attack: Left Mouse / J
Dash: Space
Restart: R
```

### M3：动作映射整理

目标：

- 将所有硬编码按键改成 InputMap 动作名。
- 增加：

```text
pick_blessing_1
pick_blessing_2
pick_blessing_3
confirm
cancel
pause
```

### M4：游戏内改键

目标：

- 玩家可以在设置界面中修改键位。
- 修改后立即生效。
- 保存到本地配置。

建议保存位置：

```text
user://controls.cfg
```

### M5：手柄支持

目标：

- 支持左摇杆移动。
- 支持手柄攻击、闪避、确认、取消。
- 支持 UI 中显示对应图标。

## 推荐动作列表

| 动作名 | 用途 | 默认键鼠 | 后续手柄建议 |
|---|---|---|---|
| `move_up` | 向上移动 | `W` / `↑` | Left Stick Up |
| `move_down` | 向下移动 | `S` / `↓` | Left Stick Down |
| `move_left` | 向左移动 | `A` / `←` | Left Stick Left |
| `move_right` | 向右移动 | `D` / `→` | Left Stick Right |
| `attack` | 普通攻击 | Left Mouse / `J` | X / Square |
| `dash` | 闪避 | `Space` | B / Circle |
| `pick_blessing_1` | 选择祝福 1 | `1` | D-Pad Left |
| `pick_blessing_2` | 选择祝福 2 | `2` | D-Pad Up |
| `pick_blessing_3` | 选择祝福 3 | `3` | D-Pad Right |
| `confirm` | 确认 | `Enter` / Left Mouse | A / Cross |
| `cancel` | 取消 | `Esc` | B / Circle |
| `pause` | 暂停 | `Esc` | Menu |
| `restart` | 重开 | `R` | View / Select |

## 当前技术债

| ID | 问题 | 影响 |
|---|---|---|
| CTRL-001 | 祝福选择使用硬编码 `KEY_1/2/3` | 不利于后续改键 |
| CTRL-002 | 暂无设置界面 | 玩家无法查看/修改键位 |
| CTRL-003 | 暂无本地键位保存 | 自定义配置无法持久化 |
| CTRL-004 | 暂无手柄支持 | 不适合动作类长期目标 |

## 下一步

当前优先级：

```text
M1 继续验证默认键位是否可跑通完整闭环。
```

进入 M2 前，建议先处理：

```text
CTRL-001：将祝福选择 `KEY_1/2/3` 改成 InputMap 动作。
```
