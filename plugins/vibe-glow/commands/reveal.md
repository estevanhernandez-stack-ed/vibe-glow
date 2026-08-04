---
description: Stage 3 — the flagship release app-wide, a goal-check close-out scoped
---

Stage 3 of a vibe-glow campaign. On entry, set `stage: "reveal"` in state.

Preconditions — **re-derive from the register's rows, never from wave
summaries** (this adversarial check once saved a campaign from a false
scoreboard): every severity-4+ finding is `clean`, or the user explicitly
waives the stragglers (list them, get the waiver in so many words).

## App-wide: the flagship

1. Apply the design language's flagship visual layer through the app's own
   theming mechanism — for apps with user theming that means a new default
   theme/token set, never hardcoded surface values (the invariant holds to
   the end). Include the signature moments the design language names. Each
   code change rides the same discipline as a wave: branch, tests or smoke
   entries, review gate, merge.
2. Follow the target repo's own release flow end to end. Regenerate
   listing/marketing screenshots from the evidence pipeline under the
   flagship theme. If the repo has a release-notes agent or template, use
   it; the reveal note leads with what changed visually and why users
   should care, in the repo's voice.

## Scoped: the close-out

No flagship, no marketing beat — flagships are app-wide by nature.

1. Final re-capture of the scoped surfaces, all themes.
2. Goal-check: against the register's closed findings and the conventions
   brief, state plainly whether the area now serves the user's goal —
   cite finding ids, not vibes.
3. Ship whatever release the target repo's own cadence calls for.

## Close the campaign (both modes)

- State: `stage: "done"`.
- Write a campaign retro (what the audit missed, what waves fought, what
  the adapter couldn't capture) to the vibe-glow repo's
  `docs/dogfood/<app>-<date>.md` — input to the next hardening pass.
- Commit state in the target repo; commit the retro in vibe-glow.

Recommend the status view for the record. The campaign is over; say so.
