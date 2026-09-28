# MCP 推荐清单 — 值得加装的高效率 MCP 服务器

> 调研时间：2026-09 ｜ 来源：官方 [modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers)、[punkpeye/awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers)
>
> 本清单**只列推荐**，不代表已安装。你当前已装的 9 个见 [mcp-servers.global.json](mcp-servers.global.json)。
>
> ⚠️ 所有第三方 MCP 都**未经审计**。MCP server 能读写文件、执行命令、访问网络，装之前务必看源码与权限。

---

## 🎯 针对你的场景优先推荐

你的使用画像：**嵌入式 STM32 开发 + EDA(立创/PCB) + CAD/DXF + Agent 工作流**。

### 第一优先级（强烈建议）

| MCP | 是什么 | 为什么适合你 |
|---|---|---|
| **`mcp-server-git`**（官方） | Git 仓库读写、搜索、提交、diff | 你现在手动跑 git 命令；接上后 AI 能自己看 diff、查历史、定位回归点 |
| **`git-mcp`** / **`github-mcp-server`**（官方新版） | GitHub 仓库、PR、Issue 操作 | 你已经有 MySkills 仓库，接上后能自动开 PR、改文件、管 Issue。<br>⚠️ 你现在装的 `@modelcontextprotocol/server-github` 已归档废弃，**建议换** |
| **`mcp-server-time`**（官方） | 时区/时间换算 | 日志时间戳对齐、跨时区调试。体积极小，零成本 |
| **`serena`** | 语义级代码检索与符号编辑（LSP 驱动） | 比 grep 强得多：按符号找定义/引用、跨文件重命名。大工程省大量 token |
| **`context7`**（你已装 ✅） | 查库/框架最新文档 | 已在用，保持 |

### 第二优先级（你的领域专属）

| MCP | 领域 | 说明 |
|---|---|---|
| **`kicad-mcp`** 系列 | EDA | KiCad PCB/原理图操作，你已有 `eda-pcb`/`eda-schematics` skill，接上 MCP 就能**真的改板子** |
| **`easyeda-mcp-pro`**（你已装 ✅） | EDA | 立创EDA，已在用 |
| **`arduino-mcp`** / 串口类 MCP | 嵌入式 | 编译、烧录、串口交互 |
| **`mcp-server-sqlite`**（官方） | 数据库 | 你本地有 `cc-switch.db`、`pi.sqlite`，能直接查询分析 |
| **`mcp-server-fetch`**（你已装 ✅） | 网络 | 已在用 |

### 第三优先级（工作流增强）

| MCP | 作用 | 说明 |
|---|---|---|
| **`mcp-server-memory`**（官方，你已装 ✅） | 知识图谱持久记忆 | 已在用 |
| **`mcp-server-sequential-thinking`**（你已装 ✅） | 分步推理 | 已在用 |
| **`mcp-server-filesystem`**（官方，你已装 ✅） | 文件读写 | ⚠️ 你当前**没限定目录**，建议加白名单参数 |
| **`hyper-mcp-browser`** / **`playwright-mcp`**（你已装 ✅） | 浏览器自动化 | 已在用 |
| **`chrome-devtools-mcp`**（Google 官方） | Chrome 调试 | 性能 trace、网络分析、Console，比 playwright 更偏调试 |

---

## 📊 官方参考服务器（Anthropic 维护，最稳）

来源：`modelcontextprotocol/servers` 仓库。**官方明确说明这些是"参考实现"，非生产级**。

| Server | 作用 | 状态 |
|---|---|---|
| `everything` | 参考/测试服务器 | 活跃 |
| `fetch` | 网页抓取转 Markdown | 活跃 ✅ 你已装 |
| `filesystem` | 文件操作（可控访问） | 活跃 ✅ 你已装 |
| `git` | Git 读写、搜索、操作 | 活跃 ⭐ 推荐 |
| `memory` | 知识图谱持久记忆 | 活跃 ✅ 你已装 |
| `sequentialthinking` | 动态反思式问题求解 | 活跃 ✅ 你已装 |
| `time` | 时间与时区换算 | 活跃 ⭐ 推荐 |
| ~~`github`~~ | GitHub API | **已归档** ⚠️ |
| ~~`gitlab`~~ | GitLab | **已归档** |
| ~~`google-drive`~~ | Google Drive | **已归档** |
| ~~`postgres`~~ | PostgreSQL | **已归档** |
| ~~`puppeteer`~~ | 浏览器自动化 | **已归档**（改用 playwright） |
| ~~`sqlite`~~ | SQLite | **已归档** |
| ~~`slack`~~ | Slack | **已归档**（转 Zencoder 维护） |

> **重要**：官方归档了一批。你装的 `github` 就在归档名单里 —— 建议迁移到 [github/github-mcp-server](https://github.com/github/github-mcp-server)。

---

## 🛠️ 社区高价值 MCP（按类别）

来源：`punkpeye/awesome-mcp-servers`（数千个，此处只挑高效率的）。

### 🤖 Coding Agents — 编码助手

| MCP | 作用 | 亮点 |
|---|---|---|
| **`oraios/serena`** | 语义代码检索 + 符号级编辑 | LSP 驱动，比文本搜索精准，省 token |
| **`mcp-injector`**（foldwork-dev） | 代码库预索引成 SQLite，返回 AST 压缩快照 | **显著降 token 消耗** |
| **`code-to-tree`** | 任意语言源码 → AST | 结构化理解代码 |
| **`synapse-mcp`** | 代码库 → 本地 AST 知识图谱 | 给 agent 结构上下文，利于重构 |
| **`codemcp`**（ezyang） | 带读写和命令行的基础编码 agent | 轻量 |
| **`mcp-server-commands`** | 执行任意命令/脚本 | 通用 |
| **`micl2e2/code-to-tree`** | AST 转换 | 📟 嵌入式标注 |

### 📂 浏览器自动化

| MCP | 作用 |
|---|---|
| **`chrome-devtools-mcp`** | Chrome 调试（性能 trace、网络、Console） |
| **`agent-infra/mcp-server-browser`** | Puppeteer 驱动，支持本地/远程 |
| **`veilbrowser`** | 隐形 Chrome 自动化，可附着到已登录会话 |
| **`nodriver-mcp-server`** | 反爬场景的未检测 Chrome 自动化 |

### 💻 代码执行 / 沙箱

| MCP | 作用 |
|---|---|
| **`e2b-sandbox-mcp`** | 云端隔离 Linux VM，克隆仓库跑命令，不碰本机 |
| **`dagger/container-use`** | 每个 agent 独立容器 + git 分支 |
| **`capsule/mcp-server`** | WASM 沙箱跑不受信 Python/JS |
| **`matlab-mcp-server-python`** | MATLAB 集成：执行、异步任务、Plotly 图 |

### 🗄️ 数据库

| MCP | 作用 |
|---|---|
| **`mnemiq`** | 自然语言查 Postgres/Oracle/Snowflake/DuckDB/SQLite，SQL 先确定性校验再执行 |
| **`sql-query-mcp`** | Postgres/MySQL：schema 发现、采样、只读查询、执行计划 |
| **`dockndevai/mcp-clickhouse`** | ClickHouse 分析查询，带访问模式和审计 |

### 🧠 知识与记忆

| MCP | 作用 |
|---|---|
| **`memory`**（官方） | 知识图谱持久记忆 ✅ 你已装 |
| **`context7`** | 库/框架最新文档 ✅ 你已装 |

---

## ⚡ 效率提升的"三个杠杆"

装 MCP 不是越多越好。真正提效的是这三类：

### 1️⃣ 省 token（最直接）
- **`mcp-injector`** — AST 压缩快照
- **`serena`** — 语义检索，不用全文 grep
- **`synapse-mcp`** — AST 知识图谱

### 2️⃣ 补上下文（减少来回问）
- **`git`** — AI 自己看 diff / 历史
- **`context7`** — 最新文档，不用你贴
- **`chrome-devtools-mcp`** — 前端调试自闭环

### 3️⃣ 能动手（从"建议"到"执行"）
- **`kicad-mcp`** — 真的改 PCB
- **`e2b-sandbox-mcp`** — 安全执行
- **`github-mcp-server`** — 真的开 PR

---

## 🚨 安全红线（必读）

| 风险 | 说明 |
|---|---|
| **MCP 是代码执行** | server 能读写文件、跑命令、连网络。等同给 AI 装了一只手 |
| **优先官方** | 官方 `modelcontextprotocol/servers` 最稳；社区包良莠不齐 |
| **`@latest` 有供应链风险** | 你 `easyeda-mcp-pro` 用了 `@latest`，每次拉最新版，建议固定版本号 |
| **token 绝不写死** | 用环境变量：`"env": { "GITHUB_TOKEN": "${env:GITHUB_TOKEN}" }` |
| **限定目录** | `filesystem` 这类务必加允许路径白名单 |
| **⚠️ 切勿提交 `~/.claude/settings.json`** | 含真实 `ANTHROPIC_AUTH_TOKEN` |

---

## 📋 建议的加装顺序（按性价比）

```
第 1 步：mcp-server-git          ← 立刻能用，零风险
第 2 步：mcp-server-time         ← 极小，顺手
第 3 步：github-mcp-server       ← 替换已归档的 github
第 4 步：serena 或 mcp-injector  ← 省 token，大工程收益明显
第 5 步：chrome-devtools-mcp     ← 前端/网页调试
第 6 步：kicad-mcp               ← EDA 闭环（需 KiCad 环境）
```

---

## 🔗 参考链接

| 资源 | 地址 |
|---|---|
| 官方参考服务器 | https://github.com/modelcontextprotocol/servers |
| 官方归档服务器 | https://github.com/modelcontextprotocol/servers-archived |
| 社区大全（数千个） | https://github.com/punkpeye/awesome-mcp-servers |
| MCP 官方文档 | https://modelcontextprotocol.io |
| MCP Registry（官方注册表） | https://github.com/modelcontextprotocol/registry |
| GitHub MCP（官方新版） | https://github.com/github/github-mcp-server |
| Chrome DevTools MCP | https://github.com/ChromeDevTools/chrome-devtools-mcp |

---

*本清单为调研汇总，未逐个实测。加装前请自行审查源码与权限范围。*
