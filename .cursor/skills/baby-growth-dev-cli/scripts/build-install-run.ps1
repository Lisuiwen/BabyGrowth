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

# 解析 Gradle：优先 gradlew，否则使用仓库内临时 Gradle
$gradlew = Join-Path $repoRoot "gradlew.bat"
$gradleBat = Join-Path $repoRoot ".agent\files\gradle-tmp\gradle-9.4.1\bin\gradle.bat"
if (Test-Path $gradlew) {
    $gradleCmd = $gradlew
} elseif (Test-Path $gradleBat) {
    $gradleCmd = $gradleBat
} else {
    Write-Error "Gradle not found. Run gradle wrapper setup or install Gradle 9.4.1."
}

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
