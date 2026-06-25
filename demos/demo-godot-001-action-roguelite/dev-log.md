# 开发日志（Dev Log）

## 记录规则

每次推进后记录：

- 时间
- 本次目标
- 做了什么
- 遇到什么问题
- 如何解决
- 仍未解决什么
- 下一步

---

## 2026-06-25：创建 Godot 2D 动作 Roguelite Demo

### 本次目标

启动 Project-A 的 Godot 2D Gameplay 路线，创建第一个可运行 Demo：`demo-godot-001-action-roguelite`。

### 做了什么

- 创建 Godot Demo 目录。
- 创建 `project.godot`。
- 创建 `Main.tscn`。
- 创建玩家、近战敌人、远程敌人、子弹场景。
- 创建 GDScript：
  - `scripts/main.gd`
  - `scripts/player.gd`
  - `scripts/melee_enemy.gd`
  - `scripts/ranged_enemy.gd`
  - `scripts/projectile.gd`
- 创建祝福数据：`data/blessings.json`。
- 创建设计文档：`design.md`。
- 创建生成记录：`generation-notes.md`。
- 创建 Prompt：`prompt.md`。
- 更新仓库级文档：
  - `README.md`
  - `docs/architecture.md`
  - `docs/roadmap.md`
  - `docs/demo-index.md`

### 遇到的问题

1. 本机最初没有 Godot 命令。
2. Winget 安装后当前终端无法直接识别 `godot`。
3. Godot 打开项目时提示项目上次编辑版本为 4.2，将升级到 4.7。
4. 用户进入编辑器后看到画面空，未明确当前应打开/运行哪个场景。

### 如何解决

1. 使用 Winget 安装 Godot 4.7。
2. 找到 Godot 实际安装路径：

```text
C:\Users\wb.zhanghuaxia02\AppData\Local\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7-stable_win64.exe
```

3. 使用完整路径验证 Godot 版本：`4.7.stable.official.5b4e0cb0f`。
4. 使用 Godot 无头模式验证项目可加载。
5. 将 Godot 可执行文件复制到 `F:\Godot`，并创建：

```text
F:\Godot\godot.bat
F:\Godot\godot_console.bat
```

6. 指导用户打开 `scenes/Main.tscn` 并运行。

### 仍未解决

- 尚未完成完整 3 房间流程手测。
- 尚未确认玩家攻击、敌人死亡、祝福选择、胜利条件是否全部正常。
- Godot 画面中出现了异常图片/贴图显示，需要确认是否来自编辑器缓存、场景渲染问题或外部资源误导入。
- 尚未做手感强化。

### 下一步

推进 M1：完整手测 First Playable。

手测重点：

1. 玩家移动是否正常。
2. 攻击是否能命中敌人。
3. 闪避是否正常。
4. 清房后是否弹出祝福。
5. 选择祝福后是否进入下一房间。
6. 房间 3 清理后是否胜利。
7. 死亡后 `R` 是否重开。
8. 记录所有报错和手感问题。

---

## 2026-06-25：补充标杆游戏拆解与开发节点

### 本次目标

把标杆游戏拆解、差异化时机和开发关键节点写入项目文档。

### 做了什么

- 将 `design.md` 改成中文为主 + 英文术语。
- 补充标杆拆解：
  - Hollow Knight / Silksong
  - Slay the Spire
  - Warm Snow
  - Hades
- 补充 First Prototype 成功标准。
- 补充 Core Feel Targets。
- 补充 Prototype Design Risks。
- 补充 Build Route Targets。
- 补充 Milestones：M0-M5。
- 创建独立节点文档：`milestones.md`。
- 创建开发日志：`dev-log.md`。
- 创建问题追踪文档：`issue-tracker.md`。

### 遇到的问题

- 设计文档原本是英文，不利于策划持续维护。
- 节点、问题、解决方案没有结构化记录。

### 如何解决

- 采用“中文为主 + 英文术语”的文档策略。
- 将节点、日志、问题拆成三份文档：
  - `milestones.md`：记录开发阶段和完成标准。
  - `dev-log.md`：记录每轮推进。
  - `issue-tracker.md`：记录问题、状态、解决方案和后续计划。

### 仍未解决

- `issue-tracker.md` 需要随着后续测试继续补充。
- M1 仍需实际手测确认。

### 下一步

继续 M1 手测与修复。
