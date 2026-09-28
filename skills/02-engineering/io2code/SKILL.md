---
name: io2code
description: Use when user asks to generate STM32 code from IO table configuration files
---

# IO表转代码

根据IO表配置、串口协议和编码规范，生成STM32应用层代码。

## 执行流程

### 第一步：读取规范文件
- 必须先读取 `IO表/CodingRyles.md` 文件
- 所有生成的代码必须严格遵循该文件中的编码规范

### 第二步：读取IO表配置
- 读取IO表目录下的所有yaml/md配置文件
- 解析GPIO、ADC、UART、SPI等外设配置
- 解析串口协议格式（Usart.yaml）

### 第三步：生成代码
按照CodingRyles.md中的规范生成代码：
- 串口输出：使用`Usart1Printf`
- 串口接收：使用`Usart1Flag`/`Usart1Buffer`/`Usart1Count`标志位模式
- 命令处理：switch(cmd)模式，业务命令设标志位，主循环中执行
- GPIO输入：使用KeyCreate/KeyEvenrLoop
- 结构体：一个外设一个结构体
- 标志位：`g_前缀+Flag`

### 第四步：代码放置
- 应用层代码放在 `APP/Inc` 和 `APP/Src` 目录下
- 在CubeMX的USER CODE区域添加代码
- 不修改CubeMX生成的外设配置

## 关键规范
- 中断中只设标志位，大循环中处理
- BootLoad命令可直接执行，其他命令只设标志位
- 看门狗未初始化时禁止调用喂狗函数
- 日志用LOG_INFO/LOG_ERR宏
