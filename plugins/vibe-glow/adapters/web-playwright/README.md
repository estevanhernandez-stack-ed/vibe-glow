# web-playwright adapter

Procedure-only adapter: captures happen through the Playwright MCP tools
(`browser_navigate`, `browser_take_screenshot`, `browser_resize`), no script
to run. Covers React/Vite, Streamlit, and anything else a browser reaches.

## Procedure

1. Start the app per its own run instructions; note the base URL.
2. Standardize the viewport first: 1440x900 unless the campaign says
   otherwise (`browser_resize`). One viewport per round.
3. Walk the surface checklist: `browser_navigate` to each route,
   `browser_take_screenshot` (full page), save into the campaign's
   `evidenceDir` as `NN-<surface>--<theme>.png` — same convention as the
   WinUI adapter, so registers read identically.
4. Modal/stateful surfaces: drive them open with `browser_click` /
   `browser_fill_form` before the screenshot; note the reach-path in the
   checklist so re-capture is mechanical.
5. Theming: switch through the app's own UI, one round per theme label.
   Apps without theming run a single `default` round.

## Gotchas

- Screenshot the logged-in state the campaign cares about; auth walls
  produce 23 identical login-page captures if you forget.
- Animations: screenshot after idle; flaky hero motion belongs in the
  motion notes, not the evidence diff.
- Streamlit reruns on interaction — wait for the rerun spinner to clear
  before capturing.
