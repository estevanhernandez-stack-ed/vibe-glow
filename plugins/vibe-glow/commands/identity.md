---
description: Stage 0 — invent the app's design language, stress-tested against its theming
---

Stage 0 of a vibe-glow campaign. Output: a committed design-language doc the
whole campaign measures against, plus `.vibe-glow/state.json`. Resumable: if
state exists with `stage: "identity"`, pick up at the first incomplete step
below instead of restarting.

## 1. Interview (one question at a time)

- Confirm the target app and repo root.
- Pick the evidence adapter: XAML files present → `winui-powershell`;
  package.json with a web framework, or a Streamlit app → `web-playwright`.
  Confirm the pick; read that adapter's README before any capture.
- Capture invariants: does the app have user theming, frozen brand tokens,
  accessibility floors, or any system that owns part of the visual surface?
  Each becomes an entry in `invariants` — format
  `"<rule> — <consequence for reviewers>"`. If the app has user theming, the
  first invariant is always some form of: color belongs to the theme system;
  identity lives in structure (type, spacing, shape, iconography, motion);
  token-contract extensions must be optional-with-fallback.
- Confirm the evidence dir (default `docs/ui-evidence`) and that it is
  gitignored in the target repo — add the gitignore entry if missing.

## 2. Baseline capture

Enumerate the app's surfaces (views, dialogs, panels) into a capture
checklist committed under the target repo's docs. Then capture per the
adapter README: every reachable surface, under the app's current default
look plus 1–2 hostile user themes when theming exists. Name files
`NN-<surface>--<theme>.png`. Modal/interactive surfaces may need the user
driving — schedule one guided session rather than fighting automation.

## 3. Concept boards (2–3)

Build 2–3 self-contained HTML boards, each a distinct identity hypothesis
for the app's chrome. When a `frontend-design` skill is available in the
session, load it before building — it is the taste layer for this step.
Requirements, all of them:

- Wired to the app's real theme tokens where theming exists, with a working
  theme switcher covering the captured themes — a concept that only works
  under one palette is disqualified by construction.
- Each board covers: type ramp, spacing scale, corner/shape language,
  iconography direction, motion notes (durations/easings as text), and a
  flagship theme proposal (a token set, not hardcoded surface colors).
- Structure-first: the identity must read through layout, weight, and shape
  even with the palette swapped.
- Publish the boards for side-by-side review (browser tabs or artifacts).

## 4. Gate — the user picks

Present the boards, ask for a pick (or a hybrid with named parts). Do not
proceed on silence.

## 5. Write it down

- Design-language doc at
  `docs/superpowers/specs/YYYY-MM-DD-<app>-design-language.md` (target
  repo), sections: identity statement (one paragraph), type ramp, spacing
  scale, shape language, iconography, motion, flagship theme tokens,
  component rules (buttons, rows, dialogs, tags, empty states), copy rules
  (inherit the repo's voice doc if one exists), invariants (verbatim from
  state).
- Write `.vibe-glow/state.json` per `docs/state-schema.md`: `stage: "audit"`,
  chosen adapter, evidence dir, design-language path, themes list,
  invariants.
- Commit both on a branch per the target repo's conventions; PR if the repo
  works by PR.

Announce the gate is closed and recommend `/vibe-glow:audit` — but do not
run it.
