# .vibe-glow/state.json — the campaign pointer layer

Lives at the target repo root, committed (campaigns are resumable across
sessions and machines). camelCase keys, no exceptions.

| Key | Type | Meaning |
| --- | --- | --- |
| `schemaVersion` | number | Always 1 for v0.1. Bump on breaking shape change. |
| `app` | string | Repo/app name, for humans reading the file. |
| `stage` | string | `identity` / `audit` / `waves` / `reveal` / `done`. The router's input. |
| `adapter` | string | `winui-powershell` or `web-playwright`. Chosen in `:identity`. |
| `evidenceDir` | string | Repo-relative dir for capture PNGs. Must be gitignored in the target repo. |
| `designLanguagePath` | string | Repo-relative path to the committed design language doc. Empty until stage 0 closes. |
| `findingsRegisterPath` | string | Repo-relative path to the committed findings register. Empty until stage 1 closes. |
| `themes` | string[] | Theme labels each capture round covers. Apps without theming use `["default"]`. |
| `invariants` | string[] | Per-app rules that outrank findings. Format: `"<rule> — <consequence for reviewers>"`. |
| `waves` | object[] | Wave ledger: `{ id, name, status, findings }`. `status`: `open` → `shipped` → `clean`. |

Commands own their transitions: `:identity` creates the file and sets
`stage: "audit"` on gate close; `:audit` sets `stage: "waves"`; `:reveal`
sets `stage: "done"`. Nothing else writes `stage`.
