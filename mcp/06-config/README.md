# 06-config — 配置模板与安装脚本

> MCP 的可复用配置与配套工具

## 包含

| 文件 | 说明 |
|---|---|
| [mcp-servers.global.json](mcp-servers.global.json) | **全局** MCP 配置模板（10 个 server） |
| [mcp-servers.projects.json](mcp-servers.projects.json) | **项目级** MCP 配置示例 |
| [setup-mcp.ps1](setup-mcp.ps1) | 合并配置到 `~/.claude.json` 的脚本（含预览与备份） |

---

## 使用方法

### 1. 全局配置

把 `mcp-servers.global.json` 里 `mcpServers` 的内容合并进 `~/.claude.json` 的**顶层** `mcpServers` 字段。

**替换占位符**：

| 占位符 | 替换为 |
|---|---|
| `<YOUR_HOME>` | 用户目录，如 `C:/Users/你的名字` |
| `<YOUR_DRIVE>` | 数据盘，如 `D` |

### 2. 项目级配置

把 `mcp-servers.projects.json` 的内容合并进 `~/.claude.json` 的 `projects.<路径>.mcpServers`。

### 3. 用脚本预览

```powershell
powershell -ExecutionPolicy Bypass -File .\setup-mcp.ps1 -WhatIf
```

脚本会列出将要合并的 server，并**自动备份** `~/.claude.json`。

> ⚠️ 脚本默认**不自动写入**。因为 PowerShell 的 JSON 序列化会重排格式、可能影响原有转义结构。
> 请手动合并，或用 JSON 库（Python/Node）处理。

---

## 🔴 安全红线

| 规则 | 说明 |
|---|---|
| **绝不提交 `~/.claude/settings.json`** | 含真实 `ANTHROPIC_AUTH_TOKEN` |
| **token 用环境变量引用** | `"${env:GITHUB_TOKEN}"`，不要写死 |
| **`@latest` 固定版本** | 避免供应链风险 |
| **限定目录范围** | `filesystem` 类务必加白名单 |

本仓库的 `.gitignore` 已排除 `settings.json`、`.env`、`*.pem` 等。
