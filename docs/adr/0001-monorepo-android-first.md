# ADR 0001: 使用 Android-first Monorepo

## 决策

项目采用 monorepo，包含 Android App、KMP shared、Node.js API、Agent worker 和 contracts。

## 原因

- 当前使用人数不超过 3 人，团队和部署边界都很轻。
- App、后端、Agent 会频繁共享业务规则和数据合同。
- AI First 开发需要稳定的上下文、Schema 和文档集中沉淀。

## 后果

- 早期开发和重构成本低。
- 后续如团队扩大，可按 `services/api` 或 `apps/android` 拆分仓库。

Confidence: high
Scope-risk: narrow

