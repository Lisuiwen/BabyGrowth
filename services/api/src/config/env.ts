/**
 * API 环境配置集中读取，避免业务代码直接访问 process.env。
 */
export type ApiEnv = {
  readonly port: number;
  readonly agentEnabled: boolean;
};

/**
 * 解析运行环境，首版默认关闭真实 Agent 调用，防止误把模型 Key 放到客户端。
 */
export function readEnv(): ApiEnv {
  return {
    port: Number(process.env.PORT ?? 3000),
    agentEnabled: process.env.AGENT_ENABLED === "true",
  };
}

