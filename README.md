# MySkills — 我的 AI Agent Skills 仓库

[![Private](https://img.shields.io/badge/repo-private-red)](#)
[![Skills](https://img.shields.io/badge/skills-36-blue)](#-技能总览)
[![Size](https://img.shields.io/badge/size-8.8MB-lightgrey)](#)

> 个人 AI Agent 技能（Skills）集中仓库。兼容 **Claude Code / cc-switch / Codex / Gemini CLI / PI-Desktop** 等支持 `SKILL.md` 规范的 Agent。

---

## 📖 这个仓库是什么

存放我本人使用和整理的 **36 个 Agent Skill**。每个 skill 是一个独立目录，内含一份 `SKILL.md`（技能定义，YAML front matter + Markdown 指令），部分 skill 还带有 `scripts/`、`references/` 等辅助文件。

**目录分类规则**：按**用途领域**分成 7 个大类，类名前缀 `01-` ~ `07-` 保证排序稳定、方便查找。

---

## 🗂 目录结构总览

> 一张图看清每个文件夹下有哪些 skill。`(N extra)` 表示该 skill 除 `SKILL.md` 外还有 N 个辅助文件/目录。

```
MySkills/
├── 01-documents/                    📄 文档处理（5）
│   ├── docx/  (2 extra)
│   ├── docx-manipulation/
│   ├── pdf/  (3 extra)
│   ├── ppt-visual/
│   └── pptx/  (4 extra)
├── 02-engineering/                  ⚙️ 工程 / 硬件 / CAD（6）
│   ├── cad/  (5 extra)
│   ├── cli-creator/  (3 extra)
│   ├── dxf/  (5 extra)
│   ├── eda-pcb/  (1 extra)
│   ├── eda-schematics/  (1 extra)
│   └── io2code/
├── 03-dev-workflow/                 🔄 开发流程（7）
│   ├── brainstorming/  (3 extra)
│   ├── dispatching-parallel-agents/
│   ├── executing-plans/
│   ├── finishing-a-development-branch/
│   ├── subagent-driven-development/  (3 extra)
│   ├── using-git-worktrees/
│   └── writing-plans/  (1 extra)
├── 04-code-quality/                 ✅ 代码质量（5）
│   ├── receiving-code-review/
│   ├── requesting-code-review/  (1 extra)
│   ├── systematic-debugging/  (10 extra)
│   ├── test-driven-development/  (1 extra)
│   └── verification-before-completion/
├── 05-knowledge/                    🎓 学习 / 元技能（3）
│   ├── find-skills/
│   ├── six-step-learning-map/
│   └── writing-skills/  (6 extra)
├── 06-automation/                   🤖 自动化 / 代码精简（8）
│   ├── googlesuper-automation/
│   ├── ponytail/
│   ├── ponytail-audit/
│   ├── ponytail-debt/
│   ├── ponytail-gain/
│   ├── ponytail-help/
│   ├── ponytail-review/
│   └── superchat-automation/
└── 07-system/                       🧭 路由 / 系统（2）
    ├── local-skill-router/  (1 extra)
    └── using-superpowers/  (1 extra)
```

**统计**：7 个分类 · 36 个 skill · 420 个文件 · 约 8.8 MB

---

## 📋 技能总览（点击分类展开）

### 📄 01-documents — 文档处理

| Skill | 大小 | 说明 |
|---|---|---|
| [`docx`](01-documents/docx/) | 1102 KB | 创建、读取、编辑 Word 文档（.docx/.dotx）。触发词：Word 文档、.docx |
| [`docx-manipulation`](01-documents/docx-manipulation/) | 9 KB | 用 python-docx 以编程方式操作 Word 文档 |
| [`pdf`](01-documents/pdf/) | 15 KB | 读取/创建/审查 PDF，涉及版式渲染时优先用视觉检查（Poppler） |
| [`ppt-visual`](01-documents/ppt-visual/) | 15 KB | 设计 PPT 页面视觉、布局与配色方案（只出方案，不生成文件） |
| [`pptx`](01-documents/pptx/) | 1127 KB | 一切 .pptx 相关：创建、解析、编辑、拆分、合并演示文稿 |

### ⚙️ 02-engineering — 工程 / 硬件 / CAD

| Skill | 大小 | 说明 |
|---|---|---|
| [`cad`](02-engineering/cad/) | 3213 KB | STEP-first 参数化 CAD 零件与装配体：创建、修改、检查、验证 |
| [`cli-creator`](02-engineering/cli-creator/) | 27 KB | 从 API 文档 / OpenAPI / curl 样例构建可复用 CLI |
| [`dxf`](02-engineering/dxf/) | 3014 KB | 从 Python ezdxf 生成并验证 2D DXF 图纸（激光/等离子/水刀切割） |
| [`eda-pcb`](02-engineering/eda-pcb/) | 79 KB | PCB 布局与布线：元件放置、走线、敷铜、设计规则、DFM 优化 |
| [`eda-schematics`](02-engineering/eda-schematics/) | 54 KB | 原理图绘制：图页、符号、连线、网表标签、层次化设计 |
| [`io2code`](02-engineering/io2code/) | 1 KB | 根据 IO 表配置文件生成 STM32 代码 |

### 🔄 03-dev-workflow — 开发流程

| Skill | 大小 | 说明 |
|---|---|---|
| [`brainstorming`](03-dev-workflow/brainstorming/) | 73 KB | **任何创造性工作之前必用**：探索意图、需求与设计 |
| [`dispatching-parallel-agents`](03-dev-workflow/dispatching-parallel-agents/) | 7 KB | 面对 2 个以上互不依赖的任务时并行分派子 agent |
| [`executing-plans`](03-dev-workflow/executing-plans/) | 3 KB | 在带评审检查点的独立会话中执行书面实现计划 |
| [`finishing-a-development-branch`](03-dev-workflow/finishing-a-development-branch/) | 7 KB | 实现完成、测试通过后，决定合并 / PR / 保留 / 丢弃 |
| [`subagent-driven-development`](03-dev-workflow/subagent-driven-development/) | 38 KB | 在当前会话中用子 agent 执行可独立拆分的实现计划 |
| [`using-git-worktrees`](03-dev-workflow/using-git-worktrees/) | 7 KB | 需要隔离工作区时创建 git worktree |
| [`writing-plans`](03-dev-workflow/writing-plans/) | 9 KB | 有需求或设计后，写多步骤实现计划 |

### ✅ 04-code-quality — 代码质量

| Skill | 大小 | 说明 |
|---|---|---|
| [`receiving-code-review`](04-code-quality/receiving-code-review/) | 6 KB | 收到代码评审意见时：先验证再落实，不盲从 |
| [`requesting-code-review`](04-code-quality/requesting-code-review/) | 8 KB | 完成任务 / 合并前审查 diff 是否满足需求 |
| [`systematic-debugging`](04-code-quality/systematic-debugging/) | 40 KB | 遇到 bug、测试失败、异常行为时：先找根因再改 |
| [`test-driven-development`](04-code-quality/test-driven-development/) | 18 KB | 实现功能或修 bug 前：先写失败测试 |
| [`verification-before-completion`](04-code-quality/verification-before-completion/) | 4 KB | **声称"完成/修好/通过"之前**：必须先跑验证并看输出 |

### 🎓 05-knowledge — 学习 / 元技能

| Skill | 大小 | 说明 |
|---|---|---|
| [`find-skills`](05-knowledge/find-skills/) | 6 KB | 发现并安装更多 skill |
| [`six-step-learning-map`](05-knowledge/six-step-learning-map/) | 7 KB | **六步学习法**：知识地图 → 费曼理解 → 最小可跑代码 → 自测纠偏 → 工程坑 → 刷题巩固 |
| [`writing-skills`](05-knowledge/writing-skills/) | 105 KB | 创建、编辑、验证 skill |

### 🤖 06-automation — 自动化 / 代码精简

| Skill | 大小 | 说明 |
|---|---|---|
| [`googlesuper-automation`](06-automation/googlesuper-automation/) | 3 KB | 通过 Rube MCP 自动化 Google Super |
| [`superchat-automation`](06-automation/superchat-automation/) | 3 KB | 通过 Rube MCP 自动化 Superchat |
| [`ponytail`](06-automation/ponytail/) | 7 KB | 强制最懒但可行的方案：YAGNI、优先标准库、拒绝过度设计 |
| [`ponytail-audit`](06-automation/ponytail-audit/) | 2 KB | 全仓库过度工程审计：列出该删/该简化的部分 |
| [`ponytail-debt`](06-automation/ponytail-debt/) | 2 KB | 收集代码库内所有 `ponytail:` 注释，形成技术债台账 |
| [`ponytail-gain`](06-automation/ponytail-gain/) | 2 KB | 展示 ponytail 的量化收益（更少代码/成本/更快） |
| [`ponytail-help`](06-automation/ponytail-help/) | 3 KB | ponytail 全部模式与命令的速查卡 |
| [`ponytail-review`](06-automation/ponytail-review/) | 2 KB | 专注过度工程的代码评审：找出可删除项 |

### 🧭 07-system — 路由 / 系统

| Skill | 大小 | 说明 |
|---|---|---|
| [`local-skill-router`](07-system/local-skill-router/) | 7 KB | 本地 skill 路由入口：先读索引表判断该用哪个 skill |
| [`using-superpowers`](07-system/using-superpowers/) | 7 KB | 会话启动规则：任何响应前先判断是否需调用 skill |

---

## 🚀 如何使用

### 方式一：整体克隆到本地 skills 目录（推荐）

```bash
# 1. 克隆仓库
git clone https://github.com/TTKXSHU/MySkills.git

# 2. 把某个分类下的 skill 复制到 agent 的 skills 目录
#    Claude Code / cc-switch 默认目录：~/.claude/skills/
cp -r MySkills/05-knowledge/six-step-learning-map ~/.claude/skills/
```

Windows PowerShell：

```powershell
git clone https://github.com/TTKXSHU/MySkills.git
Copy-Item .\MySkills\05-knowledge\six-step-learning-map -Destination $env:USERPROFILE\.claude\skills\ -Recurse
```

### 方式二：在 cc-switch 里通过仓库地址添加

cc-switch 支持以 `owner/repo:skill-name` 的形式从 GitHub 添加 skill。例如：

```
TTKXSHU/MySkills:six-step-learning-map
```

> 注：cc-switch 默认按仓库根目录查找 skill。若自动识别失败，请用**方式一**手动复制，或用下面的脚本批量展开。

### 方式三：批量展开到本地（去掉分类层级）

因为这个仓库按分类分了子目录，而 agent 通常要求 skill 直接位于 `skills/` 根下，可以用下面的脚本把分类目录**压平**后复制：

```powershell
# 把仓库内所有 skill 压平复制到 ~/.claude/skills/
$repo = ".\MySkills"
$dest = "$env:USERPROFILE\.claude\skills"
Get-ChildItem $repo -Directory | ForEach-Object {
  Get-ChildItem $_.FullName -Directory | ForEach-Object {
    Copy-Item $_.FullName -Destination $dest -Recurse -Force
    Write-Host "installed: $($_.Name)"
  }
}
```

```bash
# macOS / Linux 版本
for cat in MySkills/*/; do
  for skill in "$cat"*/; do
    cp -r "$skill" ~/.claude/skills/
    echo "installed: $(basename "$skill")"
  done
done
```

---

## ➕ 如何新增一个 Skill

**步骤**：

1. **确定分类** —— 从下面 7 个里选一个；若都不合适，新建 `08-xxx/`（保持两位数字前缀让排序稳定）。

   | 分类 | 放什么 |
   |---|---|
   | `01-documents` | 文档、演示文稿、PDF 类 |
   | `02-engineering` | 硬件、CAD、EDA、嵌入式、CLI 工具 |
   | `03-dev-workflow` | 需求、计划、分支、协作流程 |
   | `04-code-quality` | 测试、调试、评审、验证 |
   | `05-knowledge` | 学习、写 skill、找 skill |
   | `06-automation` | 外部服务自动化、代码精简 |
   | `07-system` | 路由、会话入口、系统级规则 |

2. **创建 skill 目录**，内部至少要有 `SKILL.md`：

   ```
   <分类>/<skill-name>/
   ├── SKILL.md          # 必需
   ├── references/       # 可选：参考文档
   └── scripts/          # 可选：辅助脚本
   ```

3. **`SKILL.md` 头部必须含 front matter**：

   ```markdown
   ---
   name: my-new-skill
   description: 一句话说明「什么场景下该用这个 skill」。写清楚触发条件，Agent 靠它判断是否加载。
   ---
   ```

   - `name` 用小写 + 连字符，与目录名一致
   - `description` 不超过 240 字符，必须包含**触发场景关键词**
   - 正文用祈使句写指令，不要写教程

4. **更新本 README** 的目录树与技能总览表（保持文档与仓库同步）。

5. **提交**：

   ```bash
   git add .
   git commit -m "feat(05-knowledge): add my-new-skill"
   git push
   ```

---

## 📝 提交规范

```
<type>(<分类>): <简短描述>

类型：
  feat      新增 skill
  fix       修正 skill 内容或错误
  docs      仅改文档
  refactor  调整分类或结构
  chore     杂项

示例：
  feat(02-engineering): add stm32-uart skill
  fix(04-code-quality): correct typo in systematic-debugging
  docs: update README tree
```

---

## ⚠️ 版权与来源说明

本仓库为**个人私有备份**，收录的 skill 来源分为两类：

**自建 skill**（本人编写）：

| Skill | 说明 |
|---|---|
| `io2code` | STM32 IO 表生成代码 |
| `six-step-learning-map` | 六步学习法 |
| `local-skill-router` | 本地 skill 路由 |
| `eda-pcb` / `eda-schematics` | EDA 相关 |

**第三方 skill**（版权归原作者，含各自 LICENSE）：

| Skill | 版权 / 许可 |
|---|---|
| `docx`、`pptx` | © 2025 Anthropic, PBC — All rights reserved（仅限 Anthropic 服务内使用） |
| `pdf`、`cli-creator` | Apache License 2.0 |
| `cad`、`dxf` | MIT License, Copyright (c) 2026 Thompson Labs LLC |
| `ponytail` 系列 | 来源于 [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) |
| 其余 dev-workflow / code-quality 系列 | 来源于 Superpowers 生态 |

> 各 skill 目录内的 `LICENSE` / `LICENSE.txt` 均已原样保留，请以目录内许可证为准。
> **本仓库为私有**，不作公开分发。若要公开或再分发第三方 skill，请先确认其许可条款。

---

## 🧾 本地来源与同步

本仓库内容导出自本地 `~/.cc-switch/skills/`（即 `~/.claude/skills/`）。

**换机器恢复**：直接 `git clone` 本仓库，再用上面的「方式三」脚本压平复制到目标机器的 skills 目录即可。

**日常同步**（本地 → 仓库）：

```powershell
# 从本地 skills 目录同步到仓库对应分类
$src = "$env:USERPROFILE\.cc-switch\skills"
$repo = ".\MySkills"
# ... 按分类复制后
git add . ; git commit -m "sync: update skills from local" ; git push
```

---

*最后更新：见 `git log`*
