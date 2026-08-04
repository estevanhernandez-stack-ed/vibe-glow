---
description: Stage 2 — one findings-driven fix batch: branch, fix, review, re-capture, re-review
---

Stage 2 of a vibe-glow campaign, one wave per invocation. Preconditions:
`stage: "waves"` and an approved findings register.

**The scoreboard law.** Any tally, count, or "N open at severity X" claim
you write — in a wave summary, a PR body, a gate message — is re-derived
from the register's rows at the moment of writing. Never carry a number
forward from a previous wave's summary. A carried-forward scoreboard once
cost a campaign an entire extra wave.

## 1. Pick the batch

Default order across waves: consistency/style-consolidation findings first
(they make every later fix cheaper), then QOL/flow, then per-surface visual
conformance in visibility order. `[new-mechanism]` findings get their own
wave or an explicit user decision — never slipped into a re-style batch as
if they cost the same. Propose a batch of at most ~8 open findings with a
one-line per-batch rationale; the user can swap items. A single small
cosmetic finding does not need a wave — when `vibe-iterate:ux-polish` is
available, offer handing it there instead. Confirm before touching code.
Record the wave in state (`{ id, name, status: "open", findings: [...] }`).

## 2. Fix, under the target repo's own law

- Branch: `glow/wave-<id>-<slug>` off the repo's default branch.
- Read the target repo's CLAUDE.md first and obey its build/test commands
  and taboos verbatim.
- Behavior changes (view-models, services, logic) get a failing test first,
  in the repo's own test framework. Pure-visual changes get an entry in the
  repo's manual smoke checklist if one exists.
- Timing-dependent fixes (anything keyed to load/open/layout events) are
  verified at least twice — a single passing run of a race is not
  verification.
- Scope law: a wave ships only its findings. Anything discovered mid-wave
  becomes a proposed register addition, not a drive-by fix.

## 3. Review gate

Open a PR. Run the repo's strongest available review gate — `/code-review`
ultra when available, otherwise the repo's review agent or a fresh-context
review. When the repo has a domain-guard reviewer (a core-purity agent, a
reversibility auditor) and this wave touched its domain, run it too.
Address findings before merge. Merge per the repo's convention, then set
the wave's ledger entry to `status: "shipped"` in state.

## 4. Close out (the multi-pass)

After merge:

- Re-capture ONLY the surfaces this wave touched, all themes, per the
  adapter README.
- One Opus agent re-reviews those surfaces against the measuring stick and
  the wave's findings: each finding closes (`clean`) or stays `open` with
  what remains.
- **Comment-drift check:** grep comments near the changed surfaces for
  claims the change contradicted — a stale comment asserting the old
  design is a finding of this close-out, fixed before the wave closes.
- All clean → wave `status: "clean"`; register rows → `clean`. Residue →
  wave stays `shipped`; residue findings stay `open` for a later wave. Say
  so plainly, with tallies derived from the rows.

Update the register + state, commit.

## 5. Recommend, don't chain

If open findings remain: recommend another wave. If none: recommend the
reveal. Never invoke either yourself — the concierge owns run-next
consent.
