@echo off
echo ========================================
echo  SZYBKI TEST - UIAClientTest + Monitor
echo ========================================
echo.

echo [1/3] Budowanie projektow...
dotnet build --configuration Debug
if %ERRORLEVEL% NEQ 0 (
    echo BLAD kompilacji!
    pause
    exit /b 1
)

echo.
echo [2/3] Zamykanie Notatnika...
taskkill /F /IM notepad.exe 2>nul
timeout /t 2 /nobreak >nul

echo.
echo [3/3] Uruchamianie monitora...
echo.
UIAClientTest.Monitor\bin\Debug\net8.0-windows\UIAClientTest.Monitor.exe 15

pause
