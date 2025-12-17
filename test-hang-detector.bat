@echo off
REM ============================================
REM  PROSTE NARZEDZIE DO TESTOWANIA ZAWIESZENIA
REM ============================================
REM Uruchamia proces w tle, czeka X sekund, sprawdza czy jeszcze dziala
REM Jesli dziala po timeout - proces sie zawiesil

setlocal enabledelayedexpansion

set EXE_PATH=UIAClientTest\bin\Debug\net8.0-windows\UIAClientTest.exe
set TIMEOUT_SEC=10
set LOG_FILE=test-hang-result.txt

echo ============================================
echo  TEST ZAWIESZENIA - UIAClientTest
echo ============================================
echo.
echo Timeout: %TIMEOUT_SEC% sekund
echo Log: %LOG_FILE%
echo.

REM Zapisz start
echo [%date% %time%] START TESTU > %LOG_FILE%
echo EXE: %EXE_PATH% >> %LOG_FILE%
echo Timeout: %TIMEOUT_SEC%s >> %LOG_FILE%
echo. >> %LOG_FILE%

REM Sprawdz czy exe istnieje
if not exist "%EXE_PATH%" (
    echo BLAD: Nie znaleziono %EXE_PATH%
    echo BLAD: Plik nie istnieje >> %LOG_FILE%
    pause
    exit /b 1
)
echo [OK] Plik exe znaleziony

REM Zamknij Notatnik przed testem
taskkill /F /IM notepad.exe 2>nul
echo [OK] Notatnik zamkniety

REM Uruchom proces W TLE (start bez /wait)
echo.
echo [1] Uruchamiam UIAClientTest w tle...
echo [%date% %time%] Uruchamiam proces >> %LOG_FILE%

start "" "%EXE_PATH%" --auto

REM Daj chwile na start
timeout /t 2 /nobreak >nul

REM Sprawdz czy proces istnieje
tasklist /FI "IMAGENAME eq UIAClientTest.exe" 2>nul | find /I "UIAClientTest.exe" >nul
if %ERRORLEVEL%==0 (
    echo [OK] Proces uruchomiony
    echo [%date% %time%] Proces uruchomiony >> %LOG_FILE%
) else (
    echo [!] Proces juz sie zakonczyl (bardzo szybko)
    echo [%date% %time%] Proces zakonczyl sie natychmiast >> %LOG_FILE%
    goto :CHECK_RESULT
)

REM Czekaj i sprawdzaj co sekunde
echo.
echo [2] Czekam max %TIMEOUT_SEC% sekund na zakonczenie...
echo.

set /a COUNTER=0

:WAIT_LOOP
if %COUNTER% GEQ %TIMEOUT_SEC% goto :TIMEOUT_REACHED

REM Sprawdz czy proces jeszcze dziala
tasklist /FI "IMAGENAME eq UIAClientTest.exe" 2>nul | find /I "UIAClientTest.exe" >nul
if %ERRORLEVEL%==1 (
    REM Proces sie zakonczyl
    echo.
    echo [OK] Proces zakonczyl sie po %COUNTER% sekundach
    echo [%date% %time%] Proces zakonczyl sie po %COUNTER%s >> %LOG_FILE%
    goto :CHECK_RESULT
)

REM Proces jeszcze dziala - czekaj
set /a COUNTER+=1
echo   Czekam... %COUNTER%/%TIMEOUT_SEC%s
timeout /t 1 /nobreak >nul
goto :WAIT_LOOP

:TIMEOUT_REACHED
echo.
echo ============================================
echo  !!! TIMEOUT - PROCES SIE ZAWIESIL !!!
echo ============================================
echo.
echo Proces nie zakonczyl sie w %TIMEOUT_SEC% sekund
echo To oznacza ze UIAClientTest sie ZAWIESIL
echo.
echo [%date% %time%] TIMEOUT - proces zawiesil sie >> %LOG_FILE%
echo WYNIK: ZAWIESZENIE >> %LOG_FILE%

REM Zabij zawieszony proces
echo Zabijam zawieszony proces...
taskkill /F /IM UIAClientTest.exe 2>nul
echo Proces zabity >> %LOG_FILE%

echo.
echo DIAGNOZA: Program prawdopodobnie zawiesil sie na:
echo   - SetFocus() 
echo   - lub innej operacji UI Automation
echo.
echo ROZWIAZANIE: Sprawdz czy [STAThread] jest dodany do Main()
echo.
goto :END

:CHECK_RESULT
echo.
echo ============================================
echo  SUKCES - PROCES ZAKONCZYL SIE NORMALNIE
echo ============================================
echo.
echo [STAThread] DZIALA POPRAWNIE!
echo Program nie zawiesil sie.
echo.
echo WYNIK: SUKCES >> %LOG_FILE%

REM Sprawdz czy Notatnik zostal uruchomiony
tasklist /FI "IMAGENAME eq notepad.exe" 2>nul | find /I "notepad.exe" >nul
if %ERRORLEVEL%==0 (
    echo [INFO] Notatnik zostal uruchomiony przez test
    echo Notatnik uruchomiony >> %LOG_FILE%
)

:END
echo.
echo [%date% %time%] KONIEC TESTU >> %LOG_FILE%
echo.
echo Wynik zapisany do: %LOG_FILE%
echo.
type %LOG_FILE%
echo.
echo ============================================
pause
