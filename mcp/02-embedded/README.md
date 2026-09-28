# 02-embedded — 嵌入式开发

> STM32 相关 MCP：数据查询 + 实时调试

## 包含

| MCP | 说明 | 来源 |
|---|---|---|
| [stm32-tools](stm32-tools/) | **自制**：编译/烧录/串口/寄存器/变量监视闭环 | 本仓库 |
| [stm32-data](stm32-data/) | STM32 寄存器与外设定义查询 | 外部 |

## 两者配合

```
stm32-data           stm32-tools
（静态知识）    +    （动态操作）
     ↓                    ↓
  查寄存器定义      读实时寄存器值
```

**典型闭环**：`stm32-data` 查出寄存器地址 → `stm32-tools` 编译烧录 → 串口监控 → 读回寄存器验证

## stm32-tools 功能一览

| 入口 | 作用 |
|---|---|
| `mcp-server.js` | MCP server 主程序 |
| `closed-loop.js` | 一键闭环：编译→烧录→串口验证 |
| `build.bat` / `flash.bat` | 单独编译 / 烧录 |
| `serial_monitor.bat` | 串口实时监控 |
| `reg_read.bat` | 寄存器读取与解读 |
| `watch_var.bat` | 变量监视 |
| `mem_monitor.bat` / `stack_analyze.bat` | 内存 / 栈分析 |
| `tools.bat` | 工具总入口 |

详见 [stm32-tools/README.md](stm32-tools/README.md)

## 相关 skill

- `skills/02-engineering/io2code/` — 从 IO 表生成 STM32 代码
