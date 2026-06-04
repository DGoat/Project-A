# demo-001-npc-dialogue Design

## Core Loop

1. Player enters text
2. Game builds NPC context
3. AI provider generates structured response
4. Response is validated
5. NPC line is shown
6. Memory and quest hooks update state

## MVP Scope

- One NPC
- One player
- Text-only interface
- Mock provider response
- JSON response validation by shape

## Later Scope

- Multiple NPCs
- Long-term memory
- Emotion transitions
- Quest trigger system
- Local LLM and OpenAI-compatible provider
