import type { FastifyInstance } from "fastify";

/**
 * 健康检查路由，用于本地开发、部署平台探活和 CI smoke test。
 */
export async function registerHealthRoutes(app: FastifyInstance): Promise<void> {
  app.get("/health", async () => ({
    ok: true,
    service: "baby-growth-log-api",
  }));
}

