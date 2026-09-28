# memory

> 基于知识图谱的跨会话持久记忆

| 属性 | 值 |
|---|---|
| **用途** | 记住跨会话的事实、实体、关系 |
| **来源** | 官方 `@modelcontextprotocol/server-memory` |
| **类型** | stdio（本地） |
| **状态** | 已安装使用中 |

---

## 配置

```json
"memory": {
  "command": "cmd",
  "args": ["/c", "npx", "-y", "@modelcontextprotocol/server-memory"]
}
```

---

## 作用

以**知识图谱**形式存储：
- 实体（Entity）
- 关系（Relation）
- 观察（Observation）

用于让 AI 记住"你是谁""你在做什么项目""上次讨论了什么"，不随会话结束而丢失。

---

## 数据位置

默认存储在本地。可在 `env` 中通过 `MEMORY_FILE_PATH` 指定存储文件：

```json
"env": { "MEMORY_FILE_PATH": "<DRIVE>:/path/to/memory.json" }
```

---

## 注意

⚠️ 记忆内容会写入本地文件。**不要把该文件提交到公开仓库**（可能含个人信息）。
