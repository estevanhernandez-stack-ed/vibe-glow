# vibe-glow

Take an app from working to wanted. vibe-glow runs a repeatable, gated
UI/QOL beautification campaign — app-wide with an invented design
language, or scoped to one area with a goal in your own words.

## Start here

One call: `/vibe-glow:vibe-glow` (the concierge — harness namespacing puts
every plugin command behind the plugin's own prefix, so this IS the bare
entry point). It asks whether you want a full glow-up or a focused fix,
gathers what it needs, and runs each stage after you say yes. You never
need to know a stage name.

## The shape underneath

| Stage | Command | Produces |
| --- | --- | --- |
| 0 | `/vibe-glow:identity` | The measuring stick — a design language (app-wide) or a conventions brief (scoped) |
| 1 | `/vibe-glow:audit` | A skeptic-verified, ranked findings register |
| 2 | `/vibe-glow:wave` | Shipped fix batches, re-reviewed until clean |
| 3 | `/vibe-glow:reveal` | The flagship release (app-wide) or a goal-check close-out (scoped) |

`/vibe-glow:status` reports, read-only. Every command can be run directly;
the concierge just saves you from having to know that.

## Operating laws

- Review agents run on Opus; every finding faces a skeptic before it
  becomes work.
- Per-app invariants outrank findings. If the app has user theming, color
  belongs to the user — identity lives in structure.
- Scoreboard claims re-derive from register rows, never carry forward.
- Evidence (screenshots) stays out of git; state, measuring sticks, and
  the findings register are committed.
- Consent is per stage: one yes runs one stage. Nothing auto-advances.

## v0.2 scope

Concierge entry, scoped campaigns, UIA-driven capture (`-Uia` route maps,
`-DumpUia` trees, sample.py pixel sampling), and the first campaign's
retro folded into the command texts. Still deferred until earned: loggers,
an evolve pass, adapters beyond winui-powershell and web-playwright.
