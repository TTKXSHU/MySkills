# 01-eda — 电子设计自动化

> EDA（Electronic Design Automation）相关 MCP：原理图、PCB、电路分析

## 包含

| MCP | 说明 | 状态 |
|---|---|---|
| [kicad](kicad/) | KiCad 工程分析：网表、BOM、DRC、连接关系 | ⚠️ 需先装 KiCad 9.0+ |
| [easyeda](easyeda/) | 立创EDA / EasyEDA Pro | ✅ 使用中 |

## 选择建议

| 场景 | 用哪个 |
|---|---|
| 开源硬件、KiCad 工程 | `kicad` |
| 立创EDA 工程、要打 JLCPCB | `easyeda` |

两者可共存，按工程类型切换。

## 相关 skill

- `skills/02-engineering/eda-pcb/` — PCB 布局布线规则
- `skills/02-engineering/eda-schematics/` — 原理图绘制规范

> skill 提供**方法论**，MCP 提供**动手能力**。配合使用效果最好。
