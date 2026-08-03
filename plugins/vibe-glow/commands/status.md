---
description: Read-only campaign status — stage, findings tallies, wave ledger, next move
---

Read-only. No captures, no writes, no agents. If it would mutate anything,
it does not belong here.

1. Read `.vibe-glow/state.json`. Missing → say there is no campaign here
   and point at `/vibe-glow:identity`. Broken → say which key is broken.

2. Read the findings register at `findingsRegisterPath` when set.

3. Render, in under 30 lines:
   - App, stage, adapter, themes, invariants (count + first line of each).
   - Findings tallies: open / shipped / clean, by lens and by severity.
   - Wave ledger: one line per wave — id, name, status, finding ids.
   - Top 3 open findings by severity × visibility.
   - The same next-move recommendation the router would give, one line.

Numbers come from the actual files read this invocation — never from
memory of a previous run.
