import type { FastifyInstance } from "fastify";
import { z } from "zod";
import { agentPolicy } from "../agent/agentPolicy.js";

const summaryRequestSchema = z.object({
  babyId: z.string().min(1),
  range: z.enum(["today", "last_7_days", "last_30_days"]),
});

/**
 * Agent 路由先返回安全占位结果，后续再接入真实模型供应商。
 */
export async function registerAgentRoutes(app: FastifyInstance): Promise<void> {
  app.post("/agent/summary", async (request, reply) => {
    const parsed = summaryRequestSchema.safeParse(request.body);
    if (!parsed.success) {
      return reply.code(400).send({ error: "INVALID_SUMMARY_REQUEST" });
    }

    return {
      policy: agentPolicy,
      summary: "Agent 摘要服务已预留。当前版本只允许事实整理，不提供医疗诊断或用药建议。",
      input: parsed.data,
    };
  });
}

