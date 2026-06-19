# 写入用户级 ANDROID_HOME / ANDROID_SDK_ROOT / PATH（需重开终端生效）
$sdk = "$env:LOCALAPPDATA\Android\Sdk"

[Environment]::SetEnvironmentVariable("ANDROID_HOME", $sdk, "User")
[Environment]::SetEnvironmentVariable("ANDROID_SDK_ROOT", $sdk, "User")

$pathsToAdd = @(
    (Join-Path $sdk "platform-tools"),
    (Join-Path $sdk "emulator"),
    (Join-Path $sdk "cmdline-tools\latest\bin")
)

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if (-not $userPath) { $userPath = "" }
$parts = $userPath -split ";" | Where-Object { $_ -and $_.Trim() -ne "" }

foreach ($p in $pathsToAdd) {
    if ($parts -notcontains $p) {
        $parts += $p
    }
}

$newPath = $parts -join ";"
[Environment]::SetEnvironmentVariable("Path", $newPath, "User")
Write-Host "ANDROID_HOME=$sdk"
Write-Host "PATH updated: platform-tools, emulator, cmdline-tools"
