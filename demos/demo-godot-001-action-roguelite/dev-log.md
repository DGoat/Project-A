## 2026-06-26：M3 Debug 赐福面板与中文赐福

### 本次目标

根据反馈，将测试祝福从热键改为 Debug 面板，并将赐福相关名称和描述改为中文。

### 做了什么

- 修改 `data/blessings.json`：
  - 6 个赐福名称和描述改为中文。
- 修改 `Main.tscn`：
  - 增加右侧 Debug 面板。
  - Debug 面板提供 6 个按钮，可直接添加指定赐福。
  - 已获得赐福面板标题和空状态改为中文。
  - 三选一标题改为中文。
- 修改 `main.gd`：
  - 移除 `4-9` 测试热键逻辑。
  - Debug 面板按钮直接调用添加赐福逻辑。
  - UI Message、状态文本、胜利/失败提示改为中文。
- 修改 `project.godot`：
  - 移除 `debug_blessing_1-6` 输入动作。
- 修改 `controls.md` / `README.md`：
  - 测试方式改为 Debug 面板按钮。
- 更新 `spec-007-debug-blessings-and-damage-flash.md`：
  - 从测试热键方案改为 Debug 面板方案。

### 下一步

用户复测：

1. 右侧 Debug 面板按钮是否能添加指定赐福。
2. 三选一赐福是否显示中文名称和描述。
3. 已获得赐福面板是否显示中文赐福名。
4. 受伤红闪是否正常。
5. 是否仍能通关。



## 2026-06-26：M3 测试祝福、祝福记录面板与受伤红闪

### 本次目标

解决 M3 复测中的两个验证问题和一个反馈问题：

1. 指定祝福不方便测试。
2. 当前 Run 已获得祝福缺少记录面板。
3. 玩家受伤反馈不够强。

### 做了什么

- 新增 Spec：`specs/spec-007-debug-blessings-and-damage-flash.md`。
- 修改 `project.godot`：
  - 增加 `debug_blessing_1-6`，对应数字键 `4-9`。
  - 补回 `pick_blessing_3`。
- 修改 `Main.tscn`：
  - 增加 `DamageFlash` 全屏红色覆盖层。
  - 增加 `AcquiredBlessingsPanel` 已获得祝福面板。
- 修改 `main.gd`：
  - 支持按 `4-9` 手动添加指定祝福。
  - 三选一和测试热键获得祝福都会记录到面板。
  - 玩家受伤时触发全屏红闪并快速淡出。
- 修改 `player.gd`：
  - 增加 `damaged` signal。
- 修改 `controls.md`：
  - 记录测试祝福热键。
- 更新 `issue-tracker.md`：
  - 新增测试便利性、祝福面板、受伤红闪相关问题。

### 测试祝福热键

```text
4 Sharpened Edge
5 Quick Hands
6 Wind Step
7 Blood Warmth
8 Ember Mark
9 Long Reach
```

### 下一步

用户复测：

1. 按 `4-9` 是否能添加对应祝福。
2. 右上角 Blessings 面板是否记录当前获得的祝福。
3. 被敌人命中时是否有全屏红闪。
4. 三选一祝福是否仍可用。
5. 是否仍可通关。



## 2026-06-26：M3 现有祝福表现强化实现

### 本次目标

按 `spec-006-build-identity-and-visible-blessings.md` 推进 M3 起步：先让现有祝福更可见。

### 做了什么

- 新增 Spec：`specs/spec-006-build-identity-and-visible-blessings.md`。
- 修改 `player.gd`：
  - `range_up` 同步改变矩形攻击提示长度和实际判定长度。
  - Dash Strike 充能时玩家变为青色，命中后恢复。
  - Kill Heal 触发时玩家短暂绿色闪色。
  - Attack Up 后攻击提示颜色更深。
- 修改 `melee_enemy.gd`：
  - 燃烧期间保持橙色状态。
  - burn tick 时加深橙色闪色。
- 修改 `ranged_enemy.gd`：
  - 同步燃烧持续状态和 tick 闪色。
- 更新 `milestones.md`：M3 标记为 In Progress。
- 更新 `issue-tracker.md`：`BUILD-001` 标记为 In Progress。

### 遇到的问题

- `range_up` 原本只改变攻击位置距离，不改变矩形长度。
- `dash_strike` 原本没有充能状态提示。
- `kill_heal` 原本只能通过血条变化感知。
- 燃烧原本只有 tick 闪色，持续状态不明显。

### 如何解决

- 用脚本动态调整 `RectangleShape2D.size.x` 和 `AttackPreview.polygon`。
- 用玩家/敌人 `Body.modulate` 做 M3 占位反馈。
- 保持轻量实现，不引入粒子、音效或完整 Buff UI。

### 仍未解决

- 祝福表现仍是占位视觉，不是最终美术。
- `attack_speed_up` 还缺少明确视觉反馈。
- 还没做构筑路线标签和更完整祝福选择体验。

### 下一步

用户复测：

1. 拿到 `Long Reach` 后，攻击矩形是否明显变长，命中范围是否同步变长。
2. 拿到 `Wind Step` 后，Dash 后玩家是否变青色，下一击后是否恢复。
3. 拿到 `Ember Mark` 后，敌人燃烧期间是否有橙色状态。
4. 拿到 `Blood Warmth` 后，击杀回血是否有绿色闪色。
5. 是否仍能通关。



## 2026-06-26：M2 基础手感验收通过

### 本次目标

确认 M2 基础手感是否达到“可接受”标准。

### 复测反馈

- Hit Stop：可以。
- 敌人受击击退：可以。
- Controls 提示：暂时这样。
- 燃烧闪色：可以。
- 死亡后 `R` 重开：可以。
- 再次通关：可以。
- 暂无新的明显别扭点。

说明：用户询问“四方向攻击”含义。这里指玩家面向上/下/左/右时的基础攻击方向，不是祝福效果。

### 做了什么

- 更新 `milestones.md`：M2 标记为 Done。
- 更新 `issue-tracker.md`：M2 相关问题标记为 Fixed。

### 仍未解决

- Controls 只是只读提示，不支持配置。
- `range_up` 仍未同步改变矩形长度。
- 这些进入 M3/M4 再处理。

### 下一步

进入 M3：构筑效果可感知。

建议先写：

```text
spec-006-build-identity-and-visible-blessings.md
```



### 本次目标

用户确认矩形攻击提示可以接受，继续统一显示范围和实际判定范围。

### 做了什么

- 新增 Spec：`specs/spec-005-rect-attack-hitbox.md`。
- 修改 `Player.tscn`：
  - 将攻击碰撞体从 `CircleShape2D` 改为 `RectangleShape2D`。
  - 矩形尺寸为 `50 x 36`。
- 修改 `player.gd`：
  - 攻击时同步设置 `AttackArea` 和 `AttackPreview` 的位置。
  - 攻击时同步设置 `AttackArea` 和 `AttackPreview` 的旋转。

### 遇到的问题

- 上一版矩形只是视觉提示，真实攻击判定仍是圆形。
- 视觉范围和真实命中范围不一致。

### 如何解决

- 将攻击判定也改为矩形。
- 让攻击提示与攻击判定使用相同的位置和旋转。

### 仍未解决

- `range_up` 当前只改变攻击位置距离，还没有同步改变矩形长度。
- 这属于 M3 构筑效果表现问题。

### 下一步

- 用户复测：
  - 矩形提示和实际命中是否基本一致。
  - 四方向攻击是否都正常。
  - 攻击是否仍容易命中敌人。



### 本次目标

修正攻击范围提示仍然偏丑的问题。

### 做了什么

- 修改 `Player.tscn`：
  - 将攻击提示从不规则多边形改为矩形。
  - 降低透明度，减少遮挡。
- 修改 `player.gd`：
  - 攻击提示跟随玩家朝向旋转。
  - 攻击提示放在玩家攻击方向前方。

### 遇到的问题

- 之前的攻击提示虽然更轻，但形状仍然不够直观。

### 如何解决

- M2 阶段先采用矩形攻击提示。
- 后续 M3/M4 可升级为扇形、刀光或美术特效。

### 仍未解决

- 攻击提示仍是占位视觉，不是最终美术。
- 真实攻击判定仍是圆形 `AttackArea`，与矩形提示不完全一致。

### 下一步

- 用户复测矩形提示是否比之前更可接受。
- 如需要更精确，后续再统一攻击判定形状与显示形状。



### 本次目标

根据 M2 复测反馈修正三个问题：

1. Controls 提示有点妨碍。
2. 攻击范围显示太丑。
3. 燃烧伤害现在没有表现。

### 做了什么

- 修改 `Main.tscn`：
  - 将 Controls 长提示改为短提示。
  - 从底部移动到左上 HUD 下方。
  - 降低透明度。
- 修改 `Player.tscn`：
  - 将攻击范围提示从大块六边形改为更窄、更轻的提示形状。
  - 降低透明度。
- 修改 `melee_enemy.gd`：
  - 燃烧伤害 tick 使用橙色闪色。
- 修改 `ranged_enemy.gd`：
  - 燃烧伤害 tick 使用橙色闪色。
- 更新 `issue-tracker.md`：
  - `DMG-001` 标记为 Fixed。
  - 新增 `UI-002`。
  - 新增 `FEEL-007`。

### 遇到的问题

- Controls 全量文本放在底部会干扰画面。
- 攻击范围提示过于粗糙、遮挡感强。
- 燃烧不会击退后，也缺少可视反馈。

### 如何解决

- Controls 改成低干扰短提示。
- 攻击提示改为更轻、更窄、更透明的形状。
- 燃烧 tick 用橙色闪色表现。

### 仍未解决

- 攻击范围提示仍是占位表现，不是最终美术。
- Controls 仍不是完整设置界面。
- 燃烧表现只有闪色，没有持续火焰或跳字。

### 下一步

- 用户复测：
  - Controls 是否还妨碍。
  - 攻击范围提示是否能接受。
  - 燃烧 tick 是否能被看到。



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
