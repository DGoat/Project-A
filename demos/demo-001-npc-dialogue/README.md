# demo-001-npc-dialogue

Text dialogue prototype generated with AI assistance.

## Idea

Create a small dialogue scene around one blacksmith NPC. Current goal is to use AI to help produce the writing, structure, config, and implementation, not to require live AI inside the game runtime.

## Initial NPC

- Name: Harlan
- Role: Village blacksmith
- Personality: grumpy, honest, protective
- Goal: protect the village and sell reliable weapons

## Features

- AI-assisted dialogue writing
- Structured dialogue data
- Prompt stored for reproducible generation
- Future optional support for live LLM runtime

## How to Run

Not implemented yet. First implementation should run locally without API keys.

## Production Design

AI may assist with:

- NPC profile drafting
- dialogue line generation
- quest hook ideas
- code scaffolding
- test case drafting

Generated content should be reviewed before it becomes final game data.

## Example Dialogue Data

```json
{
  "speaker": "Harlan",
  "line": "A sword, eh? I sell steel that does not snap in the first goblin skull it meets.",
  "emotion": "neutral",
  "tags": ["shop", "weapon"]
}
```

## Known Issues

- Runtime not implemented yet
