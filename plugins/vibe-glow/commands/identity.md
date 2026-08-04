---
description: Stage 0 — the app's measuring stick: invent a design language, or extract conventions for a scoped fix
---

Stage 0 of a vibe-glow campaign. Output: a committed measuring-stick doc
(design language app-wide, conventions brief scoped) plus
`.vibe-glow/state.json`. Answers already collected by the concierge (area,
goal) pass in — never re-ask them. Resumable: if state exists with
`stage: "identity"`, pick up at the first incomplete step.

## 1. Interview (one question at a time)

- Confirm the target app and repo root.
- Pick the evidence adapter: XAML/WPF/Win32 present → `winui-powershell`;
  package.json with a web framework, or a Streamlit app → `web-playwright`.
  Confirm the pick; read that adapter's README before any capture.
- Capture invariants: does the app have user theming, frozen brand tokens,
  accessibility floors, or any system that owns part of the visual surface?
  Each becomes an entry in `invariants` — format
  `"<rule> — <consequence for reviewers>"`. If the app has user theming, the
  first invariant is always some form of: color belongs to the theme system;
  identity lives in structure; token-contract extensions must be
  optional-with-fallback.
- Confirm the evidence dir (default `docs/ui-evidence`) and that it is
  gitignored in the target repo — add the gitignore entry if missing.
- **Write `.vibe-glow/state.json` NOW** per `docs/state-schema.md`:
  `stage: "identity"`, the chosen adapter, evidence dir, themes, invariants,
  and `scope` when this is a focused campaign. Commit it. A session that
  dies past this point resumes instead of restarting.

## 2. Baseline capture

If the target repo already has a capture checklist, use it — do not
enumerate fresh. Otherwise enumerate the relevant surfaces into a committed
checklist. Scope rule: an app-wide campaign captures every reachable
surface; a scoped campaign captures the surfaces in `scope.surfaces` plus
one hop of visual neighbors — the surfaces a user reaches the area from —
as context for the consistency lens. Capture per the adapter README, under
the app's current default look plus 1–2 hostile user themes when theming
exists. Name files `NN-<surface>--<theme>.png`.

## 3a. App-wide: concept boards (2–3)

Build 2–3 self-contained HTML boards, each a distinct identity hypothesis
for the app's chrome. When a `frontend-design` skill is available in the
session, load it before building — it is the taste layer for this step.
Requirements, all of them:

- Wired to the app's real theme tokens where theming exists, with a working
  theme switcher covering the captured themes — a concept that only works
  under one palette is disqualified by construction.
- Each board covers: type ramp, spacing scale, corner/shape language,
  iconography direction, motion notes, and a flagship theme proposal (a
  token set, not hardcoded surface colors).
- Structure-first: the identity must read through layout, weight, and shape
  even with the palette swapped.
- Publish the boards for side-by-side review.

Then the gate: the user picks (or names a hybrid). Do not proceed on
silence. Write the design language doc at
`docs/superpowers/specs/YYYY-MM-DD-<app>-design-language.md`: identity
statement, type ramp, spacing scale, shape language, iconography, motion,
flagship theme tokens, component rules, copy rules, invariants verbatim.

## 3b. Scoped: extract, don't invent

No boards, no invention. Read the captured evidence and write a
**conventions brief** at
`docs/superpowers/specs/YYYY-MM-DD-<app>-<area>-conventions.md`:

- What the app already does — observed type, spacing, component patterns,
  interaction idioms — stated as rules the area must conform to.
- The user's goal, verbatim, as the north star. Every later finding argues
  conformance-to-conventions or progress-toward-goal, never taste.
- Invariants, verbatim from state.

Gate: the user approves the brief before stage 0 closes.

## 4. Close the stage

Update `.vibe-glow/state.json`: `designLanguagePath` (either artifact),
`stage: "audit"`. Commit the measuring-stick doc + state on a branch per
the target repo's conventions; PR if the repo works by PR. Announce the
gate is closed and recommend the audit — but do not run it (the concierge
handles run-next consent).
