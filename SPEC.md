# 📤 上传规范 (SPEC.md)

> **本文件定义：往本仓库添加 skill / mcp 时必须遵守的规范。**
> 加新内容前先读这里，避免结构不一致。

---

## 一、目录总则

仓库分**两个大类**，各自内部按用途细分类：

```
MySkills/
├── skills/                    ← 大类 1：Agent 技能
│   ├── 01-documents/          子类
│   ├── 02-engineering/
│   ├── 03-dev-workflow/
│   ├── 04-code-quality/
│   ├── 05-knowledge/
│   ├── 06-automation/
│   └── 07-system/
│
├── mcp/                       ← 大类 2：MCP 服务器
│   ├── 01-eda/                子类
│   ├── 02-embedded/
│   ├── 03-knowledge/
│   ├── 04-web/
│   ├── 05-devops/
│   ├── 06-config/
│   └── 07-docs/
│
├── SPEC.md                    ← 本文件（根级，两个大类共用）
├── README.md                  ← 仓库总览
├── INDEX.md                   ← 三张速查索引
├── install-skills.ps1         ← 批量安装（Windows）
└── install-skills.sh          ← 批量安装（macOS/Linux）
```

**命名规则**：
- 子类目录用 `NN-英文短名`，`NN` 两位数字（`01`~`99`），保证排序稳定
- **数字前缀不可省略** —— 安装脚本靠 `^\d{2}-` 匹配分类目录
- 英文小写 + 连字符，不用空格、不用中文

---

## 二、skills 上传规范

### 2.1 目录结构

```
skills/<子类>/<skill-name>/
├── SKILL.md          ← 必需
├── references/       ← 可选：参考文档
├── scripts/          ← 可选：辅助脚本
└── assets/           ← 可选：资源文件
```

`<skill-name>` 用小写 + 连字符，**必须与 `SKILL.md` 里的 `name` 一致**。

### 2.2 SKILL.md 格式

**必须**以 YAML front matter 开头：

```markdown
---
name: my-skill-name
description: 一句话说明「什么场景下该用」。必须包含触发关键词，Agent 靠它判断是否加载。
---

# 技能标题

正文用祈使句写指令，不写教程。
```

**字段约束**：

| 字段 | 必需 | 约束 |
|---|---|---|
| `name` | ✅ | 小写 + 连字符，与目录名一致 |
| `description` | ✅ | **≤ 240 字符**，必须含触发场景关键词 |
| `allowed-tools` | ❌ | 可选，限定可用工具 |
| `license` | ❌ | 第三方 skill 建议填 |

### 2.3 内容规范

| 规则 | 说明 |
|---|---|
| **description 写触发条件** | 不是"这个 skill 是什么"，而是"什么时候该用它" |
| **正文用祈使句** | 「先读 X」「不要做 Y」，不要「本文介绍了…」 |
| **单个 skill ≤ 128 KiB** | 超出请拆分为多个 skill |
| **不写教程** | 只写 Agent 该怎么行动 |
| **别乱触发** | 描述过于宽泛的 skill 会浪费每次会话的上下文 |

### 2.4 第三方 skill

⭐ **必须保留原 `LICENSE` 文件**，并在根的 `README.md` 版权表登记。

---

## 三、mcp 上传规范

### 3.1 目录结构

```
mcp/<子类>/<server-name>/
├── README.md         ← 必需：该 MCP 的完整说明
└── （可选）配置片段、脚本、补充文档
```

`<server-name>` 用小写 + 连字符，与配置里的 key 一致。

### 3.2 README.md 必须包含的八项

每个 MCP 的 README **必须**含以下内容：

| # | 小节 | 要求 |
|---|---|---|
| 1 | **属性表** | 用途 / 来源 / 许可证 / 类型 / 状态 |
| 2 | **配置片段** | 可直接复制的 JSON，**用占位符不用真实路径** |
| 3 | **前置条件** | 依赖的软件、版本要求 |
| 4 | **能力说明** | 能干什么，工具清单（有的话） |
| 5 | **安全提示** | 风险点、权限要求 |
| 6 | **验证状态** | 哪些验证过、哪些没验证 |
| 7 | **注意事项 / 风险** | 已知问题、废弃警告 |
| 8 | **相关链接** | 上游仓库 |

### 3.3 配置脱敏（**硬性要求**）

🔴 **提交配置前必须做脱敏**：

| 必须替换 | 替换为 |
|---|---|
| 绝对路径 `C:/Users/xxx` | `<YOUR_HOME>` |
| 盘符路径 `D:/...` | `<YOUR_DRIVE>:/...` |
| 项目真实路径 | `<PROJECT_PATH_N>` |
| 任何 API key / token | `${env:VAR_NAME}` |

**扫描命令**（提交前跑一遍）：

```powershell
Get-ChildItem . -Recurse -File |
  Where-Object { $_.FullName -notlike '*\.git\*' } |
  ForEach-Object {
    $c = Get-Content $_.FullName -Raw -ErrorAction SilentlyContinue
    if ($c -match '(?i)(sk-[A-Za-z0-9]{16,}|ghp_[A-Za-z0-9]{20,}|ANTHROPIC_AUTH_TOKEN\s*[:=]\s*"[^"]+")') {
      Write-Host "⚠️ 疑似泄露: $($_.FullName)"
    }
  }
```

### 3.4 配置语法规则

**Windows 上的 npx 必须用 `cmd /c` 包裹**：

```json
"command": "cmd",
"args": ["/c", "npx", "-y", "@scope/package"]
```

**Python 类用 `uvx`，不要包 `cmd /c`**：

```json
"command": "uvx",
"args": ["mcp-server-fetch"]
```

**固定版本，不用 `@latest`**（供应链安全）。

### 3.5 安全红线

| 规则 | 说明 |
|---|---|
| 🔴 **绝不提交 `~/.claude/settings.json`** | 含真实 `ANTHROPIC_AUTH_TOKEN` |
| 🔴 **不提交任何 token / 密码** | 一律用环境变量引用 |
| 🟡 **tool 类 MCP 标注风险等级** | 能写文件/执行命令的要写明 |
| 🟡 **第三方 MCP 标注是否审计** | 默认标"未审计" |

---

## 四、提交流程

### 4.1 步骤

```
1. 确定大类       skills/ 还是 mcp/
2. 确定子类       现有的 7 个之一；都不合适才新建 NN-xxx
3. 建目录         按上面的结构
4. 写必需文件     SKILL.md 或 README.md
5. 更新索引       README.md 目录树 + INDEX.md 索引表
6. 脱敏检查       mcp 配置必做
7. 提交
```

### 4.2 提交信息格式

```
<type>(<大类>/<子类>): <简短描述>

type:
  feat      新增
  fix       修正
  docs      仅改文档
  refactor  结构调整
  chore     杂项

示例:
  feat(skills/05-knowledge): add six-step-learning-map
  feat(mcp/01-eda): add kicad MCP server
  fix(mcp/05-devops): correct github token example
  refactor: split repo into skills/ and mcp/ categories
  docs: update README tree
```

### 4.3 命令

```powershell
git add .
git commit -m "feat(skills/05-knowledge): add my-skill"
git push
```

---

## 五、检查清单

提交前逐项确认：

### skills

- [ ] 目录名与 `SKILL.md` 的 `name` 一致
- [ ] front matter 有 `name` 和 `description`
- [ ] `description` ≤ 240 字符且含触发关键词
- [ ] 正文用祈使句，不是教程
- [ ] 第三方 skill 保留了 LICENSE

### mcp

- [ ] README 含 8 个小节
- [ ] 配置里**无真实路径、无 token**
- [ ] npx 用 `cmd /c` 包裹
- [ ] 标注了验证状态和风险
- [ ] 没有提交 `settings.json`

### 通用

- [ ] 子类目录名符合 `NN-xxx` 格式
- [ ] `README.md` 目录树已更新
- [ ] `INDEX.md` 索引表已更新
- [ ] 跑过脱敏扫描，无泄露
- [ ] commit message 符合格式

---

## 六、常见错误

| 错误 | 后果 | 正确做法 |
|---|---|---|
| 子类目录不带数字前缀 | 安装脚本识别不到 | `01-documents` 而非 `documents` |
| `SKILL.md` 缺 front matter | Claude 不加载该 skill | 加上 `name` + `description` |
| `description` 写成介绍 | 触发不准 | 写"什么时候用" |
| MCP 配置里写真实路径 | 换机器失效 + 泄露信息 | 用 `<YOUR_HOME>` 占位符 |
| token 写死在 JSON | **泄露** | `${env:VAR}` 引用 |
| 提交了 `settings.json` | **泄露 API 密钥** | `.gitignore` 已排除，别强加 |
| npx 没包 `cmd /c` | Windows 上启动失败 | 用 `cmd /c npx ...` |
| 忘了更新索引 | 文档与实际不符 | 同步改 README + INDEX |

---

## 七、新增子类怎么办

现有子类都不合适时：

1. 挑一个**未占用的编号**（如 `skills/08-xxx/` 或 `mcp/08-xxx/`）
2. 建目录 + 写一个 `README.md` 说明该子类的范围
3. 更新根 `README.md` 的目录树与统计
4. 更新 `INDEX.md`
5. 用 `refactor` 类型提交

**判断标准**：如果新内容能合理放进现有子类，就**不要**新建 —— 子类过多反而难找。

---

*本规范随仓库演进，修改请用 `docs:` 类型提交。*
