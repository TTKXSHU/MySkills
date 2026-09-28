# filesystem

> 文件系统读写访问

| 属性 | 值 |
|---|---|
| **用途** | 让 AI 读写本地文件 |
| **来源** | 官方 `@modelcontextprotocol/server-filesystem` |
| **类型** | stdio（本地） |
| **状态** | 已安装使用中 |

---

## 配置

```json
"filesystem": {
  "command": "cmd",
  "args": ["/c", "npx", "-y", "@modelcontextprotocol/server-filesystem"]
}
```

---

## ⚠️ 安全建议：加目录白名单

当前配置**没有限定允许访问的目录**，意味着理论上可访问范围过广。

**推荐改成**（把路径作为额外参数传入）：

```json
"filesystem": {
  "command": "cmd",
  "args": [
    "/c", "npx", "-y", "@modelcontextprotocol/server-filesystem",
    "D:/my_program",
    "D:/PCB"
  ]
}
```

这样只有列出的目录可被访问。

---

## 能力

| 操作 | 说明 |
|---|---|
| 读 | 读文件、列出目录 |
| 写 | 创建/修改文件 |
| 移动 | 重命名、移动 |
| 搜索 | 按名称/内容搜索 |
| 元信息 | 文件大小、修改时间 |

---

## 注意

⚠️ 官方明确说明这些是**参考实现**，非生产级。用于重要数据前请自行评估风险。
