@echo off
REM ============================================================
REM Add STM32 Debug Tools to PATH
REM Run this script to add tools to system PATH
REM ============================================================

set "TOOLS_DIR=%~dp0"
set "TOOLS_DIR=%TOOLS_DIR:~0,-1%"

echo.
echo ============================================================
echo  Adding STM32 Debug Tools to PATH
echo ============================================================
echo.
echo  Tools Directory: %TOOLS_DIR%
echo.

REM 检查是否已在PATH中
echo %PATH% | findstr /i "%TOOLS_DIR%" >nul
if %ERRORLEVEL% equ 0 (
    echo  [INFO] Tools already in PATH
) else (
    REM 添加到用户PATH
    for /f "tokens=2*" %%a in ('reg query HKCU\Environment /v Path 2^>nul') do set "USER_PATH=%%b"
    
    if defined USER_PATH (
        setx PATH "%USER_PATH%;%TOOLS_DIR%"
    ) else (
        setx PATH "%TOOLS_DIR%"
    )
    
    echo  [SUCCESS] Added to PATH
)

echo.
echo  You can now use these commands from any directory:
echo.
echo    stm32-tools       - Main menu
echo    stm32-build       - Build project
echo    stm32-flash       - Flash firmware
echo    stm32-serial      - Serial monitor
echo.
echo  NOTE: Restart your terminal for PATH changes to take effect
echo.
echo ============================================================
echo.

pause
