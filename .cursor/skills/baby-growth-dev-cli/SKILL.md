---
name: baby-growth-dev-cli
description: 运行 Baby Growth Log 本地开发 CLI：pnpm API/worker、Android SDK（adb/emulator/sdkmanager）、Gradle 构建 APK、模拟器管理与排障。在用户要启动项目、构建安卓、操作模拟器、安装 APK、配置 ANDROID_HOME 或排查开发环境时使用。
---

# Baby Growth 本地开发 CLI

## 前置条件

| 工具 | 版本/说明 |
|------|-----------|
| Node.js | 22 |
| pnpm | 10.12.1（`corepack enable`） |
| JDK | 17+（本机 Temurin 21 可用） |
| Android SDK | `%LOCALAPPDATA%\Android\Sdk` |
| Gradle | 9.4.1（`gradlew.bat` / `gradlew`） |

推荐 AVD：**`Pixel_7_API_34`**（Android 14）。备选 `Pixel_7_API_36`。

App 包名：`com.babygrowthlog.app`  
Debug APK：`apps/android/build/outputs/apk/debug/android-debug.apk`

## 快速决策

```
要做什么？
├─ 只跑后端 → 「Node 服务」
├─ 构建/安装/打开 App → 「Android 构建与部署」或 scripts/build-install-run.ps1
├─ 只开模拟器 → 「模拟器」
├─ CLI 找不到 adb/emulator → 「环境变量」
└─ 模拟器窗口在屏外 → scripts/fix-emulator-window.ps1
```

## Node 服务

在仓库根目录执行：

```powershell
pnpm install
pnpm api:dev      # API，默认 http://127.0.0.1:3000
pnpm worker:dev   # Agent worker（可选）
pnpm typecheck    # 全仓 TS 类型检查
pnpm lint         # 全仓 lint
```

验证 API：

```powershell
curl http://127.0.0.1:3000/health
# {"ok":true,"service":"baby-growth-log-api"}
```

环境变量（`services/api/.env.example`）：

| 变量 | 默认 | 说明 |
|------|------|------|
| `PORT` | `3000` | API 端口 |
| `AGENT_ENABLED` | `false` | 是否启用真实 Agent |

PostgreSQL（`infra/docker/docker-compose.yml`）首版 API **不强制依赖**，无 Docker 也可开发。

## 环境变量

### 持久化（用户级，需重开终端）

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .cursor/skills/baby-growth-dev-cli/scripts/configure-android-env.ps1
```

写入：`ANDROID_HOME`、`ANDROID_SDK_ROOT`，PATH 追加 `platform-tools`、`emulator`、`cmdline-tools/latest/bin`。

### 当前会话（立即生效）

```powershell
. .cursor/skills/baby-growth-dev-cli/scripts/android-session.ps1
```

## Android SDK CLI

先点源 `android-session.ps1`，再执行：

```powershell
adb devices
adb install -r apps/android/build/outputs/apk/debug/android-debug.apk
adb shell am start -n com.babygrowthlog.app/.MainActivity
adb shell am force-stop com.babygrowthlog.app
adb exec-out screencap -p > screenshot.png

emulator -list-avds
emulator -avd Pixel_7_API_34 -gpu host -no-snapshot-load

sdkmanager --sdk_root=$env:ANDROID_HOME --list_installed
avdmanager list avd
```

创建标准 AVD（示例）：

```powershell
sdkmanager "system-images;android-34;google_apis;x86_64" "platforms;android-34"
avdmanager create avd -n Pixel_7_API_34 -k "system-images;android-34;google_apis;x86_64" -d pixel_7
```

## Android 构建与部署

### 一键脚本（推荐）

```powershell
# 仅构建+安装+启动（模拟器已运行时）
powershell -NoProfile -ExecutionPolicy Bypass -File .cursor/skills/baby-growth-dev-cli/scripts/build-install-run.ps1

# 顺带启动模拟器并修正窗口位置
powershell -NoProfile -ExecutionPolicy Bypass -File .cursor/skills/baby-growth-dev-cli/scripts/build-install-run.ps1 -StartEmulator -FixWindow
```

### 手动步骤

```powershell
. .cursor/skills/baby-growth-dev-cli/scripts/android-session.ps1

# Gradle（推荐 gradlew）
.\gradlew.bat :apps:android:assembleDebug

adb install -r apps\android\build\outputs\apk\debug\android-debug.apk
adb shell am start -n com.babygrowthlog.app/.MainActivity
```

KMP 测试（shared 模块）：

```powershell
.\gradlew.bat :shared:clean :shared:allTests
```

## 模拟器

### 启动

```powershell
emulator -avd Pixel_7_API_34 -gpu host -no-snapshot-load
```

GPU 异常时改用：`-gpu swiftshader_indirect`

### 窗口在屏幕外、无法拖动

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .cursor/skills/baby-growth-dev-cli/scripts/fix-emulator-window.ps1
```

或重置 AVD 窗口配置（`%USERPROFILE%\.android\avd\<AVD名>.avd\emulator-user.ini`）：

```ini
window.x = 80
window.y = 80
window.scale = 0.55
```

手动应急：`Alt+Space` → `M` → 方向键移动 → `Enter`

### 关闭

```powershell
adb -s emulator-5554 emu kill
```

## 排障

| 现象 | 处理 |
|------|------|
| `adb`/`emulator` 找不到 | 运行 `configure-android-env.ps1` 或 `android-session.ps1` |
| Gradle 插件/依赖下载失败 | `settings.gradle.kts` 已配阿里云镜像；Gradle 分发镜像见 `gradle/wrapper/gradle-wrapper.properties`（腾讯云） |
| Gradle 本体下载失败 | 腾讯云：`https://mirrors.cloud.tencent.com/gradle/gradle-9.4.1-bin.zip` |
| Kotlin 插件在 Google Maven 404 | `pluginManagement.repositories` 把阿里云放最前 |
| App 界面只有两行占位文字 | 正常：`MainActivity` 尚未实现完整首页 |
| 禁止全局 lint/format fix | 不要跑 `pnpm lint --fix` 或项目级 format 修复命令 |

## 仓库结构（CLI 相关）

```text
apps/android/          # Android App，assembleDebug 产物
shared/                # KMP 共享模块
services/api/          # Fastify API
services/agent-worker/ # 后台 worker
packages/contracts/    # DTO / 合同
.cursor/skills/baby-growth-dev-cli/scripts/  # 本 skill 脚本
.agent/files/gradle-tmp/                     # 历史临时 Gradle（已由 gradlew 替代，可删）
```

## 脚本索引

| 脚本 | 用途 |
|------|------|
| `scripts/android-session.ps1` | 当前会话注入 Android 环境变量 |
| `scripts/configure-android-env.ps1` | 持久化用户级 Android 环境变量 |
| `scripts/fix-emulator-window.ps1` | 模拟器窗口移回可见区域 |
| `scripts/build-install-run.ps1` | 构建 APK → 安装 → 启动 App |

执行脚本时用 PowerShell 5 语法；**禁止**在脚本中使用 `$$`、`||` 等 PowerShell 7 管道运算符。
