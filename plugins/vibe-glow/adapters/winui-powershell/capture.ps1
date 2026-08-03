<#
Window capture for WinUI/Win32 apps. Two modes:
  Single:  ./capture.ps1 -ProcessName ModManager.App -OutDir ../evidence -Surface main-window -Theme obsidian
  Watch:   ./capture.ps1 -Watch -OutDir ../evidence -Theme obsidian
           (F8 captures the foreground window, Esc ends the session)
Uses PrintWindow with PW_RENDERFULLCONTENT — composed (WinUI/DirectComposition)
windows render black without that flag.
#>
param(
    [string]$ProcessName,
    [switch]$Watch,
    [Parameter(Mandatory)][string]$OutDir,
    [string]$Surface = '',
    [string]$Theme = 'default'
)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
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
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Host "captured $path ($w x $h)"
    return $path
}

if ($Watch) {
    Write-Host "watch mode — theme '$Theme'. F8 captures the foreground window, Esc exits."
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
    if (-not $ProcessName) { throw 'Provide -ProcessName for single mode, or -Watch.' }
    $proc = Get-Process -Name $ProcessName -ErrorAction Stop |
        Where-Object { $_.MainWindowHandle -ne 0 } | Select-Object -First 1
    if (-not $proc) { throw "No window found for process '$ProcessName'." }
    $label = if ($Surface) { $Surface } else { Get-WindowTitle $proc.MainWindowHandle }
    Save-Window $proc.MainWindowHandle $label | Out-Null
}
