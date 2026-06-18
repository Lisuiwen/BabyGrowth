# AGENTS

## Cursor Cloud specific instructions

本仓库是「宝宝成长记录本」：Android 优先的 KMP + Node.js monorepo。云端 VM 默认只完整支持 **Node 侧**（`services/*`、`packages/*`），Android/KMP 侧需要额外的重型工具链（见下）。

### 服务概览

- `services/api`：Fastify HTTP 服务，是云端唯一会监听端口的可运行应用。默认端口 `3000`（可用 `PORT` 覆盖），监听 `0.0.0.0`。路由：`GET /health`、`POST /agent/summary`（请求体需 `babyId` 非空字符串与 `range ∈ {today,last_7_days,last_30_days}`，否则返回 400）。环境变量 `AGENT_ENABLED` 默认 `false`，首版不做真实模型调用。
- `services/agent-worker`：当前为占位 stub，`dev` 用 `tsx watch` 启动后只打印 `agent worker is ready` 并保持运行（watch 模式不会退出，属正常）。
- `packages/contracts`：仅构建产物（DTO/契约），无运行时服务。

启动/构建/检查命令见根 `package.json` 脚本（`pnpm api:dev`、`pnpm worker:dev`、`pnpm contracts:build`、`pnpm typecheck` 等），不在此重复。

### 非显而易见的注意事项

- **`pnpm lint` 当前全仓库失败**：仓库未提交任何 ESLint flat config（ESLint v9 需要 `eslint.config.js`），各包 `lint` 脚本都会报「couldn't find an eslint.config」。这是既有缺口，CI（`.github/workflows/ci.yml`）也只跑 `pnpm typecheck`、不跑 lint。不要把该失败当作你引入的回归。
- **没有 Node 测试运行器**：仓库未配置 `pnpm test`，Node 侧没有可跑的自动化测试。
- `pnpm install` 会提示忽略 `esbuild` 的构建脚本，可忽略：`tsx` 自带 esbuild，API/worker 均能正常运行。
- **Android / KMP 侧（`apps/android`、`shared`）在基础云 VM 中无法直接构建**：需要 Android SDK（platform/build-tools 36）+ Gradle 9.4.1，由 `.devcontainer/Dockerfile` 安装；基础云 VM 未装这些，且仓库**未提交 Gradle Wrapper**（无 `gradlew`）。`shared` 使用 `androidTarget()`，因此连 KMP 单测也依赖 Android SDK。需要构建 APK/跑 KMP 测试时，请用 Android Studio 打开仓库根目录，或使用 `.devcontainer` 环境。
