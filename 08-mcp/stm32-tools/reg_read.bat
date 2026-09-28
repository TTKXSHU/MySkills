@echo off
REM ============================================================
REM STM32 Debug Tools - Universal Register Viewer
REM Usage: reg_read.bat [peripheral|address]
REM ============================================================

setlocal enabledelayedexpansion

REM 加载配置
call "%~dp0config.bat"

REM 检查ST-Link
"%STLINK_PATH%" -c port=SWD freq=4000 -q >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [ERROR] ST-Link connection failed!
    exit /b 1
)

if "%~1"=="" goto :menu
goto :%~1 2>nul || goto :read_addr

:menu
cls
echo.
echo ============================================================
echo          STM32F4 Register Viewer (Universal)
echo ============================================================
echo.
echo   GPIO:
echo     [A] GPIOA    [B] GPIOB    [C] GPIOC    [D] GPIOD
echo.
echo   Timer:
echo     [T1] TIM1    [T2] TIM2    [T3] TIM3    [T4] TIM4
echo.
echo   Communication:
echo     [U1] USART1  [U2] USART2  [S1] SPI1    [I1] I2C1
echo.
echo   System:
echo     [R] RCC      [F] FLASH
echo.
echo   Custom:
echo     Enter address directly (e.g., 0x40000400)
echo.
echo   [Q] Quit
echo.
echo ============================================================
echo.

choice /c ABCDT1T2T3T4U1U2S1I1RFQ /n /m "Select: "

if %ERRORLEVEL% equ 1 goto :gpioa
if %ERRORLEVEL% equ 2 goto :gpiob
if %ERRORLEVEL% equ 3 goto :gpioc
if %ERRORLEVEL% equ 4 goto :gpiod
if %ERRORLEVEL% equ 5 goto :tim1
if %ERRORLEVEL% equ 6 goto :tim2
if %ERRORLEVEL% equ 7 goto :tim3
if %ERRORLEVEL% equ 8 goto :tim4
if %ERRORLEVEL% equ 9 goto :usart1
if %ERRORLEVEL% equ 10 goto :usart2
if %ERRORLEVEL% equ 11 goto :spi1
if %ERRORLEVEL% equ 12 goto :i2c1
if %ERRORLEVEL% equ 13 goto :rcc
if %ERRORLEVEL% equ 14 goto :flash
if %ERRORLEVEL% equ 15 goto :eof

goto :menu

:gpioa
set "BASE=0x40020000"
set "NAME=GPIOA"
goto :show_gpio

:gpiob
set "BASE=0x40020400"
set "NAME=GPIOB"
goto :show_gpio

:gpioc
set "BASE=0x40020800"
set "NAME=GPIOC"
goto :show_gpio

:gpiod
set "BASE=0x40020C00"
set "NAME=GPIOD"
goto :show_gpio

:show_gpio
echo.
echo ============================================================
echo  %NAME% Registers (Base: %BASE%)
echo ============================================================
echo.

for %%r in (
    "MODER:0x00:Mode"
    "OTYPER:0x04:Output Type"
    "OSPEEDR:0x08:Speed"
    "PUPDR:0x0C:Pull-up/down"
    "IDR:0x10:Input Data"
    "ODR:0x14:Output Data"
    "BSRR:0x18:Bit Set/Reset"
    "LCKR:0x1C:Lock"
    "AFRL:0x20:Alt Func Low"
    "AFRH:0x24:Alt Func High"
) do (
    for /f "tokens=1,2,3 delims=:" %%a in ("%%~r") do (
        set /a "REG_ADDR=%BASE% + 0x%%b"
        echo   %%a [+0x%%b]:
        "%STLINK_PATH%" -c port=SWD freq=4000 -readWord !REG_ADDR! 1 -q 2>nul
        echo     ; %%c
    )
)

echo.
pause
goto :menu

:tim3
set "BASE=0x40000400"
set "NAME=TIM3"
goto :show_timer

:tim2
set "BASE=0x40000000"
set "NAME=TIM2"
goto :show_timer

:tim1
set "BASE=0x40010000"
set "NAME=TIM1"
goto :show_timer

:tim4
set "BASE=0x40000800"
set "NAME=TIM4"
goto :show_timer

:show_timer
echo.
echo ============================================================
echo  %NAME% Registers (Base: %BASE%)
echo ============================================================
echo.

for %%r in (
    "CR1:0x00:Control 1"
    "CR2:0x04:Control 2"
    "SMCR:0x08:Slave Mode"
    "DIER:0x0C:Interrupt Enable"
    "SR:0x10:Status"
    "EGR:0x14:Event Gen"
    "CCMR1:0x18:Capture/Compare Mode 1"
    "CCMR2:0x1C:Capture/Compare Mode 2"
    "CCER:0x20:Capture/Compare Enable"
    "CNT:0x24:Counter"
    "PSC:0x28:Prescaler"
    "ARR:0x2C:Auto-Reload"
    "CCR1:0x34:Capture/Compare 1"
    "CCR2:0x38:Capture/Compare 2"
    "CCR3:0x3C:Capture/Compare 3"
    "CCR4:0x40:Capture/Compare 4"
) do (
    for /f "tokens=1,2,3 delims=:" %%a in ("%%~r") do (
        set /a "REG_ADDR=%BASE% + 0x%%b"
        echo   %%a [+0x%%b]:
        "%STLINK_PATH%" -c port=SWD freq=4000 -readWord !REG_ADDR! 1 -q 2>nul
        echo     ; %%c
    )
)

echo.
pause
goto :menu

:usart1
set "BASE=0x40011000"
set "NAME=USART1"
goto :show_uart

:usart2
set "BASE=0x40004400"
set "NAME=USART2"
goto :show_uart

:show_uart
echo.
echo ============================================================
echo  %NAME% Registers (Base: %BASE%)
echo ============================================================
echo.

for %%r in (
    "SR:0x00:Status"
    "DR:0x04:Data"
    "BRR:0x08:Baud Rate"
    "CR1:0x0C:Control 1"
    "CR2:0x10:Control 2"
    "CR3:0x14:Control 3"
) do (
    for /f "tokens=1,2,3 delims=:" %%a in ("%%~r") do (
        set /a "REG_ADDR=%BASE% + 0x%%b"
        echo   %%a [+0x%%b]:
        "%STLINK_PATH%" -c port=SWD freq=4000 -readWord !REG_ADDR! 1 -q 2>nul
        echo     ; %%c
    )
)

echo.
pause
goto :menu

:spi1
set "BASE=0x40013000"
set "NAME=SPI1"
goto :show_spi

:show_spi
echo.
echo ============================================================
echo  %NAME% Registers (Base: %BASE%)
echo ============================================================
echo.

for %%r in (
    "CR1:0x00:Control 1"
    "CR2:0x04:Control 2"
    "SR:0x08:Status"
    "DR:0x0C:Data"
) do (
    for /f "tokens=1,2,3 delims=:" %%a in ("%%~r") do (
        set /a "REG_ADDR=%BASE% + 0x%%b"
        echo   %%a [+0x%%b]:
        "%STLINK_PATH%" -c port=SWD freq=4000 -readWord !REG_ADDR! 1 -q 2>nul
        echo     ; %%c
    )
)

echo.
pause
goto :menu

:i2c1
set "BASE=0x40005400"
set "NAME=I2C1"
goto :show_i2c

:show_i2c
echo.
echo ============================================================
echo  %NAME% Registers (Base: %BASE%)
echo ============================================================
echo.

for %%r in (
    "CR1:0x00:Control 1"
    "CR2:0x04:Control 2"
    "OAR1:0x08:Own Address 1"
    "OAR2:0x0C:Own Address 2"
    "DR:0x10:Data"
    "SR1:0x14:Status 1"
    "SR2:0x18:Status 2"
    "CCR:0x1C:Clock Control"
    "TRISE:0x20:Rise Time"
) do (
    for /f "tokens=1,2,3 delims=:" %%a in ("%%~r") do (
        set /a "REG_ADDR=%BASE% + 0x%%b"
        echo   %%a [+0x%%b]:
        "%STLINK_PATH%" -c port=SWD freq=4000 -readWord !REG_ADDR! 1 -q 2>nul
        echo     ; %%c
    )
)

echo.
pause
goto :menu

:rcc
echo.
echo ============================================================
echo  RCC Registers (Clock Control)
echo ============================================================
echo.

for %%r in (
    "CR:0x40023800:Clock Control"
    "PLLCFGR:0x40023804:PLL Config"
    "CFGR:0x40023808:Clock Config"
    "AHB1ENR:0x40023830:AHB1 Enable"
    "APB1ENR:0x40023840:APB1 Enable"
    "APB2ENR:0x40023844:APB2 Enable"
) do (
    for /f "tokens=1,2,3 delims=:" %%a in ("%%~r") do (
        echo   %%a [%%b]:
        "%STLINK_PATH%" -c port=SWD freq=4000 -readWord %%b 1 -q 2>nul
        echo     ; %%c
    )
)

echo.
pause
goto :menu

:flash
echo.
echo ============================================================
echo  Flash Registers
echo ============================================================
echo.

for %%r in (
    "ACR:0x40023C00:Access Control"
    "SR:0x40023C0C:Status"
    "CR:0x40023C10:Control"
) do (
    for /f "tokens=1,2,3 delims=:" %%a in ("%%~r") do (
        echo   %%a [%%b]:
        "%STLINK_PATH%" -c port=SWD freq=4000 -readWord %%b 1 -q 2>nul
        echo     ; %%c
    )
)

echo.
pause
goto :menu

:read_addr
set "ADDR=%~1"
set "COUNT=1"
if not "%~2"=="" set "COUNT=%~2"

echo.
echo Reading %COUNT% word(s) from %ADDR%:
"%STLINK_PATH%" -c port=SWD freq=4000 -readWord %ADDR% %COUNT% -q

exit /b 0

:eof
exit /b 0
