# 08-mcp — MCP 服务器配置与工具

本目录收录我使用的 **MCP（Model Context Protocol）服务器配置**，以及一个自制的 STM32 调试工具套件。

---

## 📁 目录内容

```
08-mcp/
├── README.md                      ← 本文件
├── setup-mcp.ps1                  ← 合并 MCP 配置到 ~/.claude.json 的脚本
├── config/
│   ├── mcp-servers.global.json    ← 全局 MCP 配置（9 个 server）
│   └── mcp-servers.projects.json  ← 项目级 MCP 配置示例
└── stm32-tools/                   ← 自制 STM32 调试工具套件（MCP server）
    ├── mcp-server.js              ← MCP server 主程序
    ├── closed-loop.js             ← 一键闭环调试
    ├── package.json
    ├── README.md                  ← 工具套件自己的说明
    └── *.bat                      ← 各功能批处理入口
```

---

## 🔌 MCP 服务器清单（9 个）

### 通用能力

| Server | 类型 | 启动命令 | 作用 |
|---|---|---|---|
| `filesystem` | stdio | `npx -y @modelcontextprotocol/server-filesystem` | 文件系统读写访问 |
| `fetch` | stdio | `uvx mcp-server-fetch` | 抓取网页并转 Markdown |
| `memory` | stdio | `npx -y @modelcontextprotocol/server-memory` | 跨会话持久记忆（知识图谱） |
| `sequential-thinking` | stdio | `npx -y @modelcontextprotocol/server-sequential-thinking` | 分步推理辅助 |
| `context7` | stdio | `npx -y @upstash/context7-mcp` | 查询库/框架的最新文档 |

### 开发工具

| Server | 类型 | 启动命令 | 作用 |
|---|---|---|---|
| `github` | stdio | `npx -y @modelcontextprotocol/server-github` | GitHub 仓库操作 |
| `easyeda-mcp-pro` | stdio | `npx -y easyeda-mcp-pro@latest` | 立创EDA 专业版（PCB/原理图） |
| `stm32-tools` | stdio | `node ~/.claude/tools/mcp-server.js` | **自制**：STM32 编译/烧录/串口/寄存器/变量监视 |
| `stm32-data` | stdio | `stm32-data-mcp` | STM32 寄存器与数据手册查询 |

### 项目级（示例）

| Server | 项目 | 启动命令 |
|---|---|---|
| `browser` | 项目 A | `npx -y hyper-mcp-browser` |
| `browser` | 项目 B | `npx -c npx -y @anthropic/mcp-server-playwright` |

---

## 🚀 如何使用

### 前置依赖

| 依赖 | 用途 | 安装 |
|---|---|---|
| **Node.js** ≥ 18 | 跑 `npx` 类 server | https://nodejs.org |
| **uv / uvx** | 跑 `fetch` server | https://docs.astral.sh/uv/ |
| **stm32-data-mcp** | STM32 数据 server | 见 `stm32-tools/README.md` |

### 方式一：手动合并（推荐，最可控）

1. 打开 `~/.claude.json`
2. 找到（或新建）顶层的 `mcpServers` 字段
3. 把 `config/mcp-servers.global.json` 里 `mcpServers` 的内容合并进去
4. **替换占位符**：
   - `<YOUR_HOME>` → 你的用户目录（如 `C:/Users/你的名字`）
   - `<YOUR_DRIVE>` → 数据目录所在盘（如 `D`）
5. 重启 Claude Code / 客户端

### 方式二：用脚本预览

```powershell
cd D:\MySkills\08-mcp
powershell -ExecutionPolicy Bypass -File .\setup-mcp.ps1 -WhatIf
```

脚本会：
- 列出将要合并的 server
- **自动备份** `~/.claude.json` 到 `backups/`

> ⚠️ 出于安全考虑，脚本**不会自动写入**。因为 PowerShell 的 JSON 序列化会重排格式、可能影响 `.claude.json` 中原有的转义与结构。请按上面的「方式一」手动合并。

### 方式三：只装某一个 server

只想要 STM32 工具？把这一段加进 `mcpServers` 即可：

```json
{
  "mcpServers": {
    "stm32-tools": {
      "type": "stdio",
      "command": "cmd",
      "args": ["/c", "node", "C:/Users/你的名字/.claude/tools/mcp-server.js"],
      "env": {}
    }
  }
}
```

---

## 🔧 stm32-tools — 自制 STM32 调试套件

这是我自己写的 MCP server，提供**编译 → 烧录 → 串口监控 → 寄存器读取 → 变量监视**的完整闭环调试能力。

### 快速安装

```powershell
# 1. 复制工具到 .claude/tools
Copy-Item D:\MySkills\08-mcp\stm32-tools -Destination $env:USERPROFILE\.claude\tools -Recurse -Force

# 2. 安装依赖
cd $env:USERPROFILE\.claude\tools
npm install

# 3. 按上面的「方式三」把 stm32-tools 加进 mcpServers
```

### 主要功能入口

| 文件 | 作用 |
|---|---|
| `mcp-server.js` | MCP server 主程序（供 Agent 调用） |
| `closed-loop.js` | 一键闭环：编译 → 烧录 → 串口验证 |
| `build.bat` / `flash.bat` | 单独编译 / 烧录 |
| `serial_monitor.bat` | 串口实时监控 |
| `reg_read.bat` | 寄存器读取与解读 |
| `watch_var.bat` | 变量监视 |
| `mem_monitor.bat` | 内存监控 |
| `stack_analyze.bat` | 栈分析 |
| `code_check.bat` | 代码检查 |
| `tools.bat` | 工具总入口 |

详见 [stm32-tools/README.md](stm32-tools/README.md) 与 [stm32-tools/CLOSED_LOOP.md](stm32-tools/CLOSED_LOOP.md)。

---

## ⚠️ 安全说明

### 本项目已做的脱敏

导出配置时已处理：

- ✅ **不含任何 API key / token / 密码**（已扫描确认）
- ✅ 绝对路径替换为占位符 `<YOUR_HOME>` / `<YOUR_DRIVE>`
- ✅ 项目名替换为 `<PROJECT_PATH_A>` / `<PROJECT_PATH_B>`
- ✅ **排除 `node_modules`**（依赖请自行 `npm install`）

### 你需要自己注意的

| 风险 | 说明 |
|---|---|
| **`github` server** | 需要 GitHub Token。官方已废弃该包，建议改用 [github/github-mcp-server](https://github.com/github/github-mcp-server)。**切勿把 token 写进 JSON 提交到 git** |
| **`filesystem` server** | 未指定允许目录时可能访问过广，建议加 `args` 限定目录 |
| **`easyeda-mcp-pro`** | 走 `npx ... @latest`，每次拉最新版，注意供应链风险 |
| **凭据的正确写法** | 用环境变量引用而非明文，例如：<br>`"env": { "GITHUB_TOKEN": "${env:GITHUB_TOKEN}" }` |

**绝对不要把 `~/.claude/settings.json` 提交上来** —— 该文件含 `ANTHROPIC_AUTH_TOKEN` 等真实凭据。

---

## 📚 相关链接

- MCP 官方文档：https://modelcontextprotocol.io
- 官方 server 列表：https://github.com/modelcontextprotocol/servers
- 本仓库其他 skill 见 [../README.md](../README.md)
