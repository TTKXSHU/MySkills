# stm32-data

> STM32 寄存器与数据手册查询

| 属性 | 值 |
|---|---|
| **用途** | 查询 STM32 寄存器定义、外设信息 |
| **可执行文件** | `stm32-data-mcp` |
| **类型** | stdio（本地） |
| **状态** | 已安装使用中 |

---

## 配置

```json
"stm32-data": {
  "type": "stdio",
  "command": "stm32-data-mcp",
  "args": [],
  "env": {
    "STM32_DATA_DIR": "<DRIVE>:/stm32-data-generated"
  }
}
```

### `STM32_DATA_DIR`

指向**生成好的 STM32 数据目录**。该目录需自行准备（通常由 `stm32-data` 项目生成）。

---

## 安装前置

`stm32-data-mcp` 必须在 PATH 中。若未安装，见 [stm32-data 项目](https://github.com/stm32-rs/stm32-data)。

验证：

```powershell
Get-Command stm32-data-mcp
```

---

## 配套

与同目录的 [stm32-tools](../stm32-tools/) 配合：
- **stm32-data** → 查寄存器/外设定义（静态知识）
- **stm32-tools** → 编译/烧录/串口/实时读寄存器（动态操作）
