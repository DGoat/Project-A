# AI 辅助测试

本目录存放当前 Demo 的轻量自动化测试脚本。

## smoke_test.gd

用途：快速检查关键场景、输入映射和核心战斗脚本是否还能运行。

覆盖范围：

- InputMap 是否包含移动、攻击、Dash、重开、三选一动作。
- `Main.tscn` 是否能加载。
- 开始流程是否能生成玩家和敌人。
- 玩家是否有 `Camera2D` 和 `AttackSprite`。
- 玩家 Dash 是否能产生高于普通移动的速度。
- 攻击矩形判定是否能和攻击范围参数同步。
- 远程敌人在距离玩家较远时是否会移动。

## 运行方式

```bat
"C:\Users\wb.zhanghuaxia02\AppData\Local\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7-stable_win64_console.exe" --headless --path "D:\FORK\specskill\Project-A\demos\demo-godot-001-action-roguelite" --script "res://tests/smoke_test.gd"
```

成功输出：

```text
AI_TEST_PASS
```

失败输出：

```text
AI_TEST_FAIL
```

## 限制

- 这是脚本级 smoke test，不替代真人手测。
- 不能判断画面美感、攻击表现方向是否符合直觉、敌人压力是否合适。
- 适合每次改代码或资源接入后快速查“有没有坏掉”。
