# 03-knowledge — 知识与会话增强

> 记忆、文档查询、推理辅助

## 包含

| MCP | 说明 | 解决什么问题 |
|---|---|---|
| [memory](memory/) | 知识图谱持久记忆 | AI 忘了上次说过什么 |
| [context7](context7/) | 库/框架最新文档 | AI 用过时的 API |
| [sequential-thinking](sequential-thinking/) | 分步推理辅助 | 复杂问题想不清楚 |

## 三个不同的层次

```
memory             context7            sequential-thinking
记住「你的」事      查「外部」知识       组织「思考」过程
   ↓                   ↓                     ↓
跨会话个人上下文    最新技术文档          结构化推理
```

互不重叠，建议三个都开。

## 成本

| MCP | 开销 |
|---|---|
| memory | 低（本地文件） |
| context7 | 低（按需查询） |
| sequential-thinking | 中（会增加 token 消耗，仅复杂问题启用） |
