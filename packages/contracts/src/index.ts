/**
 * 跨端合同包，后续可从 OpenAPI/JSON Schema 生成 Kotlin 和 TypeScript 类型。
 */
export type AgentSummaryRange = "today" | "last_7_days" | "last_30_days";

/**
 * Agent 摘要请求 DTO，App 和 API 共享同一语义。
 */
export type AgentSummaryRequest = {
  readonly babyId: string;
  readonly range: AgentSummaryRange;
};

