# 问题追踪（Issue Tracker）

## 状态说明

| 状态 | 含义 |
|---|---|
| Open | 已发现，未处理 |
| In Progress | 正在处理 |
| Fixed | 已修复，待验证或已验证 |
| Deferred | 暂缓，不影响当前节点 |
| Won't Fix | 明确不处理 |

---

## 当前问题列表

| ID | 状态 | 优先级 | 问题 | 影响节点 |
|---|---|---|---|---|
| GODOT-001 | Fixed | High | 本机未安装 Godot | M1 |
| GODOT-002 | Fixed | Medium | Winget 安装后当前终端无法识别 `godot` 命令 | M1 |
| GODOT-003 | Fixed | Low | 项目打开时提示从 Godot 4.2 升级到 4.7 | M1 |
| DEMO-001 | Fixed | High | 已完成 3 房间完整流程手测并通关 | M1 |
| DEMO-002 | Fixed | High | 攻击可命中并击杀敌人 | M1 |
| DEMO-003 | Fixed | High | 清房后祝福三选一正常出现 | M1 |
| DEMO-004 | Fixed | High | 选择祝福后可进入下一房间 | M1 |
| DEMO-005 | Open | Medium | 尚未确认死亡后 `R` 是否能重开 | M1 |
| VIS-001 | Open | Medium | Godot 编辑器/运行画面中出现异常图片或背景，需要确认来源 | M1 |
| UI-001 | Fixed | High | 已增加角色头顶血条 | M1 |
| FEEL-005 | Fixed | High | 已增加攻击范围提示 | M1 |
| FEEL-006 | Fixed | High | 已增加受伤无敌与近战命中后弹开 | M1 |
| BAL-001 | Fixed | Medium | 已降低远程敌人攻击欲望 | M1 |
| FEEL-001 | In Progress | Medium | 已补充攻击范围提示，继续补充 Hit Stop / knockback 手感 | M2 |
| FEEL-002 | In Progress | Medium | 增加 Hit Stop | M2 |
| FEEL-003 | In Progress | Medium | 增加敌人受击击退 | M2 |
| FEEL-004 | Fixed | Medium | 玩家受伤后已有短暂无敌帧 | M2 |
| BUILD-001 | Deferred | Medium | 祝福效果多数偏数值，缺少可见差异 | M3 |
| DMG-001 | In Progress | Medium | 燃烧伤害不应触发敌人受击击退 | M2 |
| CTRL-001 | Fixed | Medium | 祝福选择已改为 InputMap 动作 | M2 |
| CTRL-002 | In Progress | Medium | 已增加只读 Controls 提示，暂无修改键位界面 | M2/M4 |
| CTRL-003 | Deferred | Low | 暂无本地键位保存 | M4 |
| CTRL-004 | Deferred | Low | 暂无手柄支持 | M5 |

---

### DMG-001：燃烧伤害不应触发敌人受击击退

状态：In Progress
优先级：Medium
影响节点：M2

现象：

- M2 增加敌人受击 knockback 后，燃烧 tick 伤害也可能触发 knockback。
- 这不符合伤害类型直觉：持续伤害应该扣血，但不应该推开敌人。

处理方式：

- 新增轻量 `damage_type` 参数。
- `direct` 伤害触发 knockback。
- `burn` 伤害不触发 knockback。
- burn tick 仍保留 `burn_owner`，确保燃烧击杀可以归因给玩家。

后续验证：

- 普攻命中仍会击退。
- 燃烧 tick 不会击退。
- 燃烧仍能造成伤害并击杀。

---

### FEEL-006：近战敌人命中后持续黏住玩家

状态：In Progress
优先级：High
影响节点：M1

现象：

- 红色近战敌人接触玩家后会持续贴住。
- 玩家移动也难以拉开距离。
- 多个近战敌人夹住玩家时，容易快速死亡。

处理方式：

- 玩家受伤后获得 `0.65s` 无敌时间。
- 近战敌人命中玩家后进入短暂 recoil，向远离玩家方向后退。

后续验证：

- 被近战敌人命中后，敌人是否会弹开。
- 玩家是否有机会移动或 dash 脱身。
- 玩家是否不再 1 秒内被连续多次接触伤害扣血。

---

### BAL-001：远程敌人攻击欲望偏强

状态：In Progress
优先级：Medium
影响节点：M1

现象：

- 房间 2 同时有近战追击和远程弹体压力。
- 远程敌人射击频率偏高。

处理方式：

- 将远程敌人 `shoot_cooldown` 从 `1.2` 调整为 `1.8`。
- 将 `preferred_distance` 从 `260` 调整为 `300`。
- 增加首次射击延迟：`shoot_time = shoot_cooldown * 0.7`。

后续验证：

- 远程敌人射击频率是否明显降低。
- 房间 2 是否仍保留远程威胁。
- 难度是否比之前更适合 M1 验证。

---

### UI-001：血量 UI 离角色太远

状态：In Progress
优先级：High
影响节点：M1

现象：

- 血量只在左上角 HUD 显示。
- 玩家角色和血量信息距离太远，战斗中不易感知自身状态。

处理方式：

- 在 `Player.tscn` 中增加角色头顶血条。
- 在 `player.gd` 中增加 `_update_health_bar()`，受伤和回血后同步更新。

后续验证：

- 运行后确认角色上方可见血条。
- 受伤后血条缩短。
- 击杀回血祝福触发后血条增加。

---

### FEEL-005：看不到攻击范围

状态：In Progress
优先级：High
影响节点：M1

现象：

- 攻击时没有范围提示。
- 玩家只能通过敌人是否掉血判断攻击是否命中。

处理方式：

- 在 `Player.tscn` 中增加 `AttackPreview`。
- 攻击时将 `AttackPreview.position` 与 `AttackArea.position` 对齐并短暂显示。

后续验证：

- 攻击时可看到半透明黄色攻击范围提示。
- 提示位置跟随玩家朝向。
- 不影响真实攻击判定。

---
### GODOT-001：本机未安装 Godot

状态：Fixed  
优先级：High  
影响节点：M1

现象：

- 初始执行 `where godot` 找不到 Godot。

解决方式：

- 使用 Winget 安装 Godot：

```bash
winget install --id GodotEngine.GodotEngine -e --source winget --accept-source-agreements --accept-package-agreements
```

结果：

- 安装成功，版本为 `4.7.stable.official.5b4e0cb0f`。

---

### GODOT-002：当前终端无法识别 `godot` 命令

状态：Fixed  
优先级：Medium  
影响节点：M1

现象：

- Winget 安装后执行 `godot --version`，提示不是内部或外部命令。

原因：

- Winget 修改 PATH 后当前终端未刷新。

解决方式：

- 找到实际安装路径并使用完整路径运行。
- 复制 Godot 到 `F:\Godot`。
- 创建：

```text
F:\Godot\godot.bat
F:\Godot\godot_console.bat
```

结果：

- `godot.bat --version` 和 `godot_console.bat --version` 均返回 `4.7.stable`。

---

### GODOT-003：项目从 Godot 4.2 升级到 4.7 提示

状态：Fixed  
优先级：Low  
影响节点：M1

现象：

- 打开项目时 Godot 提示：该项目最近一次编辑使用的是 Godot 4.2，打开后会修改为 Godot 4.7。

处理方式：

- 允许升级。

原因：

- `project.godot` 初始写了 `config/features=PackedStringArray("4.2")`。
- 当前安装 Godot 版本为 4.7。

结果：

- 项目已进入 Godot 编辑器。

---

### DEMO-001：尚未完成 3 房间完整流程手测

状态：Open  
优先级：High  
影响节点：M1

现象：

- 当前只确认项目能打开，主场景能看到。
- 未确认完整 Run 是否可通关。

后续计划：

- 用户运行 `Main.tscn`。
- 按 M1 手测清单完成验证。
- 记录阻塞问题并修复。

---

### DEMO-002：尚未确认攻击是否能稳定命中并击杀敌人

状态：Open  
优先级：High  
影响节点：M1

待验证：

- `Left Mouse / J` 是否能攻击。
- 攻击范围是否覆盖敌人。
- 敌人是否正常扣血和死亡。

后续计划：

- 若无法命中，优先检查：
  - `AttackArea` 位置
  - 碰撞层/掩码
  - `body_entered` 信号
  - 敌人 `collision_layer`

---

### DEMO-003：尚未确认清房后祝福三选一是否正常出现

状态：Open  
优先级：High  
影响节点：M1

待验证：

- 所有敌人死亡后 `BlessingPanel` 是否出现。
- 3 个按钮是否显示祝福名称和描述。

后续计划：

- 若不出现，检查：
  - `enemies_alive` 是否正确递减
  - `died` 信号是否连接
  - `_on_room_cleared()` 是否执行
  - UI 节点路径是否正确

---

### DEMO-004：尚未确认选择祝福后能否进入下一房间

状态：Open  
优先级：High  
影响节点：M1

待验证：

- 点击按钮或按 `1/2/3` 是否能选择祝福。
- 玩家属性是否变化。
- 是否生成下一房间敌人。

后续计划：

- 若选择无效，检查：
  - Button 信号连接
  - 闭包索引 `button_index`
  - `_pick_blessing()` 是否被调用
  - `offered_blessings` 是否为空

---

### DEMO-005：尚未确认死亡后 `R` 是否能重开

状态：Open  
优先级：Medium  
影响节点：M1

待验证：

- 玩家死亡后是否显示 Defeat。
- 按 `R` 是否重新加载场景。

后续计划：

- 若失败，检查 `restart` InputMap 和 `_process()`。

---

### VIS-001：Godot 编辑器/运行画面中出现异常图片或背景

状态：Open  
优先级：Medium  
影响节点：M1

现象：

- 用户截图中出现非 Demo 内容的图片/大背景，疑似外部窗口遮挡、编辑器显示异常、系统截图混叠或误导入资源。

待确认：

- 异常图片是否在 Godot 运行窗口内。
- 是否影响实际游戏画面。
- `FileSystem` 中是否存在异常图片资源。

后续计划：

- 若影响游戏窗口，检查 `Main.tscn` 是否引用异常资源。
- 若只是截图/窗口遮挡，不作为 Demo 问题处理。

---

### FEEL-001：缺少攻击范围提示

状态：Deferred  
优先级：Medium  
影响节点：M2

原因：

- 不阻塞 M1 闭环。

后续计划：

- M2 增加攻击范围可视化，例如半透明扇形或圆形提示。

---

### FEEL-002：缺少 Hit Stop

状态：Deferred  
优先级：Medium  
影响节点：M2

原因：

- 不阻塞 M1 闭环。

后续计划：

- M2 增加短暂停顿强化命中反馈。

---

### FEEL-003：缺少击退

状态：Deferred  
优先级：Medium  
影响节点：M2

原因：

- 不阻塞 M1 闭环。

后续计划：

- M2 为敌人受击添加 knockback。

---

### FEEL-004：玩家受伤后缺少无敌帧

状态：Deferred  
优先级：Medium  
影响节点：M2

原因：

- 不阻塞 M1，但可能影响手测体验。

后续计划：

- M2 增加短暂无敌，避免接触伤害连续触发。

---

### BUILD-001：祝福效果多数偏数值，缺少可见差异

状态：Deferred  
优先级：Medium  
影响节点：M3

原因：

- 当前优先验证闭环。

后续计划：

- M3 优先强化可见效果：
  - 燃烧颜色和跳伤
  - Dash Strike 特效
  - 攻击范围变化
  - 击杀回血提示

---

### CTRL-001：祝福选择使用硬编码 `KEY_1/2/3`

状态：Open
优先级：Medium
影响节点：M2

现象：

- 当前 `main.gd` 中祝福快捷选择直接读取 `KEY_1/2/3`。
- 这不利于后续改键和手柄支持。

后续计划：

- 在 `project.godot` 中新增：

```text
pick_blessing_1
pick_blessing_2
pick_blessing_3
```

- 将代码改为：

```gdscript
Input.is_action_just_pressed("pick_blessing_1")
Input.is_action_just_pressed("pick_blessing_2")
Input.is_action_just_pressed("pick_blessing_3")
```

---

### CTRL-002：暂无设置界面展示/修改键位

状态：Deferred
优先级：Medium
影响节点：M2/M4

现象：

- 玩家目前只能查看 README/controls.md 了解键位。
- 游戏内没有 Controls/Settings 界面。

后续计划：

- M2 增加只读 Controls 界面。
- M4 支持实际改键。

---

### CTRL-003：暂无本地键位保存

状态：Deferred
优先级：Low
影响节点：M4

后续计划：

- 使用 `user://controls.cfg` 保存自定义键位。

---

### CTRL-004：暂无手柄支持

状态：Deferred
优先级：Low
影响节点：M5

后续计划：

- 支持左摇杆移动。
- 支持手柄攻击、闪避、确认、取消。
