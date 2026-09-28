# MySkills — 我的 AI Agent 资源仓库

[![Private](https://img.shields.io/badge/repo-private-red)](#)
[![Skills](https://img.shields.io/badge/skills-36-blue)](#-skills--技能)
[![MCP](https://img.shields.io/badge/mcp%20servers-10-purple)](#-mcp--服务器)
[![Spec](https://img.shields.io/badge/spec-SPEC.md-green)](SPEC.md)

> 个人 AI Agent 资源集中仓库。兼容 **Claude Code / cc-switch / Codex / Gemini CLI / PI-Desktop** 等客户端。

---

## 📖 这是什么

存放我本人使用和整理的 **36 个 Agent Skill** 与 **10 个 MCP 服务器配置**。

**两大分类**，各自内部再按用途细分：

| 大类 | 是什么 | 数量 |
|---|---|---|
| **[`skills/`](skills/)** | Agent 技能（`SKILL.md` 指令文档） | 36 个 / 7 子类 |
| **[`mcp/`](mcp/)** | MCP 服务器配置与自制工具 | 10 个 / 7 子类 |

> 📤 **要往仓库添加内容？先读 [`SPEC.md`](SPEC.md)** —— 上传规范、目录约定、脱敏要求、提交格式、检查清单。

---

## 🗂 目录结构总览

> `(N extra)` 表示该 skill 除 `SKILL.md` 外还有 N 个辅助文件/目录。

```
MySkills/
│
├── skills/                          🎯 Agent 技能（36 个）
│   ├── 01-documents/                📄 文档处理（5）
│   │   ├── docx/  (2 extra)
│   │   ├── docx-manipulation/
│   │   ├── pdf/  (3 extra)
│   │   ├── ppt-visual/
│   │   └── pptx/  (4 extra)
│   ├── 02-engineering/              ⚙️ 工程 / 硬件 / CAD（6）
│   │   ├── cad/  (5 extra)
│   │   ├── cli-creator/  (3 extra)
│   │   ├── dxf/  (5 extra)
│   │   ├── eda-pcb/  (1 extra)
│   │   ├── eda-schematics/  (1 extra)
│   │   └── io2code/
│   ├── 03-dev-workflow/             🔄 开发流程（7）
│   │   ├── brainstorming/  (3 extra)
│   │   ├── dispatching-parallel-agents/
│   │   ├── executing-plans/
│   │   ├── finishing-a-development-branch/
│   │   ├── subagent-driven-development/  (3 extra)
│   │   ├── using-git-worktrees/
│   │   └── writing-plans/  (1 extra)
│   ├── 04-code-quality/             ✅ 代码质量（5）
│   │   ├── receiving-code-review/
│   │   ├── requesting-code-review/  (1 extra)
│   │   ├── systematic-debugging/  (10 extra)
│   │   ├── test-driven-development/  (1 extra)
│   │   └── verification-before-completion/
│   ├── 05-knowledge/                🎓 学习 / 元技能（3）
│   │   ├── find-skills/
│   │   ├── six-step-learning-map/
│   │   └── writing-skills/  (6 extra)
│   ├── 06-automation/               🤖 自动化 / 代码精简（8）
│   │   ├── googlesuper-automation/
│   │   ├── ponytail/  +  ponytail-audit/  +  ponytail-debt/
│   │   ├── ponytail-gain/  +  ponytail-help/  +  ponytail-review/
│   │   └── superchat-automation/
│   └── 07-system/                   🧭 路由 / 系统（2）
│       ├── local-skill-router/  (1 extra)
│       └── using-superpowers/  (1 extra)
│
├── mcp/                             🔌 MCP 服务器（10 个）
│   ├── 01-eda/                      ⚡ 电子设计自动化（2）
│   │   ├── kicad/                   ⚠️ 需先装 KiCad 9.0+
│   │   └── easyeda/
│   ├── 02-embedded/                 📟 嵌入式（2）
│   │   ├── stm32-tools/  (24 files) ← 自制
│   │   └── stm32-data/
│   ├── 03-knowledge/                🧠 知识与会话增强（3）
│   │   ├── memory/
│   │   ├── context7/
│   │   └── sequential-thinking/
│   ├── 04-web/                      🌐 网络与浏览器（2）
│   │   ├── fetch/
│   │   └── browser/
│   ├── 05-devops/                   🔧 代码与仓库（2）
│   │   ├── filesystem/
│   │   └── github/                  ⚠️ 官方已归档
│   ├── 06-config/                   ⚙️ 配置模板与脚本
│   │   ├── mcp-servers.global.json
│   │   ├── mcp-servers.projects.json
│   │   └── setup-mcp.ps1
│   └── 07-docs/                     📚 调研文档
│       └── RECOMMENDED.md
│
├── SPEC.md                          📤 上传规范（必读）
├── README.md                        ← 本文件
├── INDEX.md                         🔍 三张速查索引
├── install-skills.ps1               批量安装（Windows）
└── install-skills.sh                批量安装（macOS/Linux）
```

**统计**：2 大类 · 14 子类 · 36 skill · 10 MCP · 约 9.0 MB

---

## 🎯 skills — 技能

### 📄 01-documents — 文档处理

| Skill | 大小 | 说明 |
|---|---|---|
| [`docx`](skills/01-documents/docx/) | 1102 KB | 创建、读取、编辑 Word 文档（.docx/.dotx） |
| [`docx-manipulation`](skills/01-documents/docx-manipulation/) | 9 KB | 用 python-docx 编程方式操作 Word |
| [`pdf`](skills/01-documents/pdf/) | 15 KB | 读取/创建/审查 PDF，涉及版式渲染时优先视觉检查 |
| [`ppt-visual`](skills/01-documents/ppt-visual/) | 15 KB | 设计 PPT 页面视觉、布局与配色方案 |
| [`pptx`](skills/01-documents/pptx/) | 1127 KB | 一切 .pptx 相关：创建、解析、编辑、拆分、合并 |

### ⚙️ 02-engineering — 工程 / 硬件 / CAD

| Skill | 大小 | 说明 |
|---|---|---|
| [`cad`](skills/02-engineering/cad/) | 3213 KB | STEP-first 参数化 CAD 零件与装配体 |
| [`cli-creator`](skills/02-engineering/cli-creator/) | 27 KB | 从 API 文档 / OpenAPI / curl 构建可复用 CLI |
| [`dxf`](skills/02-engineering/dxf/) | 3014 KB | 从 Python ezdxf 生成并验证 2D DXF 图纸 |
| [`eda-pcb`](skills/02-engineering/eda-pcb/) | 79 KB | PCB 布局与布线：放置、走线、敷铜、设计规则 |
| [`eda-schematics`](skills/02-engineering/eda-schematics/) | 54 KB | 原理图绘制：图页、符号、连线、网表标签 |
| [`io2code`](skills/02-engineering/io2code/) | 1 KB | 根据 IO 表生成 STM32 代码 |

### 🔄 03-dev-workflow — 开发流程

| Skill | 说明 |
|---|---|
| [`brainstorming`](skills/03-dev-workflow/brainstorming/) | **任何创造性工作之前必用**：探索意图、需求与设计 |
| [`dispatching-parallel-agents`](skills/03-dev-workflow/dispatching-parallel-agents/) | 2 个以上互不依赖的任务并行分派 |
| [`executing-plans`](skills/03-dev-workflow/executing-plans/) | 在带评审检查点的独立会话中执行计划 |
| [`finishing-a-development-branch`](skills/03-dev-workflow/finishing-a-development-branch/) | 完成后决定合并 / PR / 保留 / 丢弃 |
| [`subagent-driven-development`](skills/03-dev-workflow/subagent-driven-development/) | 用子 agent 执行可独立拆分的计划 |
| [`using-git-worktrees`](skills/03-dev-workflow/using-git-worktrees/) | 需要隔离工作区时创建 git worktree |
| [`writing-plans`](skills/03-dev-workflow/writing-plans/) | 有需求后写多步骤实现计划 |

### ✅ 04-code-quality — 代码质量

| Skill | 说明 |
|---|---|
| [`receiving-code-review`](skills/04-code-quality/receiving-code-review/) | 收到评审意见：先验证再落实，不盲从 |
| [`requesting-code-review`](skills/04-code-quality/requesting-code-review/) | 完成任务 / 合并前审查 diff |
| [`systematic-debugging`](skills/04-code-quality/systematic-debugging/) | 遇 bug / 测试失败：先找根因再改 |
| [`test-driven-development`](skills/04-code-quality/test-driven-development/) | 实现前先写失败测试 |
| [`verification-before-completion`](skills/04-code-quality/verification-before-completion/) | **声称"完成"之前**必须先跑验证 |

### 🎓 05-knowledge — 学习 / 元技能

| Skill | 说明 |
|---|---|
| [`find-skills`](skills/05-knowledge/find-skills/) | 发现并安装更多 skill |
| [`six-step-learning-map`](skills/05-knowledge/six-step-learning-map/) | **六步学习法**：地图 → 费曼 → 代码 → 纠偏 → 工程坑 → 刷题 |
| [`writing-skills`](skills/05-knowledge/writing-skills/) | 创建、编辑、验证 skill |

### 🤖 06-automation — 自动化 / 代码精简

| Skill | 说明 |
|---|---|
| [`googlesuper-automation`](skills/06-automation/googlesuper-automation/) | 通过 Rube MCP 自动化 Google Super |
| [`superchat-automation`](skills/06-automation/superchat-automation/) | 通过 Rube MCP 自动化 Superchat |
| [`ponytail`](skills/06-automation/ponytail/) | 强制最简方案：YAGNI、优先标准库 |
| [`ponytail-audit`](skills/06-automation/ponytail-audit/) | 全仓库过度工程审计 |
| [`ponytail-debt`](skills/06-automation/ponytail-debt/) | 收集 `ponytail:` 注释形成技术债台账 |
| [`ponytail-gain`](skills/06-automation/ponytail-gain/) | 展示量化收益 |
| [`ponytail-help`](skills/06-automation/ponytail-help/) | 速查卡 |
| [`ponytail-review`](skills/06-automation/ponytail-review/) | 专注过度工程的代码评审 |

### 🧭 07-system — 路由 / 系统

| Skill | 说明 |
|---|---|
| [`local-skill-router`](skills/07-system/local-skill-router/) | 本地 skill 路由：先读索引表判断用哪个 |
| [`using-superpowers`](skills/07-system/using-superpowers/) | 会话启动规则：响应前先判断是否调用 skill |

---

## 🔌 mcp — 服务器

详见 **[mcp/README.md](mcp/README.md)**

### ⚡ 01-eda — 电子设计自动化

| MCP | 说明 | 状态 |
|---|---|---|
| [`kicad`](mcp/01-eda/kicad/) | KiCad 工程分析：网表、BOM、DRC | ⚠️ 需先装 KiCad 9.0+ |
| [`easyeda`](mcp/01-eda/easyeda/) | 立创EDA / EasyEDA Pro | ✅ 使用中 ⚠️ 用了 `@latest` |

### 📟 02-embedded — 嵌入式

| MCP | 说明 |
|---|---|
| [`stm32-tools`](mcp/02-embedded/stm32-tools/) | **自制**：编译/烧录/串口/寄存器闭环调试 |
| [`stm32-data`](mcp/02-embedded/stm32-data/) | STM32 寄存器与外设定义查询 |

### 🧠 03-knowledge — 知识与会话增强

| MCP | 说明 |
|---|---|
| [`memory`](mcp/03-knowledge/memory/) | 知识图谱跨会话持久记忆 |
| [`context7`](mcp/03-knowledge/context7/) | 库/框架最新文档查询 |
| [`sequential-thinking`](mcp/03-knowledge/sequential-thinking/) | 分步推理辅助 |

### 🌐 04-web — 网络与浏览器

| MCP | 说明 |
|---|---|
| [`fetch`](mcp/04-web/fetch/) | 网页抓取转 Markdown |
| [`browser`](mcp/04-web/browser/) | 浏览器自动化（项目级） |

### 🔧 05-devops — 代码与仓库

| MCP | 说明 |
|---|---|
| [`filesystem`](mcp/05-devops/filesystem/) | 本地文件读写 ⚠️ 建议加目录白名单 |
| [`github`](mcp/05-devops/github/) | GitHub 操作 ⚠️ 官方已归档，建议迁移 |

### ⚙️ 06-config / 📚 07-docs

- [**06-config**](mcp/06-config/) — 配置模板 + 安装脚本 + 安全红线
- [**07-docs**](mcp/07-docs/) — [RECOMMENDED.md](mcp/07-docs/RECOMMENDED.md) 值得加装的高效率 MCP

---

## 🚀 使用

### 安装 skills

```powershell
# 克隆
git clone https://github.com/TTKXSHU/MySkills.git D:\MySkills
cd D:\MySkills

# 全部安装到 ~/.claude/skills
powershell -ExecutionPolicy Bypass -File .\install-skills.ps1

# 只装某些分类
.\install-skills.ps1 -Only 05-knowledge,04-code-quality

# 预览（不实际复制）
.\install-skills.ps1 -WhatIf
```

macOS / Linux：

```bash
./install-skills.sh                  # 全部
./install-skills.sh -c 05-knowledge  # 指定分类
./install-skills.sh -n               # 试运行
```

### 配置 MCP

见 [mcp/06-config/README.md](mcp/06-config/README.md)

---

## 🔒 安全

| 规则 | 说明 |
|---|---|
| 🔴 **绝不提交 `~/.claude/settings.json`** | 含真实 `ANTHROPIC_AUTH_TOKEN` |
| 🔴 **token 用环境变量引用** | `"${env:GITHUB_TOKEN}"`，不写死 |
| 🟡 **仓库保持 Private** | 含 Anthropic 版权的 `docx`/`pptx` |

`.gitignore` 已排除 `settings.json`、`.claude.json`、`.env`、`*.pem`、`node_modules` 等。

---

## ⚠️ 版权

**自建**：`io2code`、`six-step-learning-map`、`local-skill-router`、`eda-pcb`、`eda-schematics`、`stm32-tools`

**第三方**（版权归原作者，目录内 LICENSE 已保留）：

| Skill | 许可 |
|---|---|
| `docx`、`pptx` | © 2025 Anthropic, PBC — All rights reserved（仅限 Anthropic 服务内使用） |
| `pdf`、`cli-creator` | Apache-2.0 |
| `cad`、`dxf` | MIT, © 2026 Thompson Labs LLC |
| `ponytail` 系列 | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) |
| 其余 dev-workflow / code-quality | Superpowers 生态 |

> **本仓库为私有**，不作公开分发。公开或再分发前请确认许可条款。

---

*新增内容前请阅读 [`SPEC.md`](SPEC.md)*
