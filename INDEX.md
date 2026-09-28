# 索引表 / Index

> 扁平化索引，三种查法。完整结构见 [README.md](README.md)，上传规范见 [SPEC.md](SPEC.md)

**总计：36 个 skill · 10 个 MCP · 2 大类 · 14 子类**

---

## 一、按子类速查

### 🎯 skills/ — Agent 技能

| 子类 | 数量 | 包含 |
|---|---|---|
| [skills/01-documents](skills/01-documents/) 📄 | 5 | docx, docx-manipulation, pdf, ppt-visual, pptx |
| [skills/02-engineering](skills/02-engineering/) ⚙️ | 6 | cad, cli-creator, dxf, eda-pcb, eda-schematics, io2code |
| [skills/03-dev-workflow](skills/03-dev-workflow/) 🔄 | 7 | brainstorming, dispatching-parallel-agents, executing-plans, finishing-a-development-branch, subagent-driven-development, using-git-worktrees, writing-plans |
| [skills/04-code-quality](skills/04-code-quality/) ✅ | 5 | receiving-code-review, requesting-code-review, systematic-debugging, test-driven-development, verification-before-completion |
| [skills/05-knowledge](skills/05-knowledge/) 🎓 | 3 | find-skills, six-step-learning-map, writing-skills |
| [skills/06-automation](skills/06-automation/) 🤖 | 8 | googlesuper-automation, ponytail ×6, superchat-automation |
| [skills/07-system](skills/07-system/) 🧭 | 2 | local-skill-router, using-superpowers |

### 🔌 mcp/ — MCP 服务器

| 子类 | 数量 | 包含 |
|---|---|---|
| [mcp/01-eda](mcp/01-eda/) ⚡ | 2 | kicad ⚠️, easyeda |
| [mcp/02-embedded](mcp/02-embedded/) 📟 | 2 | stm32-tools, stm32-data |
| [mcp/03-knowledge](mcp/03-knowledge/) 🧠 | 3 | memory, context7, sequential-thinking |
| [mcp/04-web](mcp/04-web/) 🌐 | 2 | fetch, browser |
| [mcp/05-devops](mcp/05-devops/) 🔧 | 2 | filesystem ⚠️, github ⚠️ |
| [mcp/06-config](mcp/06-config/) ⚙️ | — | 配置模板 + setup-mcp.ps1 |
| [mcp/07-docs](mcp/07-docs/) 📚 | — | RECOMMENDED.md |

---

## 二、按名称速查（A-Z）

### skills

| Skill | 子类 | 路径 |
|---|---|---|
| brainstorming | 03-dev-workflow | [`skills/03-dev-workflow/brainstorming/`](skills/03-dev-workflow/brainstorming/) |
| cad | 02-engineering | [`skills/02-engineering/cad/`](skills/02-engineering/cad/) |
| cli-creator | 02-engineering | [`skills/02-engineering/cli-creator/`](skills/02-engineering/cli-creator/) |
| dispatching-parallel-agents | 03-dev-workflow | [`skills/03-dev-workflow/dispatching-parallel-agents/`](skills/03-dev-workflow/dispatching-parallel-agents/) |
| docx | 01-documents | [`skills/01-documents/docx/`](skills/01-documents/docx/) |
| docx-manipulation | 01-documents | [`skills/01-documents/docx-manipulation/`](skills/01-documents/docx-manipulation/) |
| dxf | 02-engineering | [`skills/02-engineering/dxf/`](skills/02-engineering/dxf/) |
| eda-pcb | 02-engineering | [`skills/02-engineering/eda-pcb/`](skills/02-engineering/eda-pcb/) |
| eda-schematics | 02-engineering | [`skills/02-engineering/eda-schematics/`](skills/02-engineering/eda-schematics/) |
| executing-plans | 03-dev-workflow | [`skills/03-dev-workflow/executing-plans/`](skills/03-dev-workflow/executing-plans/) |
| find-skills | 05-knowledge | [`skills/05-knowledge/find-skills/`](skills/05-knowledge/find-skills/) |
| finishing-a-development-branch | 03-dev-workflow | [`skills/03-dev-workflow/finishing-a-development-branch/`](skills/03-dev-workflow/finishing-a-development-branch/) |
| googlesuper-automation | 06-automation | [`skills/06-automation/googlesuper-automation/`](skills/06-automation/googlesuper-automation/) |
| io2code | 02-engineering | [`skills/02-engineering/io2code/`](skills/02-engineering/io2code/) |
| local-skill-router | 07-system | [`skills/07-system/local-skill-router/`](skills/07-system/local-skill-router/) |
| pdf | 01-documents | [`skills/01-documents/pdf/`](skills/01-documents/pdf/) |
| ponytail | 06-automation | [`skills/06-automation/ponytail/`](skills/06-automation/ponytail/) |
| ponytail-audit | 06-automation | [`skills/06-automation/ponytail-audit/`](skills/06-automation/ponytail-audit/) |
| ponytail-debt | 06-automation | [`skills/06-automation/ponytail-debt/`](skills/06-automation/ponytail-debt/) |
| ponytail-gain | 06-automation | [`skills/06-automation/ponytail-gain/`](skills/06-automation/ponytail-gain/) |
| ponytail-help | 06-automation | [`skills/06-automation/ponytail-help/`](skills/06-automation/ponytail-help/) |
| ponytail-review | 06-automation | [`skills/06-automation/ponytail-review/`](skills/06-automation/ponytail-review/) |
| ppt-visual | 01-documents | [`skills/01-documents/ppt-visual/`](skills/01-documents/ppt-visual/) |
| pptx | 01-documents | [`skills/01-documents/pptx/`](skills/01-documents/pptx/) |
| receiving-code-review | 04-code-quality | [`skills/04-code-quality/receiving-code-review/`](skills/04-code-quality/receiving-code-review/) |
| requesting-code-review | 04-code-quality | [`skills/04-code-quality/requesting-code-review/`](skills/04-code-quality/requesting-code-review/) |
| six-step-learning-map | 05-knowledge | [`skills/05-knowledge/six-step-learning-map/`](skills/05-knowledge/six-step-learning-map/) |
| subagent-driven-development | 03-dev-workflow | [`skills/03-dev-workflow/subagent-driven-development/`](skills/03-dev-workflow/subagent-driven-development/) |
| superchat-automation | 06-automation | [`skills/06-automation/superchat-automation/`](skills/06-automation/superchat-automation/) |
| systematic-debugging | 04-code-quality | [`skills/04-code-quality/systematic-debugging/`](skills/04-code-quality/systematic-debugging/) |
| test-driven-development | 04-code-quality | [`skills/04-code-quality/test-driven-development/`](skills/04-code-quality/test-driven-development/) |
| using-git-worktrees | 03-dev-workflow | [`skills/03-dev-workflow/using-git-worktrees/`](skills/03-dev-workflow/using-git-worktrees/) |
| using-superpowers | 07-system | [`skills/07-system/using-superpowers/`](skills/07-system/using-superpowers/) |
| verification-before-completion | 04-code-quality | [`skills/04-code-quality/verification-before-completion/`](skills/04-code-quality/verification-before-completion/) |
| writing-plans | 03-dev-workflow | [`skills/03-dev-workflow/writing-plans/`](skills/03-dev-workflow/writing-plans/) |
| writing-skills | 05-knowledge | [`skills/05-knowledge/writing-skills/`](skills/05-knowledge/writing-skills/) |

### mcp

| MCP | 子类 | 路径 |
|---|---|---|
| browser | 04-web | [`mcp/04-web/browser/`](mcp/04-web/browser/) |
| context7 | 03-knowledge | [`mcp/03-knowledge/context7/`](mcp/03-knowledge/context7/) |
| easyeda | 01-eda | [`mcp/01-eda/easyeda/`](mcp/01-eda/easyeda/) |
| fetch | 04-web | [`mcp/04-web/fetch/`](mcp/04-web/fetch/) |
| filesystem | 05-devops | [`mcp/05-devops/filesystem/`](mcp/05-devops/filesystem/) |
| github | 05-devops | [`mcp/05-devops/github/`](mcp/05-devops/github/) |
| kicad | 01-eda | [`mcp/01-eda/kicad/`](mcp/01-eda/kicad/) |
| memory | 03-knowledge | [`mcp/03-knowledge/memory/`](mcp/03-knowledge/memory/) |
| sequential-thinking | 03-knowledge | [`mcp/03-knowledge/sequential-thinking/`](mcp/03-knowledge/sequential-thinking/) |
| stm32-data | 02-embedded | [`mcp/02-embedded/stm32-data/`](mcp/02-embedded/stm32-data/) |
| stm32-tools | 02-embedded | [`mcp/02-embedded/stm32-tools/`](mcp/02-embedded/stm32-tools/) |

---

## 三、按场景速查

| 我想…… | 用哪个 | 位置 |
|---|---|---|
| 处理 Word / PDF / PPT | docx, pdf, pptx, ppt-visual | skills/01-documents |
| 画 CAD / DXF / PCB / 原理图 | cad, dxf, eda-pcb, eda-schematics | skills/02-engineering |
| 从 IO 表生成 STM32 代码 | io2code | skills/02-engineering |
| 做一个 CLI 工具 | cli-creator | skills/02-engineering |
| 开始一个新功能（先想清楚） | brainstorming | skills/03-dev-workflow |
| 写实现计划 | writing-plans → executing-plans | skills/03-dev-workflow |
| 并行处理多个独立任务 | dispatching-parallel-agents | skills/03-dev-workflow |
| 用子 agent 执行计划 | subagent-driven-development | skills/03-dev-workflow |
| 隔离工作区 | using-git-worktrees | skills/03-dev-workflow |
| 收尾一个开发分支 | finishing-a-development-branch | skills/03-dev-workflow |
| 先写测试 | test-driven-development | skills/04-code-quality |
| 排查 bug | systematic-debugging | skills/04-code-quality |
| 请求 / 接收代码评审 | requesting-code-review, receiving-code-review | skills/04-code-quality |
| 声称"做完了"之前 | verification-before-completion | skills/04-code-quality |
| 系统学一个新主题 | six-step-learning-map | skills/05-knowledge |
| 写一个新 skill | writing-skills | skills/05-knowledge |
| 找更多 skill | find-skills | skills/05-knowledge |
| 精简过度设计的代码 | ponytail 系列 | skills/06-automation |
| 自动化 Google / Superchat | googlesuper-automation, superchat-automation | skills/06-automation |
| 判断该用哪个 skill | local-skill-router, using-superpowers | skills/07-system |
| **设计/分析 PCB 原理图** | kicad 或 easyeda | mcp/01-eda |
| **调试 STM32 硬件** | stm32-tools + stm32-data | mcp/02-embedded |
| **让 AI 记住跨会话信息** | memory | mcp/03-knowledge |
| **查库的最新用法** | context7 | mcp/03-knowledge |
| **拆解复杂推理** | sequential-thinking | mcp/03-knowledge |
| **读网页内容** | fetch | mcp/04-web |
| **浏览器操作/测试** | browser | mcp/04-web |
| **读写本地文件** | filesystem | mcp/05-devops |
| **操作 GitHub 仓库** | github | mcp/05-devops |
| **配置 MCP / 找新 MCP** | 06-config / 07-docs | mcp/ |
