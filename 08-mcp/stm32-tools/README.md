# STM32 Debug Tools - Universal Edition

通用STM32调试工具套件，可在任何STM32项目中使用。

## 安装

### 方法1: 复制到项目
```bash
# 复制整个stm32_debug_tools文件夹到你的项目
xcopy /E /I stm32_debug_tools your_project\stm32_debug_tools

# 进入项目目录运行安装
cd your_project
stm32_debug_tools\install.bat
```

### 方法2: 添加到PATH (推荐)
```bash
# 运行环境设置
stm32_debug_tools\add_to_path.bat

# 或手动添加: 将stm32_debug_tools目录添加到系统PATH
```

### 方法3: 全局安装
```bash
# 将stm32_debug_tools复制到固定位置
xcopy /E /I stm32_debug_tools C:\tools\stm32_debug_tools

# 添加到PATH
set PATH=C:\tools\stm32_debug_tools;%PATH%
```

## 配置

编辑 `config.bat` 修改以下配置:

```batch
REM Keil MDK路径
set "KEIL_PATH=C:\Keil_v5\UV4\UV4.exe"

REM STM32CubeProgrammer路径
set "STLINK_PATH=C:\STMicroelectronics\STM32Cube\STM32CubeProgrammer\bin\STM32_Programmer_CLI.exe"

REM 默认串口配置
set "DEFAULT_SERIAL_PORT=COM11"
set "DEFAULT_SERIAL_BAUD=115200"
```

## 使用方法

### 方式1: 主菜单 (推荐)
```bash
# 进入STM32项目目录
cd C:\path\to\your\stm32\project

# 启动工具菜单
tools.bat
```

### 方式2: 命令行直接调用
```bash
# 编译当前项目
tools.bat build

# 烧录固件
tools.bat flash

# 一键调试
tools.bat debug

# 串口监视
tools.bat serial

# 查看变量
tools.bat watch AppMotionState

# 寄存器查看
tools.bat registers
```

### 方式3: 快捷命令 (需要添加PATH)
```bash
# 在任意目录使用
stm32-tools           # 主菜单
stm32-build           # 编译
stm32-flash           # 烧录
stm32-serial          # 串口监视
```

## 工具列表

| 脚本 | 功能 | 用法 |
|------|------|------|
| `tools.bat` | 主菜单入口 | `tools.bat` |
| `build.bat` | 编译项目 | `build.bat [project_path] [rebuild]` |
| `flash.bat` | 烧录固件 | `flash.bat [firmware.hex]` |
| `debug_cycle.bat` | 一键调试 | `debug_cycle.bat [project] [COM] [baud]` |
| `serial_monitor.bat` | 串口监视 | `serial_monitor.bat [COM] [baud]` |
| `reg_read.bat` | 寄存器查看 | `reg_read.bat [TIM3\|GPIOA\|0x...]` |
| `mem_monitor.bat` | 内存监视 | `mem_monitor.bat [addr] [size] [refresh]` |
| `watch_var.bat` | 变量查看 | `watch_var.bat [var_name]` |
| `code_check.bat` | 代码检查 | `code_check.bat [file\|dir]` |
| `stack_analyze.bat` | 堆栈分析 | `stack_analyze.bat [map_file]` |
| `install.bat` | 安装配置 | `install.bat` |
| `config.bat` | 配置文件 | 编辑修改配置 |

## 典型工作流

### 日常开发
```bash
# 1. 编辑代码 (使用VS Code, Keil等)
# 2. 编译检查
tools.bat build

# 3. 烧录测试
tools.bat flash

# 4. 串口调试
tools.bat serial
```

### 完整调试闭环
```bash
# 一键执行: 编译 + 烧录 + 串口监视
tools.bat debug
```

### 寄存器级调试
```bash
# 查看TIM3配置
tools.bat registers
# 选择 TIM3

# 查看GPIO状态
tools.bat registers
# 选择 GPIOA

# 实时内存监视
tools.bat memory
# 输入地址: 0x20000000
```

### 问题排查
```bash
# 代码静态检查
tools.bat check

# 堆栈分析
tools.bat stack

# 变量地址查找
tools.bat watch MyVariable
```

## 目录结构

```
stm32_debug_tools/
├── install.bat          # 安装脚本
├── config.bat           # 配置文件
├── tools.bat            # 主菜单
├── build.bat            # 编译脚本
├── flash.bat            # 烧录脚本
├── debug_cycle.bat      # 一键调试
├── serial_monitor.bat   # 串口监视
├── reg_read.bat         # 寄存器查看
├── mem_monitor.bat      # 内存监视
├── watch_var.bat        # 变量查看
├── code_check.bat       # 代码检查
├── stack_analyze.bat    # 堆栈分析
├── add_to_path.bat      # PATH环境变量
├── stm32-tools.bat      # 快捷启动器
├── stm32-build.bat      # 快捷编译
├── stm32-flash.bat      # 快捷烧录
├── stm32-serial.bat     # 快捷串口
└── logs/                # 日志目录
```

## 故障排除

### 编译失败
- 检查Keil路径配置
- 确认项目目录有.uvprojx文件
- 查看日志文件

### 烧录失败
- 检查ST-Link连接
- 确认目标板供电
- 检查SWD接线

### 串口无数据
- 确认串口号
- 检查波特率设置
- 确认串口未被占用

### 寄存器读取失败
- 确认ST-Link连接
- 检查芯片是否处于睡眠
- 尝试复位后重新连接

## 扩展

### 添加自定义工具
在stm32_debug_tools目录创建新脚本，使用config.bat中的变量:

```batch
@echo off
call "%~dp0config.bat"

REM 使用 %STLINK_PATH% 访问ST-Link
REM 使用 %KEIL_PATH% 访问Keil
REM 使用 %LOG_DIR% 存储日志
```

### 集成到项目
在项目根目录创建快捷方式:

```batch
@echo off
REM my_project\debug.bat
call "%~dp0stm32_debug_tools\tools.bat" %*
```

## 版本历史

- v1.0 (2026-07-17): 初始版本
  - 基础编译、烧录、串口监视
  - 寄存器查看、内存监视
  - 代码检查、堆栈分析

## 许可

MIT License - 自由使用和修改
