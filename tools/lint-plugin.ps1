# Structural lint for the vibe-glow plugin. Exit 0 = pass, 1 = fail.
$ErrorActionPreference = 'Stop'
$root = Join-Path $PSScriptRoot '..' 'plugins' 'vibe-glow'
$fail = @()

$manifest = Join-Path $root '.claude-plugin' 'plugin.json'
if (-not (Test-Path $manifest)) { $fail += "missing $manifest" }
else {
    try {
        $m = Get-Content $manifest -Raw | ConvertFrom-Json
        foreach ($k in 'name', 'version', 'description') {
            if (-not $m.$k) { $fail += "plugin.json missing '$k'" }
        }
        if ($m.name -and $m.name -ne 'vibe-glow') { $fail += "plugin.json name must be 'vibe-glow'" }
    } catch { $fail += "plugin.json does not parse: $_" }
}

$cmdDir = Join-Path $root 'commands'
if (Test-Path $cmdDir) {
    foreach ($f in Get-ChildItem $cmdDir -Filter '*.md') {
        $head = (Get-Content $f.FullName -TotalCount 5) -join "`n"
        if ($head -notmatch '(?s)^---.*description:') { $fail += "$($f.Name) missing 'description:' frontmatter" }
    }
}

$example = Join-Path $root 'docs' 'state.example.json'
if (Test-Path $example) {
    try {
        $s = Get-Content $example -Raw | ConvertFrom-Json
        foreach ($p in $s.PSObject.Properties.Name) {
            if ($p -cnotmatch '^[a-z][a-zA-Z0-9]*$') { $fail += "state.example.json key '$p' is not camelCase" }
        }
    } catch { $fail += "state.example.json does not parse: $_" }
}

foreach ($a in 'winui-powershell', 'web-playwright') {
    $dir = Join-Path $root 'adapters' $a
    if ((Test-Path $dir) -and -not (Test-Path (Join-Path $dir 'README.md'))) { $fail += "adapter $a has no README.md" }
}

if ($fail) { $fail | ForEach-Object { Write-Host "LINT FAIL: $_" }; exit 1 }
Write-Host 'lint-plugin: all checks pass.'; exit 0
