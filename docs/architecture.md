# Architecture

## Overview

Project-A separates game demos from reusable AI-assisted production infrastructure.

```text
demos/      independent game prototypes
packages/   reusable helper modules
configs/    shared example configs
schemas/    shared data contracts for generated content
prompts/    prompt templates for production tasks
replays/    examples and deterministic records when needed
```

## Current Positioning

Current stage: AI-assisted generated games.

AI is mainly used as production assistant for:

- brainstorming game ideas
- drafting design docs
- generating prototype code
- creating dialogue, quests, levels, and config data
- reviewing and refactoring code
- generating tests and bug reproduction notes
- preparing asset prompts and license notes

Not current focus:

- AI-native game mechanics
- live LLM NPCs inside runtime
- autonomous in-game agents
- dynamic AI directors

These can be future experiments after basic demo production workflow is stable.

## Principles

- Playable demo first, reusable workflow second
- Record prompts and generation process
- Human review before committing generated code/content
- No secrets in code or config
- Keep generated content traceable
- Every demo must explain how to run

## Production Flow

```text
Game Idea
  -> Prompt / AI-Assisted Draft
  -> Human Review
  -> Prototype Implementation
  -> Run / Test
  -> Fix / Refactor
  -> Record Generation Notes
  -> Screenshot / Demo Index
```

## Future Runtime AI Boundary

If a future demo needs runtime AI, use a provider boundary instead of calling external APIs directly from gameplay code. For now this is optional, not default foundation.
