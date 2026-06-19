# 构建 Debug APK、安装到已连接设备/模拟器并启动 MainActivity
param(
    [string]$Avd = "Pixel_7_API_34",
    [switch]$StartEmulator,
    [switch]$FixWindow
)

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..\..\..")
Set-Location $repoRoot

. (Join-Path $PSScriptRoot "android-session.ps1")

# 解析 Gradle：使用仓库 Gradle Wrapper
$gradlew = Join-Path $repoRoot "gradlew.bat"
if (-not (Test-Path $gradlew)) {
    Write-Error "gradlew.bat not found. Run: gradle wrapper --gradle-version 9.4.1"
}
$gradleCmd = $gradlew

if ($StartEmulator) {
    $running = adb devices 2>&1 | Select-String "emulator"
    if (-not $running) {
        Start-Process -FilePath "emulator" -ArgumentList @("-avd", $Avd, "-gpu", "host", "-no-snapshot-load")
        Write-Host "Waiting for emulator..."
        adb wait-for-device | Out-Null
        for ($i = 0; $i -lt 40; $i++) {
            $boot = adb shell getprop sys.boot_completed 2>$null
            if ($boot -match "1") { break }
            Start-Sleep -Seconds 3
        }
        if ($FixWindow) {
            Start-Sleep -Seconds 5
            & (Join-Path $PSScriptRoot "fix-emulator-window.ps1")
        }
    }
}

Write-Host "Building APK..."
& $gradleCmd ":apps:android:assembleDebug"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$apk = Join-Path $repoRoot "apps\android\build\outputs\apk\debug\android-debug.apk"
adb install -r $apk
adb shell am start -n com.babygrowthlog.app/.MainActivity
Write-Host "Done."
