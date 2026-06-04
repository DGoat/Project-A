# Architecture

## Overview

Project-A separates playable demos from reusable AI/game infrastructure.

```text
demos/      independent game prototypes
packages/   reusable modules
configs/    shared example configs
schemas/    shared data contracts
prompts/    shared prompt templates
replays/    deterministic replay examples
```

## Principles

- Demo first, reusable second
- Mock provider first, real API later
- No secrets in code or config
- Structured AI output where possible
- Replay important AI interactions
- Every demo must explain how to run

## AI Provider Boundary

Target interface:

```ts
interface AIProvider {
  chat(input: ChatInput): Promise<ChatOutput>
  embed?(input: EmbedInput): Promise<EmbedOutput>
}
```

Provider types:

| Provider | Purpose |
|---|---|
| `mock` | Run without API keys or network |
| `openai-compatible` | Support OpenAI-compatible APIs |
| `local-llm` | Support local runtimes like Ollama or LM Studio |
| `replay` | Make tests and recordings deterministic |

## Demo Runtime Flow

```text
Player Input
  -> Game State
  -> Prompt / AI Request
  -> AI Provider
  -> Structured Output
  -> Validation
  -> Game Action
  -> Log / Replay
```
