# github

> GitHub 仓库操作

| 属性 | 值 |
|---|---|
| **用途** | 仓库管理、文件操作、Issue/PR |
| **包名** | `@modelcontextprotocol/server-github` |
| **类型** | stdio（本地） |
| **状态** | ⚠️ **官方已归档，建议迁移** |

---

## ⚠️ 该包已被官方归档

`@modelcontextprotocol/server-github` 已移入
[servers-archived](https://github.com/modelcontextprotocol/servers-archived)。

**推荐替代**：[github/github-mcp-server](https://github.com/github/github-mcp-server)（GitHub 官方维护）

迁移方式：

```json
"github": {
  "type": "stdio",
  "command": "docker",
  "args": ["run", "-i", "--rm", "-e", "GITHUB_PERSONAL_ACCESS_TOKEN", "ghcr.io/github/github-mcp-server"],
  "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "${env:GITHUB_TOKEN}" }
}
```

---

## 当前配置

```json
"github": {
  "command": "cmd",
  "args": ["/c", "npx", "-y", "@modelcontextprotocol/server-github"]
}
```

---

## 需要 Token

GitHub MCP 需要 **Personal Access Token (PAT)**。

### 🔴 绝对不要写死 token

**错误**（会被提交到 git）：
```json
"env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_xxxxxxxxxxxx" }
```

**正确**（引用环境变量）：
```json
"env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "${env:GITHUB_TOKEN}" }
```

然后在系统里设环境变量：

```powershell
[Environment]::SetEnvironmentVariable('GITHUB_TOKEN', 'ghp_xxx', 'User')
```

### Token 权限最小化

只勾选需要的 scope：
- `repo` — 仓库读写
- `read:org` — 读组织信息（如需）
- 不要勾 `delete_repo` 等危险权限

---

## 本仓库用途

本仓库 [MySkills](https://github.com/TTKXSHU/MySkills) 就是靠它管理的。
