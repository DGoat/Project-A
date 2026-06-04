# Demo Design

## Core Loop

1. Player does something
2. Game state updates
3. AI evaluates context
4. Game applies AI response
5. Player sees result

## Success Criteria

- Demo runs from clean checkout
- Demo works with mock provider
- AI output has stable schema
- Failure state is visible and debuggable

## Risks

- AI output unstable
- External API latency
- Cost and rate limits
- Hard-to-reproduce bugs without replay
