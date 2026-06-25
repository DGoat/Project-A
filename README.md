# Project-A

AI-assisted game demo lab.

Project-A 用于制作、沉淀和展示 AI 辅助生成的游戏 demo。现阶段重点不是 AI 原生游戏玩法，而是把 AI 用作生产工具，辅助完成玩法原型、代码、关卡、剧情、素材说明、配置和测试记录。当前 demo 生产分为两条路线：一条是使用 Unreal Engine 的动作类 3D demo，另一条是使用 Godot 的偏 2D 玩法 demo。未来可以探索 AI 原生机制，但当前优先保证 demo 可生成、可运行、可复现。

## Demo Tracks

| Track | Engine | Focus | Best For |
|---|---|---|---|
| Action 3D | Unreal Engine | 动作、战斗、镜头、角色控制、打击反馈 | 动作原型、第三人称战斗、Boss/敌人行为实验 |
| 2D Gameplay | Godot | 轻量玩法、系统规则、关卡、UI、快速迭代 | 2D/2.5D、卡牌、解谜、Roguelike、经营、叙事 |

## Goals

- Use AI to assist game demo production
- Build reusable workflows for prototype generation
- Make small playable demos quickly
- Keep every demo runnable and reproducible
- Record prompts, decisions, assets, and generated outputs clearly

## Quick Start

当前仓库处于基建阶段。先从 demo 模板开始：

```bash
# 复制 demos/demo-template，创建新 demo
# 根据 demo README 补齐运行方式
```

## Demo List

| Demo | Track | Engine | Description | Status |
|---|---|---|---|---|
| `demos/demo-template` | Shared | Any | Standard template for new AI-assisted game demos | Ready |
| `demos/demo-ue-001-action-combat` | Action 3D | Unreal Engine | Third-person action combat prototype | Planned |
| `demos/demo-godot-001-action-roguelite` | 2D Gameplay | Godot | Top-down 2D action roguelite prototype | In Progress |

## Foundation

- Standard demo structure
- AI-assisted production workflow
- Prompt and config conventions
- Generation notes and replay examples
- CI placeholder
- Roadmap and demo index

## Project Rules

- Every demo must be runnable
- Every demo must include `README.md`
- Record how AI was used to generate or modify content
- No API keys or secrets committed
- Use `.env.example` and `config.example.json` for examples
- Keep assets license clear
- Label generated content and third-party assets

## Docs

- [`docs/roadmap.md`](docs/roadmap.md)
- [`docs/demo-index.md`](docs/demo-index.md)
- [`docs/architecture.md`](docs/architecture.md)
- [`docs/experiment-log.md`](docs/experiment-log.md)
- [`docs/spec-first.md`](docs/spec-first.md)
