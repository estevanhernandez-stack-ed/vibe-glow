---
description: Stage 1 — five Opus review lenses, skeptic-verified findings register; scoped campaigns audit only their scope
---

Stage 1 of a vibe-glow campaign. Preconditions: `.vibe-glow/state.json`
with `stage: "audit"` and a committed measuring-stick doc at
`designLanguagePath` — the design language (app-wide) or the conventions
brief (scoped). If evidence is stale, refresh per the adapter README
before reviewing.

## Scope

App-wide: every captured surface. Scoped (`scope` present in state): only
the surfaces in `scope.surfaces` plus their captured neighbors; the
neighbors inform the consistency lens but do not receive findings of their
own. The user's `scope.goal` weights the ranking — findings that serve the
goal take visibility precedence.

## Cost gate

Quote the real size before running: agent count scales with surface count
(five lenses + one skeptic per surviving finding — an app-wide pass over
~20 surfaces runs ~10–14 Opus agents; a scoped pass over a handful of
surfaces runs proportionally fewer — say the smaller number honestly).
Get an explicit go. No go, no run.

## The five lenses

Run as parallel review agents, each pinned to Opus (`model: "opus"`), each
given: the measuring-stick doc, the invariants list, the goal (when
scoped), the evidence PNGs (all themes), and the UI source files. When a
`ui-ux-pro-max` skill is available in the session, load it and fold its
evaluation criteria into lenses 1–3 and 5 as the rubric. One lens per
agent — no combining:

1. **Visual conformance** — deviation from the measuring stick. Cite the
   token, rule, or convention violated.
2. **Consistency** — cross-surface drift: duplicated styles, hardcoded
   values, spacing/radius variance, one-off controls. Scoped campaigns:
   does the area drift from the rest of the app's own patterns.
3. **QOL / flow** — clicks-to-do-common-things, empty states, error
   states, first-run friction, dead ends, missing keyboard paths. Ask of
   every stateful surface: **what state survives a restart?** Settings the
   user chose that silently reset are findings.
4. **Copy / voice** — UI strings against the repo's voice rules.
5. **Accessibility** — contrast under EVERY captured theme, focus order,
   keyboard reachability, hit-target size. Check **declaration/tab/UIA
   order against visual order** — geometry that leaves focus order behind
   is a finding.

Every lens: when a finding's fix implies a **new platform mechanism** (the
platform has no consumer for the thing — a shadow system, a new service,
new interop) rather than a re-style, tag the fix direction `[new-mechanism]`.
These price differently and must not sit in the register looking cheap.

## The skeptic pass

Every finding faces a fresh Opus agent (high effort) prompted to REFUTE
it: is it real, in scope, invariant-clean, and does the evidence show what
the lens claims? Default to refuted when uncertain. Findings that would
break an invariant are refused here mechanically — quote the invariant in
the refusal. Only survivors get ids.

## The register

Write survivors to
`docs/superpowers/research/YYYY-MM-DD-<app>-ui-audit-findings.md`
(scoped campaigns may add `-<area>` before `-ui-audit`), ranked by
severity × visibility (goal-serving findings first when scoped), one row
per finding:
`F-### | surface | lens | severity (1–5) | visibility (1–5) | evidence | verdict | fix direction | status`
(`status` starts `open`). Summarize refusals at the bottom — refuted
findings are recorded, not resurrected.

Update state: `findingsRegisterPath`, `stage: "waves"`. Commit register +
state on a branch per the target repo's conventions.

## Gate

Present the register (counts by lens and severity, the top ten by rank —
derived from the rows just written, never from memory). The user approves
it before any wave runs. Recommend the first wave — but do not run it.
