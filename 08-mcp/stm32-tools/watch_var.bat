@echo off
REM ============================================================
REM STM32 Debug Tools - Variable Address Finder
REM Usage: watch_var.bat [variable_name] [map_file]
REM ============================================================

setlocal enabledelayedexpansion

REM 加载配置
call "%~dp0config.bat"

REM 参数
set "VAR_NAME=%~1"
set "MAP_FILE=%~2"

REM 自动查找map文件
if "%MAP_FILE%"=="" (
    for /r "%CD%" %%f in (*.map) do set "MAP_FILE=%%f"
)

if "%VAR_NAME%"=="" (
    echo.
    echo ============================================================
    echo  Variable Address Finder
    echo ============================================================
    echo.
    echo  Usage: watch_var.bat variable_name [map_file]
    echo.
    echo  Searching for global variables in map file...
    echo.
    
    if exist "%MAP_FILE%" (
        echo  Map file: %MAP_FILE%
        echo.
        findstr /i "^[0-9a-fA-F].*Global" "%MAP_FILE%" 2>nul | head -30
    ) else (
        echo  [ERROR] Map file not found!
        echo  Please build the project first.
    )
    
    echo.
    exit /b 0
)

echo.
echo ============================================================
echo  Variable Watcher: %VAR_NAME%
echo ============================================================
echo.

if not exist "%MAP_FILE%" (
    echo [ERROR] Map file not found: %MAP_FILE%
    echo Please build the project first.
    exit /b 1
)

echo Searching for '%VAR_NAME%' in map file...
echo Map: %MAP_FILE%
echo.

REM 搜索变量
set "FOUND=0"
for /f "tokens=1,2" %%a in ('findstr /i "%VAR_NAME%" "%MAP_FILE%" 2^>nul') do (
    set "ADDR=%%a"
    
    REM 检查是否是有效地址
    echo !ADDR! | findstr /r "^[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]$" >nul
    if !ERRORLEVEL! equ 0 (
        echo [FOUND] %VAR_NAME% @ 0x!ADDR!
        echo.
        
        REM 读取当前值
        echo Current value:
        "%STLINK_PATH%" -c port=SWD freq=4000 -readWord 0x!ADDR! 1 -q 2>nul
        
        set "FOUND=1"
    )
)

if %FOUND% equ 0 (
    echo [WARNING] Variable '%VAR_NAME%' not found.
    echo.
    echo Possible reasons:
    echo   1. Variable is local (not in map file)
    echo   2. Variable name is misspelled
    echo   3. Project needs to be rebuilt
)

echo.
exit /b 0
