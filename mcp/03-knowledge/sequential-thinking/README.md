# sequential-thinking

> 分步推理辅助 —— 动态、可反思的问题求解

| 属性 | 值 |
|---|---|
| **用途** | 把复杂问题拆成可回溯的思考步骤 |
| **来源** | 官方 `@modelcontextprotocol/server-sequential-thinking` |
| **类型** | stdio（本地） |
| **状态** | 已安装使用中 |

---

## 配置

```json
"sequential-thinking": {
  "command": "cmd",
  "args": ["/c", "npx", "-y", "@modelcontextprotocol/server-sequential-thinking"]
}
```

---

## 作用

提供一个**结构化的思考框架**：

| 能力 | 说明 |
|---|---|
| 分步思考 | 每步一个 thought，可标注编号 |
| 修正 | 可以修改之前某一步的结论 |
| 分支 | 可以展开多个推理分支 |
| 回溯 | 可回到之前的步骤重新思考 |

---

## 适用场景

- 复杂逻辑推理、算法设计
- 多约束条件下的方案权衡
- 需要"先想清楚再动手"的架构决策

## 不适用

- 简单问答（反而增加开销）
- 需要实时数据的问题（该用 fetch/搜索类 MCP）
