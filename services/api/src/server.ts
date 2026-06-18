import cors from "@fastify/cors";
import Fastify from "fastify";
import { readEnv } from "./config/env.js";
import { registerAgentRoutes } from "./routes/agent.js";
import { registerHealthRoutes } from "./routes/health.js";

/**
 * 创建 API 服务实例，方便后续测试复用同一套路由注册逻辑。
 */
export async function buildServer() {
  const app = Fastify({ logger: true });

  await app.register(cors, { origin: true });
  await registerHealthRoutes(app);
  await registerAgentRoutes(app);

  return app;
}

const env = readEnv();
const app = await buildServer();

await app.listen({ port: env.port, host: "0.0.0.0" });

