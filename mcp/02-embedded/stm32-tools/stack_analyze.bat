@echo off
REM ============================================================
REM STM32 Debug Tools - Universal Stack Analysis
REM Usage: stack_analyze.bat [map_file]
REM ============================================================

setlocal enabledelayedexpansion

REM 参数
set "MAP_FILE=%~1"

REM 自动查找map文件
if "%MAP_FILE%"=="" (
    for /r "%CD%" %%f in (*.map) do set "MAP_FILE=%%f"
)

if not exist "%MAP_FILE%" (
    echo [ERROR] Map file not found!
    echo Usage: stack_analyze.bat "C:\path\to\project.map"
    echo Please build the project first.
    exit /b 1
)

echo.
echo ============================================================
echo  Stack Analysis Tool
echo  Map File: %MAP_FILE%
echo ============================================================
echo.

REM 提取堆栈信息
echo [STACK CONFIGURATION]
echo ------------------------------------------------------------
echo.

for /f "tokens=2" %%a in ('findstr /i "Stack_Size" "%MAP_FILE%" 2^>nul') do (
    echo   Stack Size: %%a bytes
)

for /f "tokens=2" %%a in ('findstr /i "Heap_Size" "%MAP_FILE%" 2^>nul') do (
    echo   Heap Size: %%a bytes
)

echo.
echo [MEMORY REGIONS]
echo ------------------------------------------------------------
echo.

findstr /i "RAM\|FLASH" "%MAP_FILE%" 2>nul | findstr /i "0x[0-9a-fA-F]" | head -10

echo.
echo [STACK USAGE TIPS]
echo ------------------------------------------------------------
echo.
echo   1. Compile with stack analysis enabled:
echo      Options > C/C++ > Warnings > Enable all warnings
echo.
echo   2. Use linker feedback:
echo      Options > Linker > Enable linker feedback
echo.
echo   3. Runtime stack watermark check:
echo      Add to main():
echo.
echo      extern uint32_t __initial_sp;
echo      #define STACK_PATTERN 0xDEADBEEF
echo      #define STACK_CHECK_SIZE 128
echo.
echo      uint32_t *guard = (uint32_t*)&__initial_sp - STACK_CHECK_SIZE;
echo      for(int i=0; i<STACK_CHECK_SIZE; i++) guard[i] = STACK_PATTERN;
echo.
echo      // Periodic check:
echo      uint32_t free = 0;
echo      for(int i=0; i<STACK_CHECK_SIZE; i++) {
echo          if(guard[i] == STACK_PATTERN) free++;
echo          else break;
echo      }
echo      free *= 4; // bytes
echo.
echo   4. Monitor SP in debugger:
echo      View > Registers > SP
echo.

REM 检查潜在问题
echo [RISK ASSESSMENT]
echo ------------------------------------------------------------
echo.

REM 查找可能的递归
set "RISK=0"
for /r "%CD%" %%f in (*.c) do (
    findstr /i "recursive\|recursion" "%%f" >nul 2>&1
    if !ERRORLEVEL! equ 0 (
        echo   [WARNING] Recursive code in: %%~nxf
        set /a RISK+=1
    )
)

if %RISK% equ 0 echo   [OK] No recursive functions detected

echo.
echo [RECOMMENDATIONS]
echo ------------------------------------------------------------
echo.
echo   - Minimum Stack Size: 512 bytes for simple applications
echo   - Minimum Heap Size: 256 bytes (if needed)
echo   - For complex applications: 1024+ bytes stack
echo   - Monitor stack usage in debug sessions
echo.

echo ============================================================

exit /b 0
