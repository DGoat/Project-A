# demo-godot-001-action-roguelite

Godot 2D action roguelite prototype generated with AI assistance.

## Idea

A top-down 2D room-based action roguelite. The player clears small combat rooms, then chooses one blessing from three options. Each blessing changes combat stats or behavior, creating a lightweight build loop inspired by action roguelites and card-style draft decisions.

## Core Loop

```text
Enter room
-> Fight enemies
-> Clear room
-> Choose 1 of 3 blessings
-> Build becomes stronger
-> Enter next room
-> Clear final room
-> Result screen
```

## First Playable Scope

- Top-down player movement
- Dash
- Basic attack
- Health and death state
- Two enemy types:
  - melee chaser
  - ranged shooter
- Three fixed rooms
- Blessing choice after room clear
- Six initial blessings
- Local-only, no API key required

## Controls

| Input | Action |
|---|---|
| WASD / Arrow Keys | Move |
| Left Mouse / J | Attack |
| Space | Dash |
| 1 / 2 / 3 | Pick blessing |
| R | Restart |
| ` / ~ key | Show / hide blessing debug panels |

## How to Run

Requires Godot 4.x.

```bash
# Open this folder in Godot
# Run Main.tscn
```

## AI Design

AI is used as production assistant for:

- blessing design
- enemy design
- room planning
- GDScript scaffolding
- tuning notes
- test case drafting

Runtime does not call AI.

## Files

```text
project.godot         Godot project config
scenes/Main.tscn      Main playable scene
scripts/              GDScript files
data/blessings.json   blessing data
config.example.json   demo config example
design.md             gameplay design notes
art-brief-001-toy-repair-prototype.md  first prototype art asset brief
art-prompt-pack-001-toy-repair-prototype.md  copy-ready image prompts
generation-notes.md   AI production notes
prompt.md             generation prompt
```

## Production Docs

| File | Purpose |
|---|---|
| `controls.md` | 操作映射、默认键位、可配置键位规划 |
| `design.md` | 玩法设计、标杆拆解、构筑方向 |
| `milestones.md` | 开发节点、完成标准、当前下一步 |
| `dev-log.md` | 实时开发日志，记录推进过程 |
| `issue-tracker.md` | 问题、解决方案、未解决项和后续计划 |
| `generation-notes.md` | AI 辅助生产记录 |
| `pitfalls.md` | 实现过程踩坑记录、原因、解决方式、预防措施 |
| `prompt.md` | 可复现 Prompt |
| `specs/spec-011-toy-art-asset-integration-01.md` | 第一批玩具修理屋美术资源接入 Spec |
| `tests/` | AI 辅助 smoke test 与测试说明 |
| `todo.md` | 后续动画、UI、地图、机关、构筑等待办列表 |

## Known Issues

- First toy repair art assets integrated, pending in-game review
- No audio yet
- No polished hit feedback yet
- Rooms are fixed, not procedural
