@echo off
REM ============================================================
REM STM32 Debug Tools - Universal Memory Monitor
REM Usage: mem_monitor.bat [address] [size] [refresh_sec]
REM ============================================================

setlocal enabledelayedexpansion

REM 加载配置
call "%~dp0config.bat"

REM 参数
set "ADDRESS=%~1"
set "SIZE=%~2"
set "REFRESH=%~3"

if "%ADDRESS%"=="" set "ADDRESS=0x20000000"
if "%SIZE%"=="" set "SIZE=64"
if "%REFRESH%"=="" set "REFRESH=2"

echo.
echo ============================================================
echo  STM32 Memory Monitor
echo  Address: %ADDRESS%
echo  Size:    %SIZE% bytes
echo  Refresh: %REFRESH% seconds
echo  Press Ctrl+C to stop
echo ============================================================
echo.

REM 检查连接
"%STLINK_PATH%" -c port=SWD freq=4000 -q >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [ERROR] ST-Link connection failed!
    exit /b 1
)

:monitor_loop
cls
echo ============================================================
echo  Memory Monitor - %ADDRESS% - %time:~0,8%
echo ============================================================
echo.

REM 读取内存
"%STLINK_PATH%" -c port=SWD freq=4000 -readWord %ADDRESS% %SIZE% -q 2>nul

echo.
echo Refreshing in %REFRESH% seconds...
timeout /t %REFRESH% /nobreak >nul
goto :monitor_loop

exit /b 0
