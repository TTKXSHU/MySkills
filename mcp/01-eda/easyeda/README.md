# easyeda-mcp-pro

> 立创EDA / EasyEDA 专业版集成

| 属性 | 值 |
|---|---|
| **用途** | 立创EDA（EasyEDA Pro）原理图与 PCB 操作 |
| **包名** | `easyeda-mcp-pro`（npm） |
| **类型** | stdio（本地） |
| **状态** | 已安装使用中 |

---

## 配置

```json
"easyeda-mcp-pro": {
  "type": "stdio",
  "command": "cmd",
  "args": ["/c", "npx", "-y", "easyeda-mcp-pro@latest"],
  "env": {
    "TOOL_PROFILE": "pro"
  }
}
```

### `TOOL_PROFILE`

`pro` 表示专业版。若用标准版（EasyEDA Standard）需改成对应值。

---

## ⚠️ 风险提示

| 风险 | 说明 | 建议 |
|---|---|---|
| **`@latest`** | 每次启动拉取最新版，版本不可控，存在供应链风险 | 固定版本号，如 `easyeda-mcp-pro@1.2.3` |
| **npx 下载执行** | 首次运行会从 npm 下载并执行代码 | 确认包名拼写无误 |

**建议改为固定版本**：

```json
"args": ["/c", "npx", "-y", "easyeda-mcp-pro@<具体版本>"]
```

用 `npm view easyeda-mcp-pro version` 查当前版本。

---

## 相关

- 与 [kicad](../kicad/) 同级：两者都是 EDA 工具，可并存（针对不同工程）
- 调研见 [../../07-docs/RECOMMENDED.md](../../07-docs/RECOMMENDED.md)
