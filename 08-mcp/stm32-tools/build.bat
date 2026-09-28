@echo off
REM ============================================================
REM STM32 Debug Tools - Universal Build Script
REM Usage: build.bat [project_path] [rebuild|clean]
REM ============================================================

setlocal enabledelayedexpansion

REM 加载配置
call "%~dp0config.bat"

REM 确定项目路径
if "%~1"=="" (
    REM 自动检测当前目录的.uvprojx文件
    set "PROJECT_DIR=%CD%"
) else (
    set "PROJECT_DIR=%~1"
)

REM 查找项目文件
set "PROJECT_FILE="
for %%f in ("%PROJECT_DIR%\*.uvprojx") do set "PROJECT_FILE=%%f"

if "%PROJECT_FILE%"=="" (
    REM 递归查找
    for /r "%PROJECT_DIR%" %%f in (*.uvprojx) do set "PROJECT_FILE=%%f"
)

if "%PROJECT_FILE%"=="" (
    echo [ERROR] No .uvprojx file found in: %PROJECT_DIR%
    echo Please specify the project path: build.bat "C:\path\to\project"
    exit /b 1
)

echo.
echo ============================================================
echo  STM32 Universal Build Script
echo  Project: %PROJECT_FILE%
echo  Keil:    %KEIL_PATH%
echo  Time:    %date% %time%
echo ============================================================
echo.

REM 检查Keil
if not exist "%KEIL_PATH%" (
    echo [ERROR] Keil not found: %KEIL_PATH%
    echo Please check KEIL_PATH in config.bat
    exit /b 1
)

REM 执行编译
set "LOG_FILE=%LOG_DIR%\build_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%.log"

if "%~2"=="rebuild" (
    echo [INFO] Rebuilding project...
    "%KEIL_PATH%" -r "%PROJECT_FILE%" -o "%LOG_FILE%" -j0 -j1
) else if "%~2"=="clean" (
    echo [INFO] Cleaning project...
    "%KEIL_PATH%" -r "%PROJECT_FILE%" -o "%LOG_FILE%" -j0
) else (
    echo [INFO] Building project (incremental)...
    "%KEIL_PATH%" -r "%PROJECT_FILE%" -o "%LOG_FILE%" -j0
)

set BUILD_RESULT=%ERRORLEVEL%

echo.
echo ============================================================
if %BUILD_RESULT% equ 0 (
    echo [SUCCESS] Build completed successfully!
) else (
    echo [FAILED] Build failed with error code: %BUILD_RESULT%
    echo.
    echo Log file: %LOG_FILE%
    echo.
    REM 显示错误
    powershell -command "Get-Content '%LOG_FILE%' -Tail 15 | Where-Object {$_ -match 'error|Error'}"
)
echo ============================================================

exit /b %BUILD_RESULT%
