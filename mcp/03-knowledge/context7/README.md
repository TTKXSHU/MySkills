# context7

> 查询库/框架的**最新**文档

| 属性 | 值 |
|---|---|
| **用途** | 获取第三方库、框架的实时文档与用法示例 |
| **来源** | [upstash/context7](https://github.com/upstash/context7) |
| **包名** | `@upstash/context7-mcp` |
| **类型** | stdio（本地） |
| **状态** | 已安装使用中 |

---

## 配置

```json
"context7": {
  "type": "stdio",
  "command": "cmd",
  "args": ["/c", "npx", "-y", "@upstash/context7-mcp"]
}
```

---

## 为什么有用

AI 的训练数据有截止日期，容易给出**过时的 API 用法**。
context7 直接拉取库的最新文档，避免"用已废弃的 API 写代码"。

典型场景：
- "用最新版 FastAPI 怎么写依赖注入？"
- "React 19 的 useActionState 怎么用？"
- "这个库最新版本改了什么？"

---

## 用法

在提问时提及库名即可触发。部分客户端支持在提示中显式指定：

```
用 context7 查一下 xxx 库的最新用法
```
