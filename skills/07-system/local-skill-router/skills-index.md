# 本地 Skills 目录表

更新时间：2026-07-06

使用方式：每次用户发消息时，先快速读取本文件，按“适用场景”选择最匹配的 skill。新增、删除、重命名或修改 skill 后，必须更新本表。

| Skill | 触发方式 | 适用场景 | 注意事项 |
|---|---|---|---|
| local-skill-router | 自动优先查看 | 每次开始处理用户请求、选择本地 skill、安装或更新 skill 后维护索引 | 先读本表，避免全量扫描 skills 目录 |
| iocode | /io2code | 根据 IO表/IoTable.yaml、Usart.yaml、CodingRyles.md 生成 STM32 项目代码 | STM32 IO 表改代码时优先用它 |
| io2code-flash | /io2code-flash | 根据 IO 表生成 STM32 代码，并自动编译、下载、串口验证 | 涉及烧录下载有硬件风险，执行前确认目标板和固件路径 |
| systematic-debugging | Skill | bug、编译失败、异常现象、硬件或软件行为不符合预期 | 修复前先找根因 |
| verification-before-completion | Skill | 准备声称完成、修好、通过、可提交前 | 必须有新鲜验证命令输出 |
| brainstorming | Skill | 新功能、行为变更、组件设计、方案设计、需求不清 | 设计获批前不要写代码 |
| writing-plans | Skill | 已有需求或设计，需要写多步骤实现计划 | 写计划，不直接实现 |
| executing-plans | Skill | 已有实现计划，需要在会话中按计划执行 | 适合有书面计划的任务 |
| subagent-driven-development | Skill | 有实现计划，且任务可拆给子 agent 执行 | 每个任务子 agent 实现+审查 |
| dispatching-parallel-agents | Skill | 2 个以上互不依赖的问题、文件、子任务 | 并行调研或修复，减少主上下文消耗 |
| requesting-code-review | Skill | 完成重要代码变更后需要审查 diff | 合并或交付前使用 |
| receiving-code-review | Skill | 收到代码审查意见，需要判断和落实 | 不盲从，先验证意见是否成立 |
| test-driven-development | Skill | 实现新功能、bugfix、行为变更前 | 先写失败测试；嵌入式项目无测试框架时可用最小可验证脚本或编译/硬件验证替代 |
| using-git-worktrees | Skill | 开始较大开发、需要隔离工作区 | 当前环境已有 EnterWorktree 工具时优先用工具 |
| finishing-a-development-branch | Skill | 功能完成且验证通过后，决定合并、PR、保留或丢弃 | 不要在测试失败时进入收尾 |
| writing-skills | Skill | 创建、修改、验证 skill | 新建 skill 后更新本表 |
| find-skills | Skill | 用户想查找、安装、发现更多 skill | 用于 skills.sh 生态查找 |
| docx | Skill | 读取、创建、编辑 .docx 文件 | Anthropic 官方出品，145K+ 安装量 |
| docx-manipulation | Skill | 操作、转换、处理 .docx 文件 | claude-office-skills 出品，4K+ 安装量 |
| cli-creator | Skill | 从 API、OpenAPI、SDK、curl、脚本创建可复用 CLI | 需要持久 CLI 时用，不是一次性脚本 |
| pdf | Skill | 读取、生成、审查 PDF，尤其关注版式 | 需要渲染检查 PDF 页面 |
| pptx | Skill | 读取、创建、编辑、合并 .pptx 文件 | 只要涉及 .pptx 就用 |
| ppt-visual | Skill | 设计 PPT 页面视觉、布局、配色、图形方案 | 只输出设计方案，不直接生成 PPTX |
| googlesuper-automation | Skill | 通过 Rube MCP 自动化 Google Super | 需 Rube MCP 可用，先搜索工具 schema |
| superchat-automation | Skill | 通过 Rube MCP 自动化 Superchat | 需 Rube MCP 可用，先搜索工具 schema |
| six-step-learning-map | Skill | 用户想系统学习某个新主题（SPWM、FOC、电力电子、某门语言、某算法、某协议等），需要知识地图、前置知识、学习路线、阶段产出、最小可跑代码、工程坑或练习题 | 六步法：①知识地图②费曼理解③最小可跑代码④自测纠偏⑤工程坑⑥刷题巩固；默认只走①，明确说「六步全要」才一次全给 |
| using-superpowers | Skill | Superpowers 总入口规则，要求先判断 skill | 已被 local-skill-router 本地化为轻量索引入口 |

## 快速匹配规则

- 用户说“根据 IO 表改代码 / 生成 STM32 代码”：用 `iocode`。
- 用户说“生成后编译下载验证 / 烧录 / 串口验证”：用 `io2code-flash`，并先确认硬件风险。
- 用户说“报错 / 不工作 / 编译失败 / 现象异常”：用 `systematic-debugging`。
- 用户说“帮我审查代码”：用 `requesting-code-review` 或 embedded-expert agent；嵌入式代码优先 embedded-expert。
- 用户说“收到 review，帮我改”：用 `receiving-code-review`。
- 用户说“做一个 skill / 修改 skill”：用 `writing-skills`，完成后更新本文件。
- 用户说“找一个 skill / 有没有 skill”：用 `find-skills`。
- 用户说“做 PPT / pptx / slides / presentation”：用 `pptx`；如果只是视觉方案，用 `ppt-visual`。
- 用户说“PDF”：用 `pdf`。
- 用户说“docx / Word 文档”：用 `docx` 或 `docx-manipulation`。
- 用户说“怎么学 X / X 的学习路线 / X 的知识地图 / 带我从零学 X”：用 `six-step-learning-map`；要完整走六步就明确说“六步全要”。
- 任务包含多个互不依赖子任务：用 `dispatching-parallel-agents`。
- 准备说“完成 / 修好了 / 通过了”：用 `verification-before-completion`。
