@echo off
REM Test Monitora - wersja prosta bez zawieszania
REM Uruchamia Monitor w tle z timeoutem

echo =======================================
echo  TEST MONITORA - Weryfikacja
echo =======================================
echo.

echo [1/3] Zamykanie Notatnika...
taskkill /F /IM notepad.exe 2>nul
timeout /t 1 /nobreak >nul
echo   Notatnik zamkniety
echo.

echo [2/3] Budowanie projektow...
dotnet build --configuration Debug --verbosity quiet
if %ERRORLEVEL% NEQ 0 (
    echo   BLAD kompilacji!
    pause
    exit /b 1
)
echo   Kompilacja zakonczona pomyslnie
echo.

echo [3/3] Uruchamianie Monitora z timeoutem 8s...
echo.
echo UWAGA: Monitor uruchomi UIAClientTest i bedzie go monitorowal
echo        Jesli UIAClientTest sie zawiesi, Monitor to wykryje
echo        i zakonczy zawieszony proces po 8 sekundach.
echo.
pause

REM Uruchom Monitor - podaj timeout jako argument
start /wait "" "UIAClientTest.Monitor\bin\Debug\net8.0-windows\UIAClientTest.Monitor.exe" 8

echo.
echo =======================================
echo  TEST ZAKONCZONY
echo =======================================
echo.

REM Zamknij Notatnik jesli zostal
taskkill /F /IM notepad.exe 2>nul

echo Monitor zostal przetestowany!
echo.
echo Gotowe do uzycia:
echo   quick-test-monitor.bat
echo   lub
echo   run-monitor.ps1 15
echo.
echo Repozytorium na GitHub:
echo   https://github.com/alkar1/UIAClientTest
echo.
pause
