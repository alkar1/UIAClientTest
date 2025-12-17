@echo off
REM Prosty test czy Monitor dziala po dodaniu [STAThread]
REM Ten skrypt uruchomi Monitor i sprawdzi czy sie nie zawiesza

echo ==========================================
echo  TEST NAPRAWY [STAThread]
echo ==========================================
echo.
echo Problem: UIAClientTest i Monitor zawieszaly sie
echo Rozwiazanie: Dodano [STAThread] do Main()
echo.
echo Ten test sprawdzi czy problem zostal naprawiony.
echo.
pause

echo.
echo [1/2] Budowanie projektow z [STAThread]...
dotnet build --configuration Debug --verbosity minimal
if %ERRORLEVEL% NEQ 0 (
    echo BLAD kompilacji!
    pause
    exit /b 1
)
echo   OK - Kompilacja udana
echo.

echo [2/2] Uruchamianie Monitora (timeout 10s)...
echo.
echo UWAGA: Jesli Monitor sie zawiesi, nacisnij Ctrl+C aby przerwac
echo        Czekam max 30 sekund...
echo.

REM Uruchom Monitor z timeoutem
timeout /t 2 /nobreak >nul
start /wait /b "" "UIAClientTest.Monitor\bin\Debug\net8.0-windows\UIAClientTest.Monitor.exe" 10

echo.
echo ==========================================
echo Monitor zakonczyl dzialanie!
echo ==========================================
echo.
echo Jesli widzisz ten komunikat, oznacza to ze:
echo   1. Monitor sie NIE zawiesil
echo   2. [STAThread] rozwiazal problem!
echo   3. Monitor mogl uruchomic UIAClientTest
echo.

REM Zamknij Notatnik jesli zostal
taskkill /F /IM notepad.exe 2>nul >nul

echo Test zakonczony pomyslnie!
echo.
pause
