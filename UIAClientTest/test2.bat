@echo off
echo === TEST 2: Uruchom Notatnik ===
echo Zamykam stary Notatnik...
taskkill /F /IM notepad.exe >nul 2>&1
timeout /t 1 /nobreak >nul

echo Uruchamiam Notatnik...
start notepad.exe
timeout /t 2 /nobreak >nul

tasklist | find /I "notepad.exe" >nul
if %ERRORLEVEL% EQU 0 (
    echo [OK] Notatnik uruchomiony
    exit /b 0
) else (
    echo [BLAD] Notatnik nie jest uruchomiony
    exit /b 1
)
