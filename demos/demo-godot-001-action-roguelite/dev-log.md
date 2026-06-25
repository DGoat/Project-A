## 2026-06-25：区分伤害类型与击退规则

### 本次目标

修正 M2 手感改动后的伤害类型问题：燃烧伤害不应造成敌人后退。

### 做了什么

- 新增 Spec：`specs/spec-004-damage-types.md`。
- 修改 `player.gd`：
  - 普通攻击传入 `damage_type = "direct"`。
- 修改 `melee_enemy.gd`：
  - `take_damage()` 增加 `damage_type` 参数。
  - 仅 `direct` 伤害触发 knockback。
  - burn tick 传入 `damage_type = "burn"`。
- 修改 `ranged_enemy.gd`：
  - 同步增加 `damage_type` 参数。
  - burn tick 不触发 knockback。
- 更新 `issue-tracker.md`：
  - 新增 `DMG-001`。

### 遇到的问题

- 直接伤害和燃烧持续伤害都走同一个 `take_damage()`。
- M2 受击 knockback 逻辑只判断 `source != null`，导致燃烧 tick 也可能触发 knockback。

### 如何解决

- 引入轻量 `damage_type` 参数。
- 当前只区分：
  - `direct`：可以击退。
  - `burn`：只扣血，不击退。

### 仍未解决

- 尚未做完整伤害系统。
- 后续若加入冰冻、毒、爆炸等伤害，需要扩展伤害类型规则。

### 下一步

- 用户复测：
  - 普攻是否仍击退敌人。
  - 燃烧 tick 是否不再击退敌人。
  - 燃烧是否仍能造成伤害和击杀。



### 本次目标

按 `spec-003-basic-game-feel.md` 推进 M2：基础手感可接受。

### 做了什么

- 新增 Spec：`specs/spec-003-basic-game-feel.md`。
- 修改 `project.godot`：
  - 增加 `pick_blessing_1`。
  - 增加 `pick_blessing_2`。
  - 增加 `pick_blessing_3`。
- 修改 `main.gd`：
  - 祝福选择从 `KEY_1/2/3` 改为 InputMap 动作。
- 修改 `player.gd`：
  - 命中敌人时触发轻量 Hit Stop。
- 修改 `melee_enemy.gd`：
  - 增加受击 knockback。
- 修改 `ranged_enemy.gd`：
  - 增加受击 knockback。
- 修改 `Main.tscn`：
  - 增加只读 Controls 提示。
- 更新 `issue-tracker.md`：
  - 更新 FEEL 系列问题状态。
  - 更新 CTRL 系列问题状态。

### 遇到的问题

- M1 已能通关，但命中反馈仍偏弱。
- 祝福选择输入硬编码，不利于后续可配置键位。
- 游戏内缺少操作提示。

### 如何解决

- 用短 Hit Stop 提升命中瞬间反馈。
- 敌人受击后轻微后退，增强空间反馈。
- 将祝福选择输入纳入 Godot InputMap。
- 在 UI 底部增加 Controls 提示。

### 仍未解决

- 需要用户复测 Hit Stop 是否过强或过弱。
- 需要确认 knockback 是否影响敌人移动节奏。
- Controls 只是只读提示，不支持配置。
- 尚未完成完整 M2 验收。

### 下一步

- 用户复测 M2 手感：
  - 命中是否更有反馈。
  - 敌人被打后是否会合理后退。
  - 1/2/3 祝福选择是否仍可用。
  - Controls 提示是否遮挡画面。



### 本次目标

确认当前 Demo 是否已经跑通最小可运行闭环。

### 做了什么

- 用户完成房间 1、房间 2、房间 3。
- 清理第 3 房间后显示胜利信息。
- 通关时玩家剩余生命值约 `58/100`。
- 更新 `milestones.md`：M1 状态改为 Done。
- 更新 `issue-tracker.md`：将 M1 阻塞问题标记为 Fixed。

### 遇到的问题

- M1 期间先后暴露：
  - 血量离角色太远。
  - 攻击范围不可见。
  - 近战敌人黏住玩家。
  - 远程敌人攻击欲望偏强。

### 如何解决

- 增加玩家头顶血条。
- 增加攻击范围提示。
- 增加玩家受伤无敌。
- 增加近战敌人命中后 recoil。
- 降低远程敌人射击频率。

### 仍未解决

- M2 手感问题仍需处理：
  - Hit Stop
  - 击退反馈
  - 更清晰的命中反馈
  - 设置/Controls 展示
  - 祝福选择键位仍有硬编码

### 下一步

进入 M2：基础手感可接受。

建议先产出 M2 Spec，再实现：

```text
spec-003-basic-game-feel.md
```



### 本次目标

解决 M1 手测中近战敌人黏住玩家、远程敌人攻击欲望偏强的问题。

### 做了什么

- 新增 Spec：`specs/spec-002-contact-damage-separation.md`。
- 修改 `player.gd`：
  - 增加 `invulnerable_time`。
  - 增加 `hurt_invulnerable_duration`。
  - 玩家受伤后短暂无敌。
  - 玩家受伤后短暂闪色。
- 修改 `melee_enemy.gd`：
  - 增加 `recoil_time`。
  - 增加 `recoil_direction`。
  - 增加 `recoil_speed`。
  - 增加 `recoil_duration`。
  - 近战敌人命中玩家后向远离玩家方向后退。
- 修改 `ranged_enemy.gd`：
  - 将 `shoot_cooldown` 从 `1.2` 调整为 `1.8`。
  - 将 `preferred_distance` 从 `260` 调整为 `300`。
  - 增加首次射击延迟。
- 更新 `issue-tracker.md`：
  - 新增 `FEEL-006`。
  - 新增 `BAL-001`。

### 遇到的问题

- 近战敌人接触玩家后会持续贴住玩家。
- 玩家被两个近战敌人夹住后很难脱身。
- 远程敌人在房间 2 中射击压力偏高。

### 如何解决

- 用“玩家受伤无敌 + 近战敌人命中后 recoil”的轻量方案解决黏住问题。
- 降低远程敌人射击频率，并增加首次射击延迟。

### 仍未解决

- 需要用户复测近战敌人是否仍会贴住。
- 需要确认远程敌人威胁是否降得过低。
- 还没有做完整击退、Hit Stop、接触伤害冷却 UI 反馈。

### 下一步

- 用户复测房间 1 和房间 2：
  - 被近战敌人命中后是否能脱身。
  - 远程敌人射击频率是否更合理。
  - 是否仍能完成清房和祝福选择。



### 本次目标

解决 M1 手测中暴露的两个可读性问题：

1. 血量 UI 离角色太远。
2. 攻击范围不可见。

### 做了什么

- 新增 Spec：`specs/spec-001-player-readability.md`。
- 修改 `Player.tscn`：
  - 增加 `HealthBarBg`。
  - 增加 `HealthBarFill`。
  - 增加 `AttackPreview`。
- 修改 `player.gd`：
  - 增加 `health_bar_fill` 和 `attack_preview` 引用。
  - 增加 `_update_health_bar()`。
  - 初始化时更新血条。
  - 受伤和回血后更新血条。
  - 攻击时短暂显示攻击范围提示。
- 更新 `issue-tracker.md`：
  - 新增 `UI-001`。
  - 新增 `FEEL-005`。

### 遇到的问题

- 攻击范围原本完全不可见，导致玩家只能靠敌人掉血判断是否命中。
- 血量只在左上角 HUD 中显示，与角色距离太远。

### 如何解决

- 在玩家角色上方添加小型血条。
- 攻击时在实际攻击判定位置显示半透明黄色范围提示。

### 仍未解决

- 需要用户复测确认显示效果是否足够清楚。
- 攻击范围提示目前是简单占位，不是最终美术。
- 近战敌人夹住玩家的问题仍未修复。

### 下一步

- 用户复测：
  - 角色上方是否能看到血条。
  - 受伤后血条是否变化。
  - 攻击时是否能看到范围提示。
  - 范围提示是否和命中位置一致。



### 本次目标

建立专门文档，记录实现过程中踩过的坑、原因、解决方式和预防措施。

### 做了什么

- 新增 `pitfalls.md`。
- 初始记录 7 个坑：
  - Winget 安装 Godot 后当前终端找不到 `godot`
  - 误以为 Godot 需要迁移完整安装目录
  - Godot 项目打开后看起来空空如也
  - Godot 4.7 打开项目时提示从 4.2 升级
  - Git 状态中出现 Godot 自动生成文件
  - 文档更新后容易忘记同步远程 Git
  - 中大型改动如果不先写 Spec，容易范围膨胀
- 更新 `README.md` Production Docs 索引。

### 遇到的问题

- 原有 `dev-log.md` 和 `issue-tracker.md` 能记录过程和问题，但不够聚焦“经验教训”。

### 如何解决

- 单独创建 `pitfalls.md`，用于沉淀可复用经验。

### 仍未解决

- 后续每次遇到新坑都需要追加记录。

### 下一步

- 后续实现/测试时，如果出现新坑，实时更新 `pitfalls.md`。



### 本次目标

将“中、大型改动先产出 Spec，再动手写码”的协作规范写入仓库文档。

### 做了什么

- 新增仓库级文档：`docs/spec-first.md`。
- 在 `README.md` 中加入 Spec First 文档入口。
- 在 `docs/architecture.md` 中加入 Spec First Rule。

### 遇到的问题

- 后续系统级改动如果直接写码，容易范围膨胀。
- 键位配置、手感系统、祝福系统等都可能影响多个文件，需要先设计。

### 如何解决

- 规定中、大型改动必须先写 Spec。
- 明确 Spec 模板、存放位置、适用范围和执行流程。

### 仍未解决

- Demo 内 `specs/` 目录尚未创建。
- 可配置键位系统尚未写具体 Spec。

### 下一步

- M1 继续手测。
- 进入 M2 或实现可配置键位前，先创建对应 Spec。



### 本次目标

明确当前操作映射，并规划后续可配置键位支持。

### 做了什么

- 新增 `controls.md`。
- 记录当前默认键位：
  - WASD / 方向键：移动
  - 鼠标左键 / J：攻击
  - Space / K：闪避
  - R：重开
- 说明当前使用 Godot InputMap。
- 明确后续阶段：
  - M1：默认键位可用
  - M2：设置界面雏形
  - M3：动作映射整理
  - M4：游戏内改键和本地保存
  - M5：手柄支持
- 更新 `README.md` Production Docs 索引。
- 更新 `milestones.md`，将 Controls/Settings 雏形纳入 M2。
- 更新 `issue-tracker.md`，新增 CTRL 系列问题。

### 遇到的问题

- 当前祝福选择仍使用硬编码 `KEY_1/2/3`。
- 当前没有游戏内键位查看/配置界面。

### 如何解决

- 先以文档形式记录默认键位和技术债。
- 将硬编码祝福选择登记为 `CTRL-001`，计划 M2 处理。

### 仍未解决

- `CTRL-001`：祝福选择硬编码。
- `CTRL-002`：暂无设置界面。
- `CTRL-003`：暂无本地键位保存。
- `CTRL-004`：暂无手柄支持。

### 下一步

继续 M1 手测。M1 跑通后，M2 优先处理手感反馈和基础 Controls 展示。
