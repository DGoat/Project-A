# 踩坑记录（Pitfalls）

## 记录目的

这个文档专门记录实现过程中踩过的坑、原因、解决方式和后续预防措施。

它和其他文档的区别：

| 文档 | 记录重点 |
|---|---|
| `dev-log.md` | 每次推进做了什么 |
| `issue-tracker.md` | 当前问题、状态、优先级 |
| `pitfalls.md` | 已踩过的坑、根因、经验教训 |
| `milestones.md` | 阶段节点和完成标准 |

目标：

```text
同样的坑不要踩第二次。
```

---

## 记录格式

每个坑按以下格式记录：

```md
## PIT-编号：标题

### 现象

发生了什么？用户或开发者看到什么？

### 原因

根因是什么？

### 解决方式

怎么解决的？

### 预防措施

下次怎么避免？

### 关联文件

- `path/to/file`

### 关联问题

- `issue-tracker.md` 中的问题 ID
```

---

## PIT-001：Winget 安装 Godot 后当前终端找不到 `godot`

### 现象

安装 Godot 后执行：

```bash
godot --version
```

返回：

```text
'godot' 不是内部或外部命令，也不是可运行的程序
或批处理文件。
```

### 原因

Winget 安装时修改了 PATH，但当前终端没有刷新环境变量。

Godot 实际已经安装成功，只是当前 shell 还不知道新路径。

### 解决方式

先找到实际安装路径：

```text
C:\Users\wb.zhanghuaxia02\AppData\Local\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7-stable_win64.exe
```

然后用完整路径验证：

```bash
"C:\Users\wb.zhanghuaxia02\AppData\Local\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7-stable_win64.exe" --version
```

结果：

```text
4.7.stable.official.5b4e0cb0f
```

### 预防措施

- Winget 安装后重启终端。
- 不依赖当前终端的 PATH，先用完整路径验证。
- 对便携工具可以建立固定目录和 `.bat` 别名。

### 关联文件

- `dev-log.md`
- `issue-tracker.md`

### 关联问题

- `GODOT-002`

---

## PIT-002：误以为 Godot 需要迁移完整安装目录

### 现象

用户希望把 Godot 从 Winget 安装目录迁移到：

```text
F:\Godot
```

最初只复制了主程序：

```text
Godot_v4.7-stable_win64.exe
```

但用户期望迁移“整个 Godot”。

### 原因

Godot Windows 标准版本体很轻量，Winget 安装目录里实际只有：

```text
Godot_v4.7-stable_win64.exe
Godot_v4.7-stable_win64_console.exe
```

但“整个 Godot”容易被理解为还包括用户设置、缓存、项目列表、导出模板等内容。

### 解决方式

复制两个可执行文件到：

```text
F:\Godot
```

并创建别名：

```text
F:\Godot\godot.bat
F:\Godot\godot_console.bat
```

验证：

```bash
F:\Godot\godot.bat --version
F:\Godot\godot_console.bat --version
```

### 预防措施

迁移工具前先区分：

- 程序本体
- 用户配置
- 缓存
- 导出模板
- PATH / alias
- 包管理器记录

### 关联文件

- `dev-log.md`
- `issue-tracker.md`

### 关联问题

- `GODOT-002`

---

## PIT-003：Godot 项目打开后看起来空空如也

### 现象

用户打开 Godot 项目后，编辑器界面看起来没有游戏内容。

### 原因

Godot 打开项目后，不等于已经进入运行状态。

需要明确：

- 打开项目目录
- 打开主场景 `Main.tscn`
- 切到 2D 视图
- 运行场景或项目

如果只在编辑器里看默认视图，可能会觉得空。

### 解决方式

指导用户打开：

```text
scenes/Main.tscn
```

然后运行。

### 预防措施

README 中需要明确运行步骤：

1. 用 Godot 打开 demo 文件夹。
2. 双击 `scenes/Main.tscn`。
3. 点击运行或按 `F5`。
4. 如果询问主场景，选择 `scenes/Main.tscn`。

### 关联文件

- `README.md`
- `scenes/Main.tscn`

### 关联问题

- `DEMO-001`

---

## PIT-004：Godot 4.7 打开项目时提示从 4.2 升级

### 现象

Godot 弹窗提示：

```text
该项目最近一次编辑使用的是 Godot 4.2，打开后将修改为 Godot 4.7。
```

### 原因

初始 `project.godot` 中写过：

```text
config/features=PackedStringArray("4.2")
```

但当前安装版本是 Godot 4.7。

### 解决方式

允许 Godot 升级项目元信息。

项目是新建 demo，没有复杂插件和导入资源，风险较低。

### 预防措施

- 新建 Godot 项目时，记录实际使用版本。
- README 中明确 Godot 版本要求。
- 如果团队协作，统一 Godot 版本。

### 关联文件

- `project.godot`
- `README.md`

### 关联问题

- `GODOT-003`

---

## PIT-005：Git 状态中出现 Godot 自动生成文件

### 现象

打开 Godot 项目后，Git 状态出现：

```text
.godot/
*.gd.uid
```

### 原因

Godot 4 会生成编辑器缓存、导入缓存和脚本 UID 文件。

其中部分文件不应该提交到当前仓库，尤其是 `.godot/` 这类本地缓存目录。

### 解决方式

更新 `.gitignore`：

```gitignore
.godot/
*.gd.uid
```

### 预防措施

项目创建早期就补充引擎相关忽略规则。

建议保留：

```gitignore
.import/
.godot/
*.gd.uid
.export/
```

### 关联文件

- `.gitignore`

### 关联问题

- 暂无单独 issue，可后续补充为 `GIT-001`

---

## PIT-006：文档更新后容易忘记同步远程 Git

### 现象

项目频繁新增/更新文档，如果不及时确认同步，远程仓库可能落后于本地。

### 原因

文档更新通常不像代码变更那样明显，容易忽略提交。

### 解决方式

建立协作规则：

每次出现以下情况，完成后都询问是否同步远程 Git：

- 新建文档
- 更新文档
- 改代码/配置
- 完成节点
- 修复问题

### 预防措施

在每次最终回复中主动提示：

```text
是否需要同步到远程 Git 仓库？
```

### 关联文件

- `dev-log.md`
- `issue-tracker.md`

### 关联问题

- 暂无单独 issue，可后续补充为 `GIT-002`

---

## PIT-007：中大型改动如果不先写 Spec，容易范围膨胀

### 现象

讨论键位配置、手感系统、祝福系统时，容易从一个小功能扩展到多个系统。

### 原因

中大型改动会同时影响：

- 玩法设计
- UI
- 输入系统
- 数据结构
- 存档/配置
- 文档
- 测试方式

如果直接写码，容易边做边扩。

### 解决方式

建立 Spec 先行规范：

```text
中、大型改动必须先产出 Spec，再动手写码。
```

### 预防措施

以下任务必须先写 Spec：

- 可配置键位系统
- Controls/Settings UI
- Hit Stop + 击退 + 无敌帧手感包
- 祝福系统升级
- 房间系统重构
- Boss / 精英敌人行为
- 本地配置保存
- 手柄支持

### 关联文件

- `docs/spec-first.md`

### 关联问题

- 暂无单独 issue，可后续补充为 `SPEC-001`
