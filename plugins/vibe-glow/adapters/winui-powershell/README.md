# winui-powershell adapter

Window capture for WinUI 3 / Win32 apps via PrintWindow with
PW_RENDERFULLCONTENT (composed windows render black without it). Captures
are window-sized PNGs named `NN-<surface>--<theme>.png` into the campaign's
`evidenceDir`.

## Modes

- **Single** (automatable — main window and navigable views):
  `pwsh capture.ps1 -ProcessName <exe-basename> -OutDir <evidenceDir> -Surface main-window -Theme obsidian`
- **Watch** (guided session — modal dialogs need a human driver):
  `pwsh capture.ps1 -Watch -OutDir <evidenceDir> -Theme obsidian`
  The driver walks a capture checklist, opens each dialog, presses F8;
  Esc ends the session. Window titles auto-label; rename outliers after.

## Per-theme rounds

One invocation per theme. Switch the app's theme between rounds, re-run
with the new `-Theme` label. A full multi-theme baseline is N rounds of the
same checklist.

## Known gotchas (learned on 626 Mod Launcher)

- Dev/debug builds may version-stamp as 0.1.0.0 and silently hide
  remote-gated surfaces (minBinaryVersion gates). Build smoke builds with
  the real version, e.g. `-p:Version=<current>`, or those surfaces vanish
  from your evidence.
- After XAML edits, clean `obj/` and `bin/` before rebuilding — stale
  codegen crashes the app at `Connect()` with InvalidCastException.
- If the app fails to appear, check its error log (launcher:
  `app-errors.log`) before blaming the adapter.
- Windows scale factor affects pixel dimensions; capture the whole round on
  one monitor at one scale.
