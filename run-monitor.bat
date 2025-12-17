@echo off
echo ===================================
echo  UIAClientTest Monitor - Uruchomienie
echo ===================================
echo.

REM Budowanie projektu Monitor
echo [1/2] Budowanie UIAClientTest.Monitor...
dotnet build UIAClientTest.Monitor\UIAClientTest.Monitor.csproj --configuration Debug
if %ERRORLEVEL% NEQ 0 (
    echo BLAD: Nie udalo sie zbudowac projektu Monitor
    pause
    exit /b 1
)

echo.
echo [2/2] Uruchamianie monitora...
echo.

UIAClientTest.Monitor\bin\Debug\net8.0-windows\UIAClientTest.Monitor.exe

pause
