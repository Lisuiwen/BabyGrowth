# Baby Growth Log

宝宝成长记录本是一个安卓优先的 KMP + Node.js monorepo，用于记录宝宝成长、喂养、睡眠、尿布、护理、成长数据和家庭记忆。

## 仓库结构

```text
apps/android              # Android 原生端，Jetpack Compose 入口
shared                    # KMP 共享业务模型、规则、同步协议
services/api              # Node.js API，负责同步、账号、Agent 安全代理
services/agent-worker     # 后台 Agent/摘要/导出等异步任务
packages/contracts        # OpenAPI、JSON Schema、DTO 合同
docs                      # PRD、ADR、数据模型、AI 上下文
infra/docker              # 本地开发基础设施
```

## 首版原则

- Android first：首版只保证安卓体验完整。
- AI first：业务规则、数据合同和决策文档优先沉淀，方便 AI 稳定协作。
- Local first：核心记录先保证本地可靠，再接入同步。
- Agent safe：AI/Agent 能力只做事实整理、摘要和导出，不做医疗诊断或用药建议。

## 快速开始

```bash
pnpm install
pnpm api:dev
pnpm worker:dev
```

Android 工程可直接用 Android Studio 打开仓库根目录。

## 云端开发

仓库内置 `.devcontainer`，可在 GitHub Codespaces 或支持 Dev Container 的云 IDE 中直接启动。容器会安装：

- JDK 17
- Node.js 22
- pnpm 10.12.1
- Gradle 9.4.1
- Android SDK command-line tools
- Android platform/build-tools 36
- Android emulator 与 API 36 Google APIs x86_64 镜像

云端适合运行 Node API、Agent worker、contracts 构建、KMP shared 测试和 APK 构建。真机体验仍建议通过 `adb` 本地安装或下载 CI 产物到手机验证。
