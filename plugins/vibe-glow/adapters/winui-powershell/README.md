# winui-powershell adapter

Window capture for Windows-native apps — WinUI 3, WPF, and Win32 alike
(PrintWindow and UIA cover all three; the id keeps its original name so
recorded campaign state stays valid). Captures are window-sized PNGs named
`NN-<surface>--<theme>.png` in the campaign's `evidenceDir`.

## Modes

- **UIA (preferred where a route map exists):**
  `pwsh capture.ps1 -Uia -RouteMap docs/ui-routes.json -OutDir <evidenceDir> -Theme obsidian`
  Agent-driven: opens each routed surface itself (invoke by automation id
  or name), captures, closes via UIA — never Esc, never keyboard. Routes
  that fail resolve are reported and skipped, not fatal. See
  `../../docs/ui-routes.example.json` for the route-map shape; author
  routes from a `-DumpUia` tree.
- **Watch (humans, and states UIA can't reach):**
  `pwsh capture.ps1 -Watch -OutDir <evidenceDir> -Theme obsidian`
  F8 captures the foreground window; Esc ends the session. Close dialogs
  with the mouse — Esc kills the watcher.
- **Single (one-offs):**
  `pwsh capture.ps1 -ProcessName <exe-basename> -OutDir <evidenceDir> -Surface main-window -Theme obsidian`

Add `-DumpUia` to any mode: writes `<name>.uia.txt` (roles, names,
automation ids) beside each PNG — Narrator groundwork and route-map
authoring material in one.

## Pixel sampling

`sample.py` (Pillow, optional dependency) crops a region and walks pixel
values. Use it whenever a preview-scale judgment call decides a finding —
downscales lie about fills and halos; pixels do not.

## Per-theme rounds

One invocation per theme; switch the app's theme between rounds and re-run
with the new `-Theme` label.

## Field notes (earned on real campaigns)

- Popup/dialog template fix-ups race the `Opened` event in both
  directions — key one-shot hooks off the injected content's own `Loaded`.
  And verify timing-dependent fixes at least twice; one passing run of a
  race proves nothing.
- Stock dialog Title ContentControls pin HorizontalAlignment=Left — a
  spanning rail needs the pin overridden, not a wider Title.
- ContentDialog's UIA name derives only from string Titles; element
  content silently drops the accessible name. Check the `-DumpUia` tree.
- Interaction states (hover, drag-in-progress, open flyouts, transition
  frames) are invisible to screenshots. Verify them by code or by
  sample.py on staged frames — and say which one the evidence is.
- Dev builds may version-stamp low and silently hide remote-gated
  surfaces (minBinaryVersion gates) — build with the real version, e.g.
  `-p:Version=<current>`.
- After XAML edits, clean `obj/`/`bin/` before rebuilding; check the
  app's error log if it launches silent.
- Windows scale factor affects pixel dimensions; capture a whole round on
  one monitor at one scale.
