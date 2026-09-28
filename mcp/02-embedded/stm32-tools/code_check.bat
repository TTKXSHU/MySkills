@echo off
REM ============================================================
REM STM32 Debug Tools - Universal Code Static Analysis
REM Usage: code_check.bat [file.c|directory|all]
REM ============================================================

setlocal enabledelayedexpansion

REM 参数
set "TARGET=%~1"
set "LOG_FILE=%~dp0logs\code_analysis_%date:~0,4%%date:~5,2%%date:~8,2%.log"

REM 创建日志目录
if not exist "%~dp0logs" mkdir "%~dp0logs"

echo.
echo ============================================================
echo  STM32 Code Static Analysis
echo  Time: %date% %time%
echo ============================================================
echo.
echo Log: %LOG_FILE%
echo.

REM 初始化日志
echo Code Analysis Report - %date% %time% > "%LOG_FILE%"
echo. >> "%LOG_FILE%"

set "ISSUE_COUNT=0"
set "FILE_COUNT=0"

REM 分析函数
:analyze_file
set "FILE=%~1"
set "FILENAME=%~nx1"
set /a FILE_COUNT+=1

echo Analyzing: %FILENAME%
echo ------------------------------------------------ >> "%LOG_FILE%"
echo File: %FILENAME% >> "%LOG_FILE%"

REM 检查1: malloc/free
findstr /i /n "malloc\|calloc\|realloc\|free" "%FILE%" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo   [WARNING] Memory allocation detected
    echo   [WARNING] Memory allocation detected >> "%LOG_FILE%"
    set /a ISSUE_COUNT+=1
)

REM 检查2: printf
findstr /i /n "printf" "%FILE%" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo   [INFO] printf usage - ensure retarget configured
    echo   [INFO] printf usage >> "%LOG_FILE%"
)

REM 检查3: while(1)
findstr /i /n "while(1)\|while (1)\|while( 1)" "%FILE%" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo   [WARNING] Infinite loop detected
    echo   [WARNING] Infinite loop >> "%LOG_FILE%"
    set /a ISSUE_COUNT+=1
)

REM 检查4: HAL_Delay
findstr /i /n "HAL_Delay\|osDelay" "%FILE%" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo   [WARNING] Delay function - verify not in ISR
    echo   [WARNING] Delay function >> "%LOG_FILE%"
    set /a ISSUE_COUNT+=1
)

REM 检查5: TODO/FIXME
findstr /i /n "TODO\|FIXME\|HACK\|XXX" "%FILE%" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo   [INFO] TODO/FIXME markers found
    echo   [INFO] TODO/FIXME markers >> "%LOG_FILE%"
)

REM 检查6: 文件大小
set "LINE_COUNT=0"
for /f %%a in ('type "%FILE%" 2^>nul ^| find /c /v ""') do set "LINE_COUNT=%%a"
if %LINE_COUNT% gtr 300 (
    echo   [INFO] Large file (%LINE_COUNT% lines) - consider splitting
    echo   [INFO] Large file (%LINE_COUNT% lines) >> "%LOG_FILE%"
)

echo. >> "%LOG_FILE%"
goto :eof

REM 主程序
if "%TARGET%"=="" (
    REM 分析当前目录所有.c文件
    echo Scanning current directory: %CD%
    echo.
    for %%f in ("%CD%\*.c") do call :analyze_file "%%f"
    for /r "%CD%" %%f in (*.c) do (
        if not "%%~nxf"=="%~n0" call :analyze_file "%%f"
    )
) else if exist "%TARGET%" (
    if "%TARGET:~-2%"==".c" (
        REM 分析指定文件
        call :analyze_file "%TARGET%"
    ) else if exist "%TARGET%\*" (
        REM 分析目录
        for %%f in ("%TARGET%\*.c") do call :analyze_file "%%f"
    )
) else (
    echo [ERROR] Target not found: %TARGET%
    exit /b 1
)

echo.
echo ============================================================
echo  Analysis Complete!
echo  Files analyzed: %FILE_COUNT%
echo  Issues found:   %ISSUE_COUNT%
echo  Report:         %LOG_FILE%
echo ============================================================

exit /b %ISSUE_COUNT%
