# fetch

> 网页抓取并转换为 Markdown

| 属性 | 值 |
|---|---|
| **用途** | 抓取网页内容，转成 AI 易读的格式 |
| **来源** | 官方 `mcp-server-fetch`（Python） |
| **类型** | stdio（本地） |
| **状态** | 已安装使用中 |

---

## 配置

```json
"fetch": {
  "type": "stdio",
  "command": "uvx",
  "args": ["mcp-server-fetch"]
}
```

> 用 `uvx` 而非 `npx`：这是官方 **Python** 实现，由 uv 管理。

---

## 前置依赖

需要 `uv`（含 `uvx`）：

```powershell
# 检查
uv --version
```

未安装见 https://docs.astral.sh/uv/

---

## 作用

- 抓取 URL 内容
- 自动转成干净的 Markdown（去掉导航栏、广告等噪音）
- 支持分页读取长文档（`start_index` 参数）

---

## 典型用法

- 读官方文档、API 参考
- 抓取博客/教程正文
- 配合 `github` MCP 读 issue/PR 讨论

---

## 注意

⚠️ 只能抓取**公开可访问**的页面。需要登录的站点会被拦住。
