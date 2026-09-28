# browser

> 浏览器自动化（项目级配置）

| 属性 | 值 |
|---|---|
| **用途** | 驱动浏览器：打开页面、点击、填表、截图、抓取 |
| **类型** | stdio（本地） |
| **状态** | 项目级配置，仅特定项目启用 |

---

## ⚠️ 这是项目级配置

与其他 MCP 不同，`browser` **不在全局** `mcpServers` 中，而是挂在具体项目下：

```json
"projects": {
  "<项目路径>": {
    "mcpServers": {
      "browser": { ... }
    }
  }
}
```

原因：浏览器自动化通常只对**前端/网页相关项目**有意义，全局挂着会浪费资源。

---

## 两个变体

| 变体 | 命令 | 说明 |
|---|---|---|
| **hyper-mcp-browser** | `npx -y hyper-mcp-browser` | 轻量浏览器驱动 |
| **playwright** | `cmd /c npx -y @anthropic/mcp-server-playwright` | 功能全，基于 Playwright |

⚠️ `@anthropic/mcp-server-playwright` 官方主仓库中已**归档**，建议关注微软官方的
[playwright-mcp](https://github.com/microsoft/playwright-mcp) 或
[chrome-devtools-mcp](https://github.com/ChromeDevTools/chrome-devtools-mcp)。

---

## 能力

- 导航到 URL
- 按可访问性树定位元素并点击/输入
- 截图
- 执行 JS
- 读取 console 日志

---

## 注意

浏览器 MCP 能控制真实浏览器，**可能访问你的登录态**。仅在信任的场景下启用。
