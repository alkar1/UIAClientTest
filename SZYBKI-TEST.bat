@echo off
REM ============================================
REM  SZYBKI TEST - czy UIAClientTest sie zawiesza?
REM ============================================
REM Uruchom przez DWUKROTNE KLIKNIECIE w Explorer

echo.
echo === SZYBKI TEST ZAWIESZENIA ===
echo.

REM Zamknij stare procesy
taskkill /F /IM UIAClientTest.exe 2>nul
taskkill /F /IM notepad.exe 2>nul

echo [1] Uruchamiam UIAClientTest w tle...
start "" "UIAClientTest\bin\Debug\net8.0-windows\UIAClientTest.exe" --auto

echo [2] Czekam 8 sekund...
echo.

REM Odliczanie
for /L %%i in (1,1,8) do (
    timeout /t 1 /nobreak >nul
    
    REM Sprawdz czy jeszcze dziala
    tasklist /FI "IMAGENAME eq UIAClientTest.exe" 2>nul | find /I "UIAClientTest.exe" >nul
    if errorlevel 1 (
        echo.
        echo ========================================
        echo  SUKCES! Program zakonczyl sie w %%i s
        echo  [STAThread] dziala poprawnie!
        echo ========================================
        goto :DONE
    )
    echo   ...%%i/8s - proces dziala
)

echo.
echo ========================================
echo  TIMEOUT! Program sie ZAWIESIL
echo  Zabijam proces...
echo ========================================
taskkill /F /IM UIAClientTest.exe 2>nul

:DONE
echo.
pause
