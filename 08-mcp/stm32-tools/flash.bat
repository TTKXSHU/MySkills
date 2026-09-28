@echo off
REM ============================================================
REM STM32 Debug Tools - Universal Flash Script
REM Usage: flash.bat [firmware_path] [hex|bin] [address]
REM ============================================================

setlocal enabledelayedexpansion

REM 加载配置
call "%~dp0config.bat"

REM 检查ST-Link
if not exist "%STLINK_PATH%" (
    echo [ERROR] STM32CubeProgrammer not found: %STLINK_PATH%
    echo Please check STLINK_PATH in config.bat
    exit /b 1
)

REM 参数处理
set "FW_FILE=%~1"
set "FW_TYPE=%~2"
set "FLASH_ADDR=%~3"

REM 自动检测固件文件
if "%FW_FILE%"=="" (
    REM 在当前目录查找hex/bin文件
    for /r "%CD%" %%f in (*.hex) do (
        set "FW_FILE=%%f"
        set "FW_TYPE=hex"
        goto :found_fw
    )
    for /r "%CD%" %%f in (*.bin) do (
        set "FW_FILE=%%f"
        set "FW_TYPE=bin"
        goto :found_fw
    )
    
    echo [ERROR] No firmware file found!
    echo Usage: flash.bat "C:\path\to\firmware.hex" [hex|bin] [address]
    exit /b 1
)

REM 自动检测类型
if "%FW_TYPE%"=="" (
    echo %FW_FILE% | findstr /i ".hex" >nul && set "FW_TYPE=hex"
    echo %FW_FILE% | findstr /i ".bin" >nul && set "FW_TYPE=bin"
    if "%FW_TYPE%"=="" set "FW_TYPE=hex"
)

:found_fw
if "%FLASH_ADDR%"=="" set "FLASH_ADDR=0x08000000"

echo.
echo ============================================================
echo  STM32 Universal Flash Script
echo  Firmware: %FW_FILE%
echo  Type:     %FW_TYPE%
echo  Address:  %FLASH_ADDR%
echo  ST-Link:  %STLINK_PATH%
echo  Time:     %date% %time%
echo ============================================================
echo.

REM 检查文件
if not exist "%FW_FILE%" (
    echo [ERROR] Firmware file not found: %FW_FILE%
    exit /b 1
)

REM 检查ST-Link连接
echo [1/4] Checking ST-Link connection...
"%STLINK_PATH%" -c port=SWD freq=4000 -q >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [ERROR] ST-Link connection failed!
    echo.
    echo Please check:
    echo   1. ST-Link is connected to PC
    echo   2. ST-Link is connected to target
    echo   3. Target is powered on
    echo   4. SWD pins are connected
    exit /b 1
)
echo   [OK] Connected

REM 烧录
echo [2/4] Flashing firmware...
if "%FW_TYPE%"=="bin" (
    "%STLINK_PATH%" -c port=SWD freq=4000 -w "%FW_FILE%" %FLASH_ADDR% -v -rst
) else (
    "%STLINK_PATH%" -c port=SWD freq=4000 -w "%FW_FILE%" -v -rst
)

set FLASH_RESULT=%ERRORLEVEL%

echo.
if %FLASH_RESULT% equ 0 (
    echo [3/4] Verification passed
    echo [4/4] Target reset
    echo.
    echo ============================================================
    echo [SUCCESS] Flash completed! Target is running.
    echo ============================================================
) else (
    echo [FAILED] Flash failed with error code: %FLASH_RESULT%
)

exit /b %FLASH_RESULT%
