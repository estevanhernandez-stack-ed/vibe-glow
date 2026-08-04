<#
Window capture for Windows-native apps (WinUI 3, WPF, Win32). Modes:
  Single:  ./capture.ps1 -ProcessName App -OutDir <dir> -Surface main-window -Theme obsidian
  Watch:   ./capture.ps1 -Watch -OutDir <dir> -Theme obsidian
           (F8 captures the foreground window, Esc ends the session —
            close dialogs with the mouse, Esc kills the watcher)
  UIA:     ./capture.ps1 -Uia -RouteMap docs/ui-routes.json -OutDir <dir> -Theme obsidian
           (agent-driven: opens each routed surface itself, captures,
            closes via UIA — no human in the loop)
Add -DumpUia to any mode to write <name>.uia.txt (names/roles/ids) beside
each PNG. Uses PrintWindow with PW_RENDERFULLCONTENT — composed windows
render black without that flag.
#>
param(
    [string]$ProcessName,
    [switch]$Watch,
    [switch]$Uia,
    [string]$RouteMap,
    [Parameter(Mandatory)][string]$OutDir,
    [string]$Surface = '',
    [string]$Theme = 'default',
    [switch]$DumpUia
)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName UIAutomationClient, UIAutomationTypes
Add-Type -Namespace Native -Name Win32 -MemberDefinition @'
[DllImport("user32.dll")] public static extern bool PrintWindow(IntPtr hwnd, IntPtr hdc, uint flags);
[DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
[DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr hwnd, out RECT rect);
[DllImport("user32.dll")] public static extern int GetWindowTextW(IntPtr hwnd, [MarshalAs(UnmanagedType.LPWStr)] System.Text.StringBuilder text, int count);
[DllImport("user32.dll")] public static extern short GetAsyncKeyState(int vKey);
public struct RECT { public int Left, Top, Right, Bottom; }
'@

New-Item -ItemType Directory -Force $OutDir | Out-Null
$script:seq = [int](Get-ChildItem $OutDir -Filter '*.png' -ErrorAction SilentlyContinue |
    ForEach-Object { if ($_.Name -match '^(\d+)-') { [int]$Matches[1] } } |
    Measure-Object -Maximum).Maximum

function Get-WindowTitle([IntPtr]$hwnd) {
    $sb = New-Object System.Text.StringBuilder 512
    [void][Native.Win32]::GetWindowTextW($hwnd, $sb, 512)
    $t = $sb.ToString()
    if (-not $t) { $t = 'untitled' }
    return ($t -replace '[^\w\- ]', '' -replace '\s+', '-').ToLower()
}

function Save-Window([IntPtr]$hwnd, [string]$label) {
    $rect = New-Object Native.Win32+RECT
    if (-not [Native.Win32]::GetWindowRect($hwnd, [ref]$rect)) { throw 'GetWindowRect failed.' }
    $w = $rect.Right - $rect.Left; $h = $rect.Bottom - $rect.Top
    if ($w -le 0 -or $h -le 0) { throw "Window has no area ($w x $h)." }
    $bmp = New-Object System.Drawing.Bitmap $w, $h
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $hdc = $g.GetHdc()
    $ok = [Native.Win32]::PrintWindow($hwnd, $hdc, 2)  # 2 = PW_RENDERFULLCONTENT
    $g.ReleaseHdc($hdc); $g.Dispose()
    if (-not $ok) { $bmp.Dispose(); throw 'PrintWindow failed.' }
    $script:seq++
    $name = '{0:d2}-{1}--{2}.png' -f $script:seq, $label, $Theme
    $path = Join-Path $OutDir $name
    try { $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png) } finally { $bmp.Dispose() }
    Write-Host "captured $path ($w x $h)"
    if ($DumpUia) { Dump-UiaTree $hwnd ([System.IO.Path]::ChangeExtension($path, '.uia.txt')) }
    return $path
}

function Dump-UiaTree([IntPtr]$hwnd, [string]$outFile) {
    try {
        $el = [System.Windows.Automation.AutomationElement]::FromHandle($hwnd)
        $walker = [System.Windows.Automation.TreeWalker]::ControlViewWalker
        $sb = New-Object System.Text.StringBuilder
        $stack = New-Object System.Collections.Stack
        $stack.Push(@($el, 0))
        while ($stack.Count -gt 0) {
            $pair = $stack.Pop(); $node = $pair[0]; $depth = $pair[1]
            if ($depth -gt 12) { continue }
            $name = $node.Current.Name
            $role = $node.Current.ControlType.ProgrammaticName -replace '^ControlType\.', ''
            $id = $node.Current.AutomationId
            [void]$sb.AppendLine(('{0}{1} ''{2}'' [{3}]' -f ('  ' * $depth), $role, $name, $id))
            $children = @()
            $child = $walker.GetFirstChild($node)
            while ($null -ne $child) { $children += $child; $child = $walker.GetNextSibling($child) }
            for ($i = $children.Count - 1; $i -ge 0; $i--) { $stack.Push(@($children[$i], $depth + 1)) }
        }
        Set-Content -Path $outFile -Value $sb.ToString()
        Write-Host "uia tree  $outFile"
    } catch { Write-Host "uia dump failed: $_" }
}

function Find-UiaElement($windowEl, [string]$nameOrId) {
    $byName = New-Object System.Windows.Automation.PropertyCondition([System.Windows.Automation.AutomationElement]::NameProperty, $nameOrId)
    $byId = New-Object System.Windows.Automation.PropertyCondition([System.Windows.Automation.AutomationElement]::AutomationIdProperty, $nameOrId)
    $or = New-Object System.Windows.Automation.OrCondition($byName, $byId)
    return $windowEl.FindFirst([System.Windows.Automation.TreeScope]::Descendants, $or)
}

function Invoke-UiaPath($windowEl, [string[]]$path) {
    foreach ($step in $path) {
        $el = Find-UiaElement $windowEl $step
        if ($null -eq $el) { throw "element '$step' not found" }
        $inv = $null
        if (-not $el.TryGetCurrentPattern([System.Windows.Automation.InvokePattern]::Pattern, [ref]$inv)) {
            throw "element '$step' is not invokable"
        }
        $inv.Invoke()
        Start-Sleep -Milliseconds 700
    }
}

if ($Uia) {
    if (-not $RouteMap) { throw 'UIA mode needs -RouteMap <path to ui-routes.json>.' }
    $map = Get-Content $RouteMap -Raw | ConvertFrom-Json
    $procName = if ($ProcessName) { $ProcessName } else { $map.processName }
    $proc = Get-Process -Name $procName -ErrorAction Stop |
        Where-Object { $_.MainWindowHandle -ne 0 } | Select-Object -First 1
    if (-not $proc) { throw "No window found for process '$procName'." }
    $mainEl = [System.Windows.Automation.AutomationElement]::FromHandle($proc.MainWindowHandle)
    $done = 0; $skipped = @()
    foreach ($route in $map.routes) {
        try {
            if ($route.invoke) { Invoke-UiaPath $mainEl $route.invoke }
            $hwnd = [Native.Win32]::GetForegroundWindow()
            Save-Window $hwnd $route.surface | Out-Null
            if ($route.close) { Invoke-UiaPath ([System.Windows.Automation.AutomationElement]::FromHandle($hwnd)) $route.close }
            Start-Sleep -Milliseconds 400
            $done++
        } catch {
            Write-Host "skip $($route.surface): $_"
            $skipped += $route.surface
        }
    }
    Write-Host ("uia round done: {0} captured, {1} skipped{2}" -f $done, $skipped.Count,
        $(if ($skipped) { ' (' + ($skipped -join ', ') + ')' } else { '' }))
} elseif ($Watch) {
    Write-Host "watch mode — theme '$Theme'. F8 captures the foreground window, Esc exits."
    Write-Host "close dialogs with the mouse — Esc ends this watcher."
    while ($true) {
        if ([Native.Win32]::GetAsyncKeyState(0x1B) -band 0x8000) { break }        # Esc
        if ([Native.Win32]::GetAsyncKeyState(0x77) -band 0x8000) {                # F8
            $hwnd = [Native.Win32]::GetForegroundWindow()
            try { Save-Window $hwnd (Get-WindowTitle $hwnd) } catch { Write-Host "skip: $_" }
            Start-Sleep -Milliseconds 400                                          # debounce
        }
        Start-Sleep -Milliseconds 60
    }
    Write-Host 'watch session ended.'
} else {
    if (-not $ProcessName) { throw 'Provide -ProcessName for single mode, -Watch, or -Uia.' }
    $proc = Get-Process -Name $ProcessName -ErrorAction Stop |
        Where-Object { $_.MainWindowHandle -ne 0 } | Select-Object -First 1
    if (-not $proc) { throw "No window found for process '$ProcessName'." }
    $label = if ($Surface) { $Surface } else { Get-WindowTitle $proc.MainWindowHandle }
    Save-Window $proc.MainWindowHandle $label | Out-Null
}
