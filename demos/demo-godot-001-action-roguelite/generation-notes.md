# Generation Notes

## Goal

Create the first Godot 2D gameplay track demo for Project-A.

## Human Direction

User prefers games such as:

- Hollow Knight
- Silksong
- Slay the Spire
- Warm Snow
- Hades

Direction selected:

```text
Top-down 2D action roguelite + three-choice build draft
```

## AI Assistance Used

AI helped define:

- gameplay category
- first playable scope
- core loop
- enemy types
- blessing pool
- file structure
- initial Godot implementation plan

## Scope Control

First playable intentionally avoids:

- metroidvania map
- platform jumping
- complex boss design
- large content pool
- procedural generation
- runtime AI calls

## Benchmark References

The design document was expanded with benchmark analysis from:

- Hollow Knight / Silksong: readable action, enemy wind-up, spacing, precision feel
- Slay the Spire: three-choice draft, build direction, readable effects
- Warm Snow: 2D room combat, fast clear-reward rhythm, build synergies
- Hades: room pacing, boon identity, enemy pressure through movement

The demo uses these as mechanical references, not theme/content copies.

## Next Steps

1. Run M1 manual test in Godot
2. Record test findings in `dev-log.md`
3. Track bugs and unresolved work in `issue-tracker.md`
4. Update milestone status in `milestones.md`
5. Fix blocking issues before entering M2 game-feel work
