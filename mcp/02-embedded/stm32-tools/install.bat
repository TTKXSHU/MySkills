@echo off
REM ============================================================
REM STM32 Debug Tools - Configuration & Installation
REM Run this script to configure tools for your project
REM ============================================================

setlocal enabledelayedexpansion

set "TOOLS_DIR=%~dp0"
set "CONFIG_FILE=%TOOLS_DIR%config.bat"

echo.
echo ============================================================
echo       STM32 Debug Tools - Installation & Configuration
echo ============================================================
echo.
echo  Tools Directory: %TOOLS_DIR%
echo.

REM 创建默认配置文件
if not exist "%CONFIG_FILE%" (
    echo Creating default configuration...
    call :create_config
)

REM 检查Keil路径
echo [1/5] Checking Keil MDK...
where uv4.exe >nul 2>&1
if %ERRORLEVEL% equ 0 (
    for /f "tokens=*" %%i in ('where uv4.exe') do set "KEIL_PATH=%%i"
    echo   [OK] Found: !KEIL_PATH!
) else (
    if exist "C:\Keil_v5\UV4\UV4.exe" (
        set "KEIL_PATH=C:\Keil_v5\UV4\UV4.exe"
        echo   [OK] Found: C:\Keil_v5\UV4\UV4.exe
    ) else (
        echo   [WARNING] Keil not found in PATH
        echo   Please set KEIL_PATH in config.bat
    )
)

REM 检查ST-Link路径
echo [2/5] Checking STM32CubeProgrammer...
where STM32_Programmer_CLI.exe >nul 2>&1
if %ERRORLEVEL% equ 0 (
    for /f "tokens=*" %%i in ('where STM32_Programmer_CLI.exe') do set "STLINK_PATH=%%i"
    echo   [OK] Found: !STLINK_PATH!
) else (
    if exist "C:\STMicroelectronics\STM32Cube\STM32CubeProgrammer\bin\STM32_Programmer_CLI.exe" (
        set "STLINK_PATH=C:\STMicroelectronics\STM32Cube\STM32CubeProgrammer\bin\STM32_Programmer_CLI.exe"
        echo   [OK] Found: C:\STMicroelectronics\STM32Cube\STM32CubeProgrammer\bin\STM32_Programmer_CLI.exe
    ) else (
        echo   [WARNING] STM32CubeProgrammer not found
        echo   Please set STLINK_PATH in config.bat
    )
)

REM 检查串口工具
echo [3/5] Checking serial tools...
where powershell.exe >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo   [OK] PowerShell available for serial monitoring
) else (
    echo   [WARNING] PowerShell not found
)

REM 创建快捷方式脚本
echo [4/5] Creating launcher scripts...
call :create_launchers

REM 创建环境变量设置
echo [5/5] Creating environment setup...
call :create_env_setup

echo.
echo ============================================================
echo  Installation Complete!
echo.
echo  To use tools in any project:
echo.
echo    1. Copy stm32_debug_tools folder to your project
echo    2. Run: stm32_debug_tools\install.bat
echo    3. Or add to PATH: set PATH=%TOOLS_DIR%;%PATH%
echo.
echo  Quick commands:
echo    stm32-tools           - Show main menu
echo    stm32-build           - Build current project
echo    stm32-flash           - Flash firmware
echo    stm32-serial          - Serial monitor
echo.
echo ============================================================
echo.

pause
exit /b 0

:create_config
(
echo @echo off
echo REM ============================================================
echo REM STM32 Debug Tools - Configuration
echo REM Modify these paths according to your installation
echo ============================================================
echo.
echo REM Keil MDK Path
echo set "KEIL_PATH=C:\Keil_v5\UV4\UV4.exe"
echo.
echo REM STM32CubeProgrammer Path
echo set "STLINK_PATH=C:\STMicroelectronics\STM32Cube\STM32CubeProgrammer\bin\STM32_Programmer_CLI.exe"
echo.
echo REM Default Serial Port
echo set "DEFAULT_SERIAL_PORT=COM11"
echo set "DEFAULT_SERIAL_BAUD=115200"
echo.
echo REM Project Auto-Detection (yes/no)
echo set "AUTO_DETECT_PROJECT=yes"
echo.
echo REM Log Directory
echo set "LOG_DIR=%TOOLS_DIR%logs"
) > "%CONFIG_FILE%"
echo   [OK] Config created: %CONFIG_FILE%
goto :eof

:create_launchers
REM 创建主启动器
(
echo @echo off
echo set "TOOLS_DIR=%~dp0"
echo call "%TOOLS_DIR%tools.bat" %%*
) > "%TOOLS_DIR%stm32-tools.bat"

REM 创建独立命令启动器
(
echo @echo off
echo call "%TOOLS_DIR%build.bat" %%*
) > "%TOOLS_DIR%stm32-build.bat"

(
echo @echo off
echo call "%TOOLS_DIR%flash.bat" %%*
) > "%TOOLS_DIR%stm32-flash.bat"

(
echo @echo off
echo call "%TOOLS_DIR%serial_monitor.bat" %%*
) > "%TOOLS_DIR%stm32-serial.bat"

echo   [OK] Launchers created
goto :eof

:create_env_setup
(
echo @echo off
echo REM Add STM32 Debug Tools to PATH
echo set "PATH=%TOOLS_DIR%;%PATH%"
echo echo STM32 Debug Tools added to PATH
echo echo Use 'stm32-tools' to start
) > "%TOOLS_DIR%add_to_path.bat"
echo   [OK] Environment setup created
goto :eof
