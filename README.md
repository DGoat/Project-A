# Project-A

AI-assisted game demo lab.

Project-A 用于制作、沉淀和展示 AI 辅助生成的游戏 demo。现阶段重点不是 AI 原生游戏玩法，而是把 AI 用作生产工具，辅助完成玩法原型、代码、关卡、剧情、素材说明、配置和测试记录。未来可以探索 AI 原生机制，但当前优先保证 demo 可生成、可运行、可复现。

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

| Demo | Description | Status |
|---|---|---|
| `demos/demo-template` | Standard template for new AI-assisted game demos | Ready |
| `demos/demo-001-npc-dialogue` | Text dialogue prototype generated with AI assistance | Planned |

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
