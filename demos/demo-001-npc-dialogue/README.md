# demo-001-npc-dialogue

NPC dialogue demo with personality, memory, and mock-first AI provider.

## Idea

Player talks to an NPC. NPC replies according to role, personality, current emotion, memory, and quest state.

## Initial NPC

- Name: Harlan
- Role: Village blacksmith
- Personality: grumpy, honest, protective
- Goal: protect the village and sell reliable weapons

## Features

- Mock dialogue response first
- Structured NPC response schema
- Prompt stored outside code
- Future support for real LLM provider

## How to Run

Not implemented yet. First implementation should run without API keys using mock provider.

## AI Design

Input:

- player message
- NPC profile
- recent dialogue history
- memory snippets
- world state

Output:

```json
{
  "dialogue": "NPC line",
  "emotion": "neutral",
  "memoryWrite": [],
  "questHooks": [],
  "actions": []
}
```

## Known Issues

- Runtime not implemented yet
