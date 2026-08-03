# vibe-glow

Take an app from working to wanted. vibe-glow runs a repeatable, multi-stage
UI/QOL beautification campaign: invent a design language, audit every surface
against it with independent review lenses, fix in verified waves, ship a
flagship reveal.

## The shape

| Stage | Command | Produces |
| --- | --- | --- |
| 0 | `/vibe-glow:identity` | The app's design language doc + invariants |
| 1 | `/vibe-glow:audit` | A skeptic-verified, ranked findings register |
| 2 | `/vibe-glow:wave` | Shipped fix batches, re-reviewed until clean |
| 3 | `/vibe-glow:reveal` | The flagship release |

`/vibe-glow` routes; `/vibe-glow:status` reports. No stage ever auto-fires.

## Operating laws

- Review agents run on Opus; every finding faces a skeptic before it becomes work.
- Per-app invariants outrank findings. If the app has user theming, color
  belongs to the user — identity lives in structure.
- Evidence (screenshots) stays out of git; state, design language, and the
  findings register are committed.
- Structure only changes through the target repo's own discipline: branches,
  tests, review gates.

## v0.1 scope

Commands + two evidence adapters (winui-powershell, web-playwright). No
loggers, no evolve pass — those arrive after the first dogfood campaign
(626 Mod Launcher) proves the shape.
