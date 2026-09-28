# kicad

> KiCad EDA 集成 —— 让 AI 直接分析/操作 KiCad 工程

| 属性 | 值 |
|---|---|
| **用途** | 原理图与 PCB 分析、网表提取、BOM 导出、DRC 检查 |
| **来源** | [lamaalrajih/kicad-mcp](https://github.com/lamaalrajih/kicad-mcp) |
| **许可证** | MIT |
| **类型** | stdio（本地） |
| **平台** | Windows / macOS / Linux |
| **工具数** | 16 |

---

## ⚠️ 前置条件

**必须先装 KiCad 9.0+**。本 MCP 是"KiCad 的遥控器"，调用 KiCad CLI/API 读写工程文件，
没有 KiCad 本体则工具可列出但调用会失败。

| 依赖 | 要求 |
|---|---|
| KiCad | **9.0+** |
| Python | 3.10+ |
| uv | 0.8+ |

下载：https://www.kicad.org/download/windows/

装完 KiCad 后，把 `C:\Program Files\KiCad\9.0\bin` 加入 PATH（使 `kicad-cli` 可用）。

---

## 安装

```powershell
mkdir D:\Tools\mcp; cd D:\Tools\mcp
git clone --depth 1 https://github.com/lamaalrajih/kicad-mcp.git
cd kicad-mcp
uv sync
```

---

## 配置

```json
"kicad": {
  "type": "stdio",
  "command": "<DRIVE>:/Tools/mcp/kicad-mcp/.venv/Scripts/python.exe",
  "args": ["<DRIVE>:/Tools/mcp/kicad-mcp/main.py"],
  "env": {}
}
```

可选：在 `kicad-mcp/.env` 指定工程搜索路径：

```
KICAD_SEARCH_PATHS=D:/PCB,D:/Electronics
```

---

## 工具清单（16 个）

| 工具 | 作用 |
|---|---|
| `list_projects` | 列出所有 KiCad 工程 |
| `get_project_structure` | 查看工程结构 |
| `open_project` | 打开工程（启动 KiCad） |
| `validate_project` | 校验工程完整性 |
| `generate_pcb_thumbnail` | 生成 PCB 预览图 |
| `generate_project_thumbnail` | 生成工程预览图 |
| `run_drc_check` | 运行设计规则检查（DRC） |
| `get_drc_history_tool` | 查看 DRC 历史 |
| `analyze_bom` | 分析物料清单 |
| `export_bom_csv` | 导出 BOM 为 CSV |
| `extract_schematic_netlist` | 从原理图提取网表 |
| `extract_project_netlist` | 从工程提取网表 |
| `analyze_schematic_connections` | 分析原理图连接关系 |
| `find_component_connections` | 查找元件连接 |
| `identify_circuit_patterns` | 识别电路拓扑模式 |
| +1 | （见 `tools/list`） |

---

## 已验证

| 检查 | 结果 |
|---|---|
| 服务器启动 | ✅ `serverInfo {name: "KiCad", version: "1.11.0"}` |
| MCP 握手 | ✅ `protocolVersion 2024-11-05` |
| 能力 | ✅ tools / resources / prompts / experimental |
| 工具列表 | ✅ 16 个 |

**未验证**：工具的实际调用（需先装 KiCad）。

---

## 相关

- 备选方案：[mixelpixx/KiCAD-MCP-Server](https://github.com/mixelpixx/KiCAD-MCP-Server)（2.5k★，功能更全，需 npm build）
- 对比与调研见 [../../07-docs/RECOMMENDED.md](../../07-docs/RECOMMENDED.md)
