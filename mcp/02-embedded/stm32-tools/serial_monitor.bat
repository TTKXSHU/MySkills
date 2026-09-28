@echo off
REM ============================================================
REM STM32 Debug Tools - Universal Serial Monitor
REM Usage: serial_monitor.bat [COM_PORT] [BAUD_RATE]
REM ============================================================

setlocal enabledelayedexpansion

REM 加载配置
call "%~dp0config.bat"

REM 参数处理
set "COM_PORT=%~1"
set "BAUD_RATE=%~2"

if "%COM_PORT%"=="" set "COM_PORT=%DEFAULT_SERIAL_PORT%"
if "%BAUD_RATE%"=="" set "BAUD_RATE=%DEFAULT_SERIAL_BAUD%"

echo.
echo ============================================================
echo  STM32 Serial Monitor
echo  Port: %COM_PORT%
echo  Baud: %BAUD_RATE%
echo  Time: %date% %time%
echo  Press Ctrl+C to exit
echo ============================================================
echo.

REM 检查串口
mode %COM_PORT% >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Serial port %COM_PORT% not found!
    echo.
    echo Available ports:
    powershell -command "Get-WMIObject Win32_SerialPort | Select-Object DeviceID, Description | Format-Table"
    exit /b 1
)

REM 配置串口
mode %COM_PORT% baud=%BAUD_RATE% parity=n data=8 stop=1 >nul 2>&1

echo [INFO] Listening on %COM_PORT% at %BAUD_RATE% baud...
echo [INFO] Waiting for data...
echo.

REM 串口监听
powershell -command ^
    "$port = New-Object System.IO.Ports.SerialPort '%COM_PORT%',%BAUD_RATE%,None,8,One; ^
     $port.ReadTimeout = 500; ^
     $port.Open(); ^
     Write-Host '[CONNECTED] Serial port opened.' -ForegroundColor Green; ^
     try { ^
         while ($true) { ^
             try { ^
                 $line = $port.ReadLine(); ^
                 $timestamp = Get-Date -Format 'HH:mm:ss.fff'; ^
                 Write-Host \"[$timestamp] $line\"; ^
             } catch [System.TimeoutException] { ^
                 # Timeout is normal ^
             } ^
         } ^
     } finally { ^
         $port.Close(); ^
         Write-Host '[DISCONNECTED] Serial port closed.' -ForegroundColor Yellow; ^
     }"

exit /b 0
