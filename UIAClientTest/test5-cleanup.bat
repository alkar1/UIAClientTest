@echo off
echo === TEST 5: Zamknij Notatnik ===
echo Zamykam Notatnik...
taskkill /F /IM notepad.exe >nul 2>&1

timeout /t 1 /nobreak >nul

tasklist | find /I "notepad.exe" >nul
if %ERRORLEVEL% NEQ 0 (
    echo [OK] Notatnik zamkniety
    exit /b 0
) else (
    echo [BLAD] Notatnik nadal uruchomiony
    exit /b 1
)
