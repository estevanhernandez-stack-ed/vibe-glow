---
description: Stage 2 — one findings-driven fix batch: branch, fix, review, re-capture, re-review
---

Stage 2 of a vibe-glow campaign, one wave per invocation. Preconditions:
`stage: "waves"` and an approved findings register.

## 1. Pick the batch

Default order across waves: consistency/style-consolidation findings first
(they make every later fix cheaper), then QOL/flow, then per-surface visual
conformance in visibility order. Propose a batch of at most ~8 open
findings with a one-line rationale; the user can swap items. A single
small cosmetic finding does not need a wave — when `vibe-iterate:ux-polish`
is available, offer handing it there instead. Confirm before touching code.
Record the wave in state
(`{ id, name, status: "open", findings: [...] }`).

## 2. Fix, under the target repo's own law

- Branch: `glow/wave-<id>-<slug>` off the repo's default branch.
- Read the target repo's CLAUDE.md first and obey its build/test commands
  and taboos verbatim.
- Behavior changes (view-models, services, logic) get a failing test first,
  in the repo's own test framework. Pure-visual changes (markup, styles)
  get an entry in the repo's manual smoke checklist if one exists.
- Scope law: a wave ships only its findings. Anything discovered mid-wave
  becomes a proposed register addition, not a drive-by fix.

## 3. Review gate

Open a PR. Run the repo's strongest available review gate — `/code-review`
ultra when available, otherwise the repo's review agent or a fresh-context
review. Address findings before merge. Merge per the repo's convention.

## 4. Re-capture and re-review (the multi-pass)

After merge: re-capture ONLY the surfaces this wave touched, all themes,
per the adapter README. Then one Opus agent re-reviews those surfaces
against the design language and the wave's findings: each finding closes
(`clean`) or stays `open` with what remains. Two outcomes:

- All clean → wave `status: "clean"` in state; register rows → `clean`.
- Residue → wave stays `shipped`; residue findings stay `open` for a later
  wave. Say so plainly.

Update the register + state, commit.

## 5. Recommend, don't chain

If open findings remain: recommend another `/vibe-glow:wave`. If none:
recommend `/vibe-glow:reveal`. Never invoke either yourself.
