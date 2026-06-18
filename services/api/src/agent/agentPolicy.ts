/**
 * Agent 安全边界：只允许事实整理、摘要和导出，禁止医疗诊断与用药建议。
 */
export const agentPolicy = {
  allowedTasks: ["daily_summary", "weekly_summary", "visit_brief", "memory_digest"],
  forbiddenClaims: ["diagnosis", "prescription", "treatment_advice"],
} as const;

