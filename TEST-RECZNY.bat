@echo off
REM Test [STAThread] - uruchamia UIAClientTest i zapisuje wynik do pliku
REM Uruchom ten plik RECZNIE przez dwukrotne klikniecie w Explorer

echo ==========================================
echo  TEST [STAThread] - UIAClientTest
echo ==========================================
echo.
echo Data testu: %date% %time%
echo.

REM Zapisz poczatek testu
echo [%date% %time%] Test rozpoczety > test-result.log

REM Zamknij Notatnik
taskkill /F /IM notepad.exe 2>nul
echo Notatnik zamkniety >> test-result.log

echo Uruchamiam UIAClientTest --auto...
echo Jesli program sie zawiesi, nacisnij Ctrl+C
echo.

REM Uruchom UIAClientTest i zapisz output
echo [%date% %time%] Uruchamiam UIAClientTest >> test-result.log
"UIAClientTest\bin\Debug\net8.0-windows\UIAClientTest.exe" --auto >> test-result.log 2>&1

REM Zapisz kod wyjscia
set EXIT_CODE=%ERRORLEVEL%
echo [%date% %time%] Kod wyjscia: %EXIT_CODE% >> test-result.log

echo.
echo ==========================================
echo  WYNIK TESTU
echo ==========================================
echo.

if %EXIT_CODE%==0 (
    echo SUKCES! Program zakonczyl sie poprawnie.
    echo [STAThread] naprawil problem!
    echo SUKCES >> test-result.log
) else (
    echo Program zakonczyl sie z kodem: %EXIT_CODE%
    echo Sprawdz test-result.log
    echo BLAD: kod %EXIT_CODE% >> test-result.log
)

echo.
echo Wynik zapisany do: test-result.log
echo.

REM Pokaz zawartosc logu
echo --- ZAWARTOSC LOGU ---
type test-result.log
echo --- KONIEC LOGU ---
echo.

pause
