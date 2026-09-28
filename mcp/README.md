# mcp — MCP 服务器配置与工具

本目录收录我使用的 **MCP（Model Context Protocol）服务器配置**（10 个），以及一个自制的 STM32 调试工具套件。

---

## 📁 目录结构

按**用途**分成 7 个子类：

```
mcp/
├── 01-eda/                  ⚡ 电子设计自动化（2）
│   ├── kicad/               ⚠️ 需先装 KiCad 9.0+
│   └── easyeda/             立创EDA / EasyEDA Pro
├── 02-embedded/             📟 嵌入式（2）
│   ├── stm32-tools/         自制：编译/烧录/串口/寄存器闭环
│   └── stm32-data/          STM32 寄存器查询
├── 03-knowledge/            🧠 知识与会话增强（3）
│   ├── memory/              知识图谱持久记忆
│   ├── context7/            库/框架最新文档
│   └── sequential-thinking/ 分步推理辅助
├── 04-web/                  🌐 网络与浏览器（2）
│   ├── fetch/               网页抓取转 Markdown
│   └── browser/             浏览器自动化（项目级）
├── 05-devops/               🔧 代码与仓库（2）
│   ├── filesystem/          本地文件读写
│   └── github/              GitHub 操作
├── 06-config/               ⚙️ 配置模板与脚本
│   ├── mcp-servers.global.json
│   ├── mcp-servers.projects.json
│   └── setup-mcp.ps1
└── 07-docs/                 📚 调研文档
    └── RECOMMENDED.md
```

每个 MCP 目录内都有独立 `README.md`（含配置、前置条件、风险、验证状态）。

> 📤 添加新 MCP 前请先读 [../SPEC.md](../SPEC.md)

---
## 🔌 MCP 服务器清单（10 个）

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
| `kicad` | stdio | `.venv/Scripts/python.exe main.py` | **KiCad EDA**：原理图/PCB 分析、网表提取、BOM、DRC（需装 KiCad 9.0+） |

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
cd D:\MySkills\mcp
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
Copy-Item D:\MySkills\mcp\02-embedded\stm32-tools -Destination $env:USERPROFILE\.claude\tools -Recurse -Force

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

详见 [stm32-tools/README.md](02-embedded/stm32-tools/README.md) 与 [stm32-tools/CLOSED_LOOP.md](02-embedded/stm32-tools/CLOSED_LOOP.md)。

---

## 🔧 kicad — KiCad EDA 集成

基于 [lamaalrajih/kicad-mcp](https://github.com/lamaalrajih/kicad-mcp)（MIT，525★）。
让 AI 直接分析 KiCad 工程：网表提取、BOM、DRC、元件连接关系。

### ⚠️ 前置条件：必须先装 KiCad

本 MCP 是 **"KiCad 的遥控器"**，调用 KiCad CLI/API 来读写工程文件。
**没装 KiCad 本体，本 MCP 无法工作。**

| 依赖 | 要求 | 本机状态 |
|---|---|---|
| KiCad | 9.0+ | ❌ **未安装，需自行安装** |
| Python | 3.10+ | ✅ 3.10.20（venv 内） |
| uv | 0.8+ | ✅ 0.11.32 |

KiCad 下载：https://www.kicad.org/download/windows/

### 已完成的安装步骤

```powershell
# 1. 克隆（已做）
mkdir D:\Tools\mcp; cd D:\Tools\mcp
git clone --depth 1 https://github.com/lamaalrajih/kicad-mcp.git

# 2. 创建 venv 并装依赖（已做）
cd kicad-mcp
uv sync

# 3. 配置 ~/.claude.json 的 mcpServers（已做）
```

### 当前配置

```json
"kicad": {
  "type": "stdio",
  "command": "D:/Tools/mcp/kicad-mcp/.venv/Scripts/python.exe",
  "args": ["D:/Tools/mcp/kicad-mcp/main.py"],
  "env": {}
}
```

### 实测结果（无需 KiCad 即可验证的部分已通过）

| 检查 | 结果 |
|---|---|
| venv 创建 | ✅ Python 3.10.20 |
| 依赖安装 | ✅ mcp / fastmcp / pandas / pyyaml / defusedxml |
| 服务器启动 | ✅ serverInfo `{name: KiCad, version: 1.11.0}` |
| MCP 握手 | ✅ protocolVersion 2024-11-05 |
| 能力 | ✅ tools / resources / prompts / experimental |
| **工具数量** | ✅ **16 个** |

**16 个工具**：`list_projects`、`get_project_structure`、`open_project`、`validate_project`、
`generate_pcb_thumbnail`、`generate_project_thumbnail`、`get_drc_history_tool`、`run_drc_check`、
`analyze_bom`、`export_bom_csv`、`extract_schematic_netlist`、`extract_project_netlist`、
`analyze_schematic_connections`、`find_component_connections`、`identify_circuit_patterns` + 1

### 装完 KiCad 后要做的

1. 把 KiCad 的 `bin` 目录加入 PATH（让 `kicad-cli` 可用）
   ```
   C:\Program Files\KiCad\9.0\bin
   ```
2. 可选：在 `D:\Tools\mcp\kicad-mcp\.env` 指定工程搜索路径
   ```
   KICAD_SEARCH_PATHS=D:/PCB,D:/Electronics
   ```
3. 重启客户端，即可让 AI 操作 KiCad 工程

---

## ⭐ 值得加装的 MCP

见 **[07-docs/RECOMMENDED.md](07-docs/RECOMMENDED.md)** —— 基于官方仓库与社区大全调研，挑出对
「嵌入式 STM32 + EDA + CAD + Agent 工作流」最有价值的 MCP，含：

- 三个效率杠杆（省 token / 补上下文 / 能动手）
- 官方服务器状态（含**已归档**警告）
- 建议的加装顺序
- 安全红线

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
