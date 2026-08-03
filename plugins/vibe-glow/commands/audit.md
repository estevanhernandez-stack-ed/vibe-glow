---
description: Stage 1 — five Opus review lenses over every surface, skeptic-verified findings register
---

Stage 1 of a vibe-glow campaign. Preconditions: `.vibe-glow/state.json` with
`stage: "audit"` and a committed design-language doc at `designLanguagePath`.
If evidence is stale (surfaces changed since capture), refresh per the
adapter README before reviewing.

## Cost gate

This stage runs ~10–14 Opus agents (five lenses + one skeptic per surviving
finding). State that plainly with a rough token expectation and get an
explicit go. No go, no run.

## The five lenses

Run as parallel review agents, each pinned to Opus (`model: "opus"`), each
given: the design-language doc, the invariants list, the evidence PNGs (all
themes), and the UI source files. When a `ui-ux-pro-max` skill is available
in the session, load it and fold its evaluation criteria into lenses 1–3 and
5 as the rubric. One lens per agent — no combining:

1. **Visual conformance** — deviations from the design language: type ramp,
   spacing scale, shape language, motion. Cite the token or rule violated.
2. **Consistency** — cross-surface drift: duplicated styles, hardcoded
   values that should be shared resources, spacing/radius variance between
   sibling surfaces, one-off controls where a shared one exists.
3. **QOL / flow** — clicks-to-do-common-things, empty states, error states,
   first-run experience, dead ends, missing keyboard paths.
4. **Copy / voice** — UI strings against the repo's voice rules.
5. **Accessibility** — contrast under EVERY captured theme, focus order,
   keyboard reachability, hit-target size.

Each lens returns findings as: surface, description, evidence pointer
(PNG path and/or `file:line`), severity 1–5, visibility 1–5, proposed fix
direction (one line).

## The skeptic pass

Every finding faces a fresh Opus agent (high effort) prompted to REFUTE it:
is it real, is it in scope, does it violate an invariant, is the evidence
actually showing what the lens claims? Default to refuted when uncertain.
Findings that would break an invariant are refused here mechanically —
quote the invariant in the refusal. Only survivors get ids.

## The register

Write survivors to
`docs/superpowers/research/YYYY-MM-DD-<app>-ui-audit-findings.md`, ranked by
severity × visibility, one row per finding:
`F-### | surface | lens | severity | visibility | evidence | verdict | fix direction | status`
(`status` starts `open`; `:wave` moves it to `shipped`, re-review moves it
to `clean` or back to `open`). Summarize refusals in a short section at the
bottom — refuted findings are recorded, not resurrected.

Update state: `findingsRegisterPath`, `stage: "waves"`. Commit register +
state on a branch per the target repo's conventions.

## Gate

Present the register (counts by lens and severity, the top ten by rank).
The user approves it before any wave runs. Recommend `/vibe-glow:wave`; do
not run it.
