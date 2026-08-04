# .vibe-glow/state.json — the campaign pointer layer

Lives at the target repo root, committed (campaigns are resumable across
sessions and machines). camelCase keys, no exceptions.

## The optional-key law

`schemaVersion` stays 1 across additive change. Readers tolerate absent
optional keys; writers preserve keys they do not understand. A v0.1 state
file (no `scope`) is a valid v0.2 state file meaning an app-wide campaign.

| Key | Type | Required | Meaning |
| --- | --- | --- | --- |
| `schemaVersion` | number | yes | Always 1. Bumps only on breaking shape change. |
| `app` | string | yes | Repo/app name, for humans reading the file. |
| `stage` | string | yes | `identity` / `audit` / `waves` / `reveal` / `done`. |
| `adapter` | string | yes | `winui-powershell` or `web-playwright`. Chosen in stage 0. |
| `evidenceDir` | string | yes | Repo-relative dir for capture PNGs. Gitignored in the target repo. |
| `designLanguagePath` | string | yes | Repo-relative path to the measuring-stick doc — the design language (app-wide) or the conventions brief (scoped). Empty until stage 0 closes. |
| `findingsRegisterPath` | string | yes | Repo-relative path to the findings register. Empty until stage 1 closes. |
| `themes` | string[] | yes | Theme labels each capture round covers. Apps without theming use `["default"]`. |
| `invariants` | string[] | yes | Per-app rules that outrank findings: `"<rule> — <consequence for reviewers>"`. |
| `waves` | object[] | yes | Wave ledger: `{ id, name, status, findings }`; `status`: `open` → `shipped` → `clean`. |
| `scope` | object | no | Absent = app-wide campaign. Present = focused campaign: `{ "area": "<name>", "goal": "<user's words>", "surfaces": ["<checklist row names>"] }`. |

## Stage transitions

Commands own their transitions; nothing else writes `stage`:

- Stage 0 writes the file at the END OF ITS INTERVIEW with `stage: "identity"`
  (mid-flight resume is real), and sets `stage: "audit"` when its gate closes.
- Stage 1 sets `stage: "waves"` when the register is approved.
- Stage 3 sets `stage: "reveal"` on entry and `stage: "done"` on close.
