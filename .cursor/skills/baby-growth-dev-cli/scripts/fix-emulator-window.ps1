# 将 Android Emulator 窗口移回主屏幕可见区域（标题栏在屏外时使用）
Add-Type -AssemblyName System.Windows.Forms
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class EmulatorWin32 {
    [DllImport("user32.dll")] public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
    [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);
    [StructLayout(LayoutKind.Sequential)] public struct RECT {
        public int Left; public int Top; public int Right; public int Bottom;
    }
}
"@

$work = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
$maxW = [int]($work.Width * 0.45)
$maxH = [int]($work.Height * 0.85)
$targetX = $work.Left + 40
$targetY = $work.Top + 40

$found = $false
for ($i = 0; $i -lt 30; $i++) {
    $proc = Get-Process | Where-Object {
        $_.MainWindowHandle -ne 0 -and (
            $_.MainWindowTitle -like '*Android Emulator*' -or
            $_.MainWindowTitle -like '*Emulator*Pixel*'
        )
    } | Select-Object -First 1

    if ($proc) {
        $hwnd = $proc.MainWindowHandle
        $rect = New-Object EmulatorWin32+RECT
        [EmulatorWin32]::GetWindowRect($hwnd, [ref]$rect) | Out-Null
        $w = $rect.Right - $rect.Left
        $h = $rect.Bottom - $rect.Top
        if ($w -gt $maxW) { $w = $maxW }
        if ($h -gt $maxH) { $h = $maxH }
        if ($w -lt 320) { $w = 400 }
        if ($h -lt 480) { $h = 800 }
        [EmulatorWin32]::MoveWindow($hwnd, $targetX, $targetY, $w, $h, $true) | Out-Null
        Write-Host "OK moved: $($proc.MainWindowTitle) -> ($targetX,$targetY) ${w}x${h}"
        $found = $true
        break
    }
    Start-Sleep -Seconds 2
}

if (-not $found) {
    Write-Host "Emulator window not found"
    exit 1
}
