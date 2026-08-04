---
description: Read-only campaign status — stage, scope, findings tallies, wave ledger, next move
---

Read-only. No captures, no writes, no agents. If it would mutate anything,
it does not belong here.

1. Read `.vibe-glow/state.json`. Missing → say there is no campaign here
   and point at the concierge (`/vibe-glow:vibe-glow`). Broken → say which
   key is broken.

2. Read the findings register at `findingsRegisterPath` when set.

3. Render, in under 30 lines:
   - App, stage, scope (area + goal, or "app-wide"), adapter, themes,
     invariants (count + first line of each).
   - Findings tallies: open / shipped / clean, by lens and by severity —
     derived from the register's rows read this invocation, never from
     wave summaries or memory of a previous run.
   - Wave ledger: one line per wave — id, name, status, finding ids.
   - Top 3 open findings by severity × visibility (goal-weighted when
     scoped).
   - The same next-move recommendation the concierge would give, one line.
