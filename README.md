# Project-A

AI game demo lab.

Project-A 用于制作、沉淀和展示 AI 游戏 demo。目标是快速验证 AI 驱动玩法，同时保留可复用的基础能力：AI Provider、Prompt、配置、回放、测试和 demo 模板。

## Goals

- Explore AI-driven game mechanics
- Build reusable AI gameplay components
- Make playable demos quickly
- Keep every demo runnable and reproducible

## Quick Start

当前仓库处于基建阶段。先从 demo 模板开始：

```bash
# 复制 demos/demo-template，创建新 demo
# 根据 demo README 补齐运行方式
```

## Demo List

| Demo | Description | Status |
|---|---|---|
| `demos/demo-template` | Standard template for new demos | Ready |
| `demos/demo-001-npc-dialogue` | LLM NPC dialogue with mock provider first | Planned |

## Foundation

- Standard demo structure
- AI provider abstraction plan
- Mock-first development rule
- Prompt and config conventions
- CI placeholder
- Roadmap and demo index

## Project Rules

- Every demo must be runnable
- Every demo must include `README.md`
- No API keys or secrets committed
- Use `.env.example` and `config.example.json` for examples
- Prefer mock/replay provider for tests and screenshots
- Keep assets license clear

## Docs

- [`docs/roadmap.md`](docs/roadmap.md)
- [`docs/demo-index.md`](docs/demo-index.md)
- [`docs/architecture.md`](docs/architecture.md)
- [`docs/experiment-log.md`](docs/experiment-log.md)
