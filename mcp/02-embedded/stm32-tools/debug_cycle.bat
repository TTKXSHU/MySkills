@echo off
REM ============================================================
REM STM32 Debug Tools - One-Click Debug Cycle
REM Usage: debug_cycle.bat [project_path] [COM_PORT] [BAUD_RATE]
REM ============================================================

setlocal enabledelayedexpansion

REM 加载配置
call "%~dp0config.bat"

REM 参数
set "PROJECT_PATH=%~1"
set "COM_PORT=%~2"
set "BAUD_RATE=%~3"

if "%COM_PORT%"=="" set "COM_PORT=%DEFAULT_SERIAL_PORT%"
if "%BAUD_RATE%"=="" set "BAUD_RATE=%DEFAULT_SERIAL_BAUD%"

echo.
echo ============================================================
echo  STM32 One-Click Debug Cycle
echo ============================================================
echo.
echo  Configuration:
echo    Project: %PROJECT_PATH% (auto-detect if empty)
echo    Serial:  %COM_PORT% @ %BAUD_RATE% bps
echo.
echo ============================================================

REM 步骤1: 编译
echo.
echo [STEP 1/3] Building project...
echo ------------------------------------------------------------
call "%~dp0build.bat" "%PROJECT_PATH%"
if %ERRORLEVEL% neq 0 (
    echo.
    echo [FAILED] Build failed!
    exit /b 1
)
echo [SUCCESS] Build completed.

REM 步骤2: 烧录
echo.
echo [STEP 2/3] Flashing firmware...
echo ------------------------------------------------------------
call "%~dp0flash.bat"
if %ERRORLEVEL% neq 0 (
    echo.
    echo [FAILED] Flash failed!
    exit /b 1
)
echo [SUCCESS] Flash completed.

REM 等待启动
echo.
echo [WAIT] Waiting for MCU to boot...
timeout /t 2 /nobreak >nul

REM 步骤3: 串口监视
echo.
echo [STEP 3/3] Starting serial monitor...
echo ------------------------------------------------------------
echo.
echo  Serial monitor starting in new window...
echo.

start "Serial Monitor - %COM_PORT%" cmd /c "%~dp0serial_monitor.bat" %COM_PORT% %BAUD_RATE%

echo ============================================================
echo  Debug Cycle Started!
echo.
echo  - Firmware is running
echo  - Serial monitor active in separate window
echo.
echo  Next steps:
echo    1. Check serial output
echo    2. Use reg_read.bat to check registers
echo    3. Use watch_var.bat to monitor variables
echo ============================================================

exit /b 0
