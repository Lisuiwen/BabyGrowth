# API Contract

## Health

`GET /health`

用于服务健康检查。

## Agent Summary

`POST /agent/summary`

```json
{
  "babyId": "baby-1",
  "range": "today"
}
```

返回事实摘要占位结果。真实模型接入后仍必须遵守“不诊断、不处方、不替代医生”的边界。

