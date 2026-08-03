---
description: Stage 3 — the flagship release: identity flip, signature moments, marketing beat
---

Stage 3 of a vibe-glow campaign. Preconditions: every severity-4+ finding
in the register is `clean`, or the user explicitly waives the stragglers
(list them and get the waiver in so many words).

## 1. The flagship layer

Apply the design language's flagship visual layer through the app's own
theming mechanism — for apps with user theming that means shipping it as a
new default theme/token set, never as hardcoded surface values (the
invariant holds to the end). Include the signature moments the design
language names (motion, glow, hero touches on the primary surfaces). Each
code change rides the same discipline as a wave: branch, tests or smoke
entries, review gate, merge.

## 2. The release

Follow the target repo's own release flow end to end. Regenerate
listing/marketing screenshots from the evidence pipeline under the flagship
theme. If the repo has a release-notes agent or template, use it; the
reveal note leads with what changed visually and why the app's users should
care, in the repo's voice.

## 3. Close the campaign

- State: `stage: "done"`.
- Write a short campaign retro (what the audit missed, what waves fought,
  what the adapter couldn't capture) to the vibe-glow repo's
  `docs/dogfood/<app>-<date>.md` — this file is the input to vibe-glow's
  first hardening pass.
- Commit state in the target repo; commit the retro in vibe-glow.

Recommend `/vibe-glow:status` for the record. The campaign is over; say so.
