# 仅当前 PowerShell 会话注入 Android SDK 环境变量
$sdk = "$env:LOCALAPPDATA\Android\Sdk"
$env:ANDROID_HOME = $sdk
$env:ANDROID_SDK_ROOT = $sdk
$prepend = @(
    (Join-Path $sdk "platform-tools"),
    (Join-Path $sdk "emulator"),
    (Join-Path $sdk "cmdline-tools\latest\bin")
) -join ";"
$env:Path = "$prepend;$env:Path"
Write-Host "ANDROID_HOME=$sdk"
