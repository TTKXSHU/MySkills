@echo off
REM ============================================================
REM STM32 Debug Tools - Universal Main Menu
REM Usage: tools.bat [command]
REM ============================================================

setlocal enabledelayedexpansion

set "TOOLS_DIR=%~dp0"

REM 加载配置
call "%TOOLS_DIR%config.bat"

REM 如果有参数直接执行
if not "%~1"=="" goto :%~1 2>nul || goto :unknown

:menu
cls
echo.
echo ============================================================
echo.
echo       ████████╗ ██████╗  ██████╗ ██╗     ███████╗
echo       ╚══██╔══╝██╔═══██╗██╔═══██╗██║     ██╔════╝
echo          ██║   ██║   ██║██║   ██║██║     ███████╗
echo          ██║   ██║   ██║██║   ██║██║     ╚════██║
echo          ██║   ╚██████╔╝╚██████╔╝███████╗███████║
echo          ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝╚══════╝
echo.
echo       STM32 Debug Tools - Universal Edition v1.0
echo.
echo ============================================================
echo.
echo   Current Directory: %CD%
echo.
echo   ╔═══════════════════════════════════════════════════════╗
echo   ║  编译烧录 (Build & Flash)                            ║
echo   ╠═══════════════════════════════════════════════════════╣
echo   ║  [1] Build         增量编译当前项目                    ║
echo   ║  [2] Build All     重新编译当前项目                    ║
echo   ║  [3] Flash         烧录固件                           ║
echo   ║  [4] Debug         一键调试闭环                        ║
echo   ╚═══════════════════════════════════════════════════════╝
echo.
echo   ╔═══════════════════════════════════════════════════════╗
echo   ║  实时监控 (Real-time Monitor)                         ║
echo   ╠═══════════════════════════════════════════════════════╣
echo   ║  [5] Serial        串口监视器                          ║
echo   ║  [6] Memory        实时内存监视                        ║
echo   ║  [7] Watch Var     变量地址查看                        ║
echo   ╚═══════════════════════════════════════════════════════╝
echo.
echo   ╔═══════════════════════════════════════════════════════╗
echo   ║  寄存器 (Registers)                                   ║
echo   ╠═══════════════════════════════════════════════════════╣
echo   ║  [R] Registers     寄存器查看器                        ║
echo   ╚═══════════════════════════════════════════════════════╝
echo.
echo   ╔═══════════════════════════════════════════════════════╗
echo   ║  [I] Install       安装/配置工具                       ║
echo   ║  [H] Help          帮助信息                            ║
echo   ║  [Q] Quit          退出                                ║
echo   ╚═══════════════════════════════════════════════════════╝
echo.
echo ============================================================
echo.

choice /c 1234567RIHQ /n /m "请选择: "

if %ERRORLEVEL% equ 1 goto :build
if %ERRORLEVEL% equ 2 goto :build_all
if %ERRORLEVEL% equ 3 goto :flash
if %ERRORLEVEL% equ 4 goto :debug
if %ERRORLEVEL% equ 5 goto :serial
if %ERRORLEVEL% equ 6 goto :memory
if %ERRORLEVEL% equ 7 goto :watch
if %ERRORLEVEL% equ 8 goto :registers
if %ERRORLEVEL% equ 9 goto :install
if %ERRORLEVEL% equ 10 goto :help
if %ERRORLEVEL% equ 11 goto :eof

goto :menu

:build
echo.
call "%TOOLS_DIR%build.bat" "%CD%"
echo.
pause
goto :menu

:build_all
echo.
call "%TOOLS_DIR%build.bat" "%CD%" rebuild
echo.
pause
goto :menu

:flash
echo.
call "%TOOLS_DIR%flash.bat"
echo.
pause
goto :menu

:debug
echo.
set /p "COM_PORT=串口号 (默认%DEFAULT_SERIAL_PORT%): "
set /p "BAUD_RATE=波特率 (默认%DEFAULT_SERIAL_BAUD%): "
if "%COM_PORT%"=="" set "COM_PORT=%DEFAULT_SERIAL_PORT%"
if "%BAUD_RATE%"=="" set "BAUD_RATE=%DEFAULT_SERIAL_BAUD%"
call "%TOOLS_DIR%debug_cycle.bat" "%CD%" %COM_PORT% %BAUD_RATE%
echo.
pause
goto :menu

:serial
echo.
set /p "COM_PORT=串口号 (默认%DEFAULT_SERIAL_PORT%): "
set /p "BAUD_RATE=波特率 (默认%DEFAULT_SERIAL_BAUD%): "
if "%COM_PORT%"=="" set "COM_PORT=%DEFAULT_SERIAL_PORT%"
if "%BAUD_RATE%"=="" set "BAUD_RATE=%DEFAULT_SERIAL_BAUD%"
call "%TOOLS_DIR%serial_monitor.bat" %COM_PORT% %BAUD_RATE%
pause
goto :menu

:memory
echo.
set /p "MEM_ADDR=内存地址 (默认0x20000000): "
set /p "MEM_SIZE=读取大小 (默认64字节): "
set /p "MEM_REFRESH=刷新间隔秒数 (默认2): "
if "%MEM_ADDR%"=="" set "MEM_ADDR=0x20000000"
if "%MEM_SIZE%"=="" set "MEM_SIZE=64"
if "%MEM_REFRESH%"=="" set "MEM_REFRESH=2"
call "%TOOLS_DIR%mem_monitor.bat" %MEM_ADDR% %MEM_SIZE% %MEM_REFRESH%
pause
goto :menu

:watch
echo.
set /p "VAR_NAME=变量名称: "
if "%VAR_NAME%"=="" (
    call "%TOOLS_DIR%watch_var.bat"
) else (
    call "%TOOLS_DIR%watch_var.bat" %VAR_NAME%
)
echo.
pause
goto :menu

:registers
echo.
call "%TOOLS_DIR%reg_read.bat"
pause
goto :menu

:install
echo.
call "%TOOLS_DIR%install.bat"
pause
goto :menu

:help
cls
echo.
echo ============================================================
echo  STM32 Debug Tools - Help
echo ============================================================
echo.
echo  命令行用法:
echo.
echo    tools.bat build          - 编译当前项目
echo    tools.bat build_all      - 重新编译
echo    tools.bat flash          - 烧录固件
echo    tools.bat debug          - 一键调试
echo    tools.bat serial         - 串口监视
echo    tools.bat memory         - 内存监视
echo    tools.bat watch VAR      - 变量查看
echo    tools.bat registers      - 寄存器查看
echo    tools.bat install        - 安装配置
echo.
echo  独立命令 (添加到PATH后):
echo.
echo    stm32-tools             - 主菜单
echo    stm32-build             - 编译
echo    stm32-flash             - 烧录
echo    stm32-serial            - 串口监视
echo.
echo  配置文件:
echo.
echo    config.bat              - 工具配置
echo      KEIL_PATH             - Keil安装路径
echo      STLINK_PATH           - ST-Link路径
echo      DEFAULT_SERIAL_PORT   - 默认串口号
echo      DEFAULT_SERIAL_BAUD   - 默认波特率
echo.
echo  使用步骤:
echo.
echo    1. 运行 install.bat 配置工具
echo    2. 进入STM32项目目录
echo    3. 运行 tools.bat 启动菜单
echo    4. 或使用 stm32-xxx 快捷命令
echo.
echo ============================================================
echo.
pause
goto :menu

:unknown
echo [ERROR] Unknown command: %~1
echo Run 'tools.bat' to see menu
exit /b 1

:eof
exit /b 0
