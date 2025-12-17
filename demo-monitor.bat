REM ============================================
REM  DEMO - Uruchomienie Monitora
REM ============================================
REM Ten plik pokazuje jak u¿ywaæ Monitora
REM ============================================

@echo off
echo.
echo ============================================
echo  DEMO: UIAClientTest Monitor
echo ============================================
echo.
echo Ten skrypt pokaze rozne sposoby uzycia Monitora
echo.
pause

echo.
echo ============================================
echo  SPOSOB 1: Quick Test (ZALECANE)
echo ============================================
echo.
echo Komenda: quick-test-monitor.bat
echo.
echo Co robi:
echo  1. Buduje oba projekty
echo  2. Zamyka Notatnik
echo  3. Uruchamia Monitor (timeout 15s)
echo.
echo Chcesz uruchomic? (T/N)
choice /C TN /N
if errorlevel 2 goto sposob2
call quick-test-monitor.bat
goto koniec

:sposob2
echo.
echo ============================================
echo  SPOSOB 2: Tylko Monitor (domyslny timeout)
echo ============================================
echo.
echo Komenda: run-monitor.bat
echo.
echo Co robi:
echo  - Uruchamia Monitor z timeoutem 10s
echo  - Zaklada ze projekty sa zbudowane
echo.
echo Chcesz uruchomic? (T/N)
choice /C TN /N
if errorlevel 2 goto sposob3
call run-monitor.bat
goto koniec

:sposob3
echo.
echo ============================================
echo  SPOSOB 3: PowerShell z customowym timeoutem
echo ============================================
echo.
echo Komenda: .\run-monitor.ps1 30
echo.
echo Co robi:
echo  - Uruchamia Monitor z timeoutem 30s
echo  - Przydatne dla wolniejszych systemow
echo.
echo Chcesz uruchomic? (T/N)
choice /C TN /N
if errorlevel 2 goto koniec
powershell -ExecutionPolicy Bypass -File run-monitor.ps1 30

:koniec
echo.
echo ============================================
echo  DEMO zakonczone
echo ============================================
echo.
echo Wiecej informacji w:
echo  - START-MONITOR.md
echo  - MONITOR-SUMMARY.md
echo  - TEST-RESULTS.md
echo.
pause
