## 2026-06-26：第一批玩具修理屋美术资源接入

### 本次目标

将已生成的第一批 PNG 美术资源接入 Godot，替换主要几何占位，验证“童话治愈 × 玩具修理屋”主题是否更清楚。

### 做了什么

- 新增 Spec：`specs/spec-011-toy-art-asset-integration-01.md`。
- 接入 6 个资源：
  - `player_repairer.png`
  - `enemy_block_soldier.png`
  - `enemy_spring_cannon.png`
  - `projectile_button.png`
  - `attack_wood_ruler.png`
  - `bg_repair_table.png`
- 修改场景：
  - `Main.tscn` 增加修理台背景。
  - `Player.tscn` 用主角 Sprite 替换几何 Body，并增加攻击木尺 Sprite。
  - `MeleeEnemy.tscn` 用积木兵 Sprite 替换几何 Body。
  - `RangedEnemy.tscn` 用弹簧炮 Sprite 替换几何 Body。
  - `Projectile.tscn` 用纽扣 Sprite 替换几何 Body。
- 修改脚本：
  - `player.gd` 同步攻击 Sprite 的显示、方向和缩放。
  - `melee_enemy.gd` / `ranged_enemy.gd` 调整受击、燃烧、精英显示的 modulate 逻辑。
  - `projectile.gd` 让投射物按飞行方向旋转。
- 更新 `milestones.md`、`issue-tracker.md`、`README.md`。

### 风险记录

- 当前图片预览显示部分资源带棋盘格背景，可能不是透明 PNG。若 Godot 内也出现棋盘格，需要重新导出透明背景版本。
- 图片为偏绘本正面图，旋转朝向时可能不够自然，后续可改为 4 向或 8 向 Sprite。

### 下一步

用户在 Godot 中复测：主题识别度、攻击提示、投射物、清房和通关流程。


## 2026-06-26：回滚 Toy Visual Pass 0.1 几何占位

### 本次目标

根据复测反馈，回滚 Toy Visual Pass 0.1 中失败的几何视觉占位改动。

### 复测结论

用户反馈：

- 场景不像夜晚修理屋/玩具箱。
- 玩家不像小修理师/工具占位。
- 近战敌人不像积木兵。
- 远程敌人不像铁皮/弹簧炮玩具。
- 投射物不像纽扣/螺丝。
- 攻击提示不像木尺/工具挥击。
- 受击、燃烧、发条冲刺、回血反馈不清楚。
- 仍能通关。

### 做了什么

- 回滚以下文件中的几何视觉占位改动：
  - `scenes/Main.tscn`
  - `scenes/Player.tscn`
  - `scenes/MeleeEnemy.tscn`
  - `scenes/RangedEnemy.tscn`
  - `scenes/Projectile.tscn`
  - `scripts/player.gd`
  - `scripts/melee_enemy.gd`
  - `scripts/ranged_enemy.gd`
- 保留：
  - `spec-010-toy-visual-pass-01.md`，作为失败尝试记录。
  - `art-brief-001-toy-repair-prototype.md`，作为下一步美术资源生成依据。
- 更新 `issue-tracker.md`：
  - `VISUAL-001` 改为 Deferred。
- 更新 `milestones.md`：
  - 标记几何视觉占位复测失败并已回滚。

### 下一步

基于 `art-brief-001-toy-repair-prototype.md` 生成第一批美术资源，再接入 Godot。



## 2026-06-26：第一批玩具修理屋美术资源 Brief

### 本次目标

几何视觉占位复测失败后，转向生成第一批最小美术资源，用于验证玩具修理屋主题是否能在画面上成立。

### 做了什么

- 新增 `art-brief-001-toy-repair-prototype.md`。
- 明确第一批 6 个资源：
  - `player_repairer.png`
  - `enemy_block_soldier.png`
  - `enemy_spring_cannon.png`
  - `projectile_button.png`
  - `attack_wood_ruler.png`
  - `bg_repair_table.png`
- 为每个资源提供：
  - 用途说明。
  - 中文 Prompt。
  - English Prompt。
  - Negative Prompt。
  - 尺寸建议。
  - 透明背景要求。
- 更新 `README.md` 文件索引。

### 下一步

用该 Brief 生成第一批美术资源，再接入 Godot 替换几何占位。



## 2026-06-26：Toy Visual Pass 0.1 实现

### 本次目标

按 `spec-010-toy-visual-pass-01.md` 实现玩具修理屋基础视觉占位，让当前 Demo 在不引入外部美术资源的情况下更接近童话修理屋方向。

### 做了什么

- 修改 `Main.tscn`：
  - Arena 背景从冷黑改为暖暗棕，更接近夜晚修理台。
- 修改 `Player.tscn`：
  - 玩家颜色改为青绿色围裙感。
  - 玩家占位形状改得更像小工具朝向剪影。
  - 攻击提示改为暖木色，语义接近木尺/工具挥击。
  - 生命条改为温暖黄绿色。
- 修改 `MeleeEnemy.tscn`：
  - 近战敌人改为红棕积木块占位。
- 修改 `RangedEnemy.tscn`：
  - 远程敌人改为铁皮蓝弹簧炮占位。
- 修改 `Projectile.tscn`：
  - 投射物改为纽扣/螺丝色和六边形占位。
- 修改脚本颜色恢复逻辑：
  - `player.gd`
  - `melee_enemy.gd`
  - `ranged_enemy.gd`
- 更新 `issue-tracker.md`：
  - `VISUAL-001` 标记为 In Progress。
- 更新 `milestones.md`：
  - 记录 Toy Visual Pass 0.1 实现完成，待复测。

### 下一步

用户复测：

1. 场景是否更像夜晚修理屋/玩具箱。
2. 玩家是否比之前更有小修理师/工具占位感。
3. 近战敌人是否更像积木兵。
4. 远程敌人是否更像铁皮/弹簧炮玩具。
5. 投射物是否更像纽扣/螺丝。
6. 攻击提示是否更像木尺/工具挥击。
7. 受击、燃烧、发条冲刺、回血反馈是否仍清楚。
8. 是否仍能完整通关。



## 2026-06-26：Toy Visual Pass 0.1 Spec

### 本次目标

在机制深化前，先规划玩具修理屋基础视觉占位，让画面能更直观地表达主题。

### 做了什么

- 新增 Spec：`specs/spec-010-toy-visual-pass-01.md`。
- 规划视觉方向：
  - 夜晚修理屋。
  - 暖灯。
  - 木头。
  - 布偶。
  - 发条。
  - 积木。
  - 纽扣。
  - 小工具。
- 规划改动范围：
  - Arena 背景色。
  - 玩家占位色彩。
  - 近战敌人积木兵占位。
  - 远程敌人弹簧炮玩具占位。
  - 投射物纽扣/螺丝占位。
  - 攻击提示木尺/工具挥击占位。
- 更新 `issue-tracker.md`：新增 `VISUAL-001`。
- 更新 `milestones.md`：记录 Toy Visual Pass 0.1 Spec 完成。

### 下一步

按 Spec 实现基础视觉占位。



## 2026-06-26：玩具修理屋主题替换层实现

### 本次目标

按 `spec-009-toy-repair-shop-theme.md` 先实现主题替换层，让当前 Demo 从通用动作 Roguelite 转向“童话治愈 × 玩具修理屋”。

### 做了什么

- 修改 `data/blessings.json`：
  - 6 个赐福改为“修理灵感”风格。
  - 更新名称、描述、标签。
- 修改 `Main.tscn`：
  - 开始界面改为“玩具修理屋：夜间修理”。
  - 操作文案改为“修理打击 / 发条冲刺”。
  - 赐福面板改为“修理灵感”。
  - Debug 面板改为“添加修理灵感”。
  - 结算文案改为“本晚灵感”。
- 修改 `main.gd`：
  - 房间文案改为“区域”。
  - 敌人文案改为“失控玩具”。
  - 获得赐福改为“获得修理灵感”。
  - 胜利改为“黎明前修好了所有玩具”。
  - 失败改为“小灯熄灭了，被送回修理台”。
- 修改 `design.md`：
  - 新增“玩具修理屋”主题方向章节。
- 更新 `issue-tracker.md`：
  - `THEME-001` 标记为 In Progress。

### 下一步

用户复测主题替换层：

1. 开始界面是否符合玩具修理屋方向。
2. 修理灵感文案是否清楚。
3. 胜利/失败文案是否更贴合童话治愈。
4. 现有流程是否仍可通关。



## 2026-06-26：玩具修理屋主题 Spec

### 本次目标

沿“童话治愈 × 玩具修理屋”方向，明确 Demo 后续主题包装和构筑路线来源。

### 做了什么

- 新增 Spec：`specs/spec-009-toy-repair-shop-theme.md`。
- 明确一句话概念：
  - 夜晚的修理屋里，坏掉的玩具王国醒了。你是小小修理师，进入玩具箱王国，把发怒、断线、生锈、遗忘的玩具们修好。
- 明确主角定位：
  - 小小修理师 / 发条修理精灵。
- 明确主题动作替换：
  - Attack -> 修理打击。
  - Dash -> 发条冲刺。
  - Blessing -> 修理灵感。
  - Enemy -> 失控玩具。
  - Kill -> 修复完成。
- 初步规划 5 条构筑路线：
  - 发条。
  - 缝补。
  - 胶水。
  - 积木。
  - 灯光。
- 规划当前 6 个赐福的主题映射。

### 下一步

先做主题替换层，再进入发条/缝补路线机制深化。



## 2026-06-26：UI Flow Upgrade 复测通过

### 本次目标

记录 UI Flow Upgrade 初版复测结果，并同步问题状态。

### 复测结果

用户确认以下内容均通过测试：

1. 进入游戏先显示开始界面。
2. 点击开始后进入房间 1。
3. 三选一赐福显示构筑标签。
4. 胜利/失败后显示结算面板。
5. 结算面板显示本局赐福。
6. 重新开始按钮和 `R` 可用。
7. Debug 侧边栏默认隐藏并可按键显示。

### 做了什么

- 更新 `issue-tracker.md`：
  - `UI-FLOW-001` 标记为 Fixed。
  - `UI-FLOW-002` 标记为 Fixed。
  - `UI-FLOW-003` 标记为 Fixed。
- 更新 `milestones.md`：
  - UI 流程相关任务标记为已通过测试。

### 下一步

继续推进 M3 构筑效果可感知，或进入 M4 小型垂直切片准备。



## 2026-06-26：UI Flow Upgrade 阶段 1-3 初版实现

### 本次目标

按 `spec-008-ui-flow-upgrade.md` 实现 UI 流程升级初版：

1. 开始 / 胜利 / 失败流程。
2. 赐福选择界面强化。
3. HUD 与侧边栏整理。

### 做了什么

- 修改 `Main.tscn`：
  - 新增 `StartPanel`。
  - 新增 `ResultPanel`。
  - 赐福选择面板加高，支持显示构筑标签。
  - Controls 提示改为中文短提示。
- 修改 `main.gd`：
  - 增加 `run_started` / `run_ended` 状态。
  - 进入场景先显示开始界面，不直接生成战斗。
  - 点击 `开始游戏` 后生成玩家和房间 1。
  - 胜利/失败后显示结算面板。
  - 结算面板显示本局获得赐福。
  - `R` 和结算按钮均可重开。
  - 赐福三选一显示构筑标签。
- 修改 `data/blessings.json`：
  - 为 6 个赐福增加 `tags` 字段。
- 更新 `issue-tracker.md`：
  - UI Flow 相关问题标记为 In Progress。
- 更新 `milestones.md`：
  - UI 流程相关任务标记为已实现待复测。

### 下一步

用户复测：

1. 进入游戏是否先显示开始界面。
2. 点击开始后是否进入房间 1。
3. 三选一赐福是否显示构筑标签。
4. 胜利/失败后是否显示结算面板。
5. 结算面板是否显示本局赐福。
6. 重新开始按钮和 `R` 是否可用。
7. Debug 侧边栏是否仍默认隐藏并可按键显示。



## 2026-06-26：UI Flow Upgrade Spec

### 本次目标

按用户确认的顺序规划 UI 流程升级：

1. 开始 / 胜利 / 失败流程。
2. 赐福选择界面强化。
3. HUD 与侧边栏整理。

### 做了什么

- 新增 Spec：`specs/spec-008-ui-flow-upgrade.md`。
- 更新 `milestones.md`：M3 计划任务加入 UI 流程相关内容。
- 更新 `issue-tracker.md`：新增 UI Flow 相关问题。

### 下一步

按 Spec 先实现阶段 1：开始 / 胜利 / 失败流程。



## 2026-06-26：Debug 面板位置调整

### 本次目标

根据复测反馈，将赐福 Debug 面板整体再往右上角移动一点，减少对战斗区域的遮挡。

### 做了什么

- 修改 `Main.tscn`：
  - `AcquiredBlessingsPanel` 从 `760,16-1000,150` 调整到 `880,12-1130,146`。
  - `DebugPanel` 从 `760,164-1000,380` 调整到 `880,154-1130,370`。

### 下一步

用户复测面板位置是否更舒服。



## 2026-06-26：修正赐福 Debug 面板隐藏逻辑

### 本次目标

修正复测问题：赐福记录面板仍默认显示，且 `·` 键无法打开/关闭。

### 做了什么

- 修改 `Main.tscn`：
  - `AcquiredBlessingsPanel` 默认隐藏。
  - `DebugPanel` 保持默认隐藏。
- 修改 `main.gd`：
  - `_ready()` 强制隐藏两个赐福 Debug 面板，避免场景默认值或编辑器状态影响。
  - `toggle_debug_panel` 改为同时控制：
    - `AcquiredBlessingsPanel`
    - `DebugPanel`
  - 不再依赖 Godot 对 `·` 字符的 keycode 映射。
  - 直接监听 `` ` `` / `~` 所在物理按键，适配中文键盘上显示为 `·` 的情况。
- 修改 `controls.md` / `README.md`：
  - 说明该键位为 `` ` `` / `~` 所在键。

### 下一步

用户复测：

1. 进入游戏后右侧赐福相关面板是否全部隐藏。
2. 按键盘左上角 `` ` `` / `~` / `·` 所在键，是否显示两个面板。
3. 再按一次是否隐藏两个面板。
4. Debug 添加赐福按钮是否仍可用。



## 2026-06-26：Debug 面板改为按键映射触发

### 本次目标

修正 Debug 面板触发方式：不在画面上增加 `·` 按钮，而是映射键盘 `·` 按键，按下后显示/隐藏整个 Debug 面板。

### 做了什么

- 修改 `project.godot`：
  - 新增 `toggle_debug_panel` 输入动作。
  - 映射到 `·` 按键。
- 修改 `Main.tscn`：
  - 删除画面上的 `DebugToggle` 按钮。
  - `DebugPanel` 保持默认隐藏。
- 修改 `main.gd`：
  - 移除 `DebugToggle.pressed` 连接。
  - 在 `_process()` 中监听 `toggle_debug_panel`。
  - 按下后切换 Debug 面板显示状态。
- 修改 `controls.md` / `README.md`：
  - 记录 `·` 显示/隐藏 Debug 面板。

### 下一步

用户复测：

1. 进入游戏后 Debug 面板是否默认隐藏。
2. 按 `·` 是否展开 Debug 面板。
3. 再按 `·` 是否收起 Debug 面板。
4. Debug 面板按钮是否仍能添加赐福。



## 2026-06-26：Debug 面板收起与隐藏

### 本次目标

让 Debug 赐福面板默认隐藏，避免遮挡战斗画面；通过 `·` 按钮展开/收起。

### 做了什么

- 修改 `Main.tscn`：
  - 新增 `DebugToggle` 按钮，文本为 `·`。
  - `DebugPanel` 默认 `visible = false`。
- 修改 `main.gd`：
  - 连接 `DebugToggle.pressed`。
  - 增加 `_toggle_debug_panel()`，点击后切换 Debug 面板显示状态。

### 下一步

用户复测：

1. 进入游戏后 Debug 面板是否默认隐藏。
2. 点击 `·` 是否展开 Debug 面板。
3. 再点 `·` 是否收起 Debug 面板。
4. Debug 面板按钮是否仍能添加赐福。



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
