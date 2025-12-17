@echo off
echo === TEST 3: Uruchom aplikacje w trybie auto ===
cd /d "%~dp0"

set EXE=bin\Debug\net8.0-windows\UIAClientTest.exe

if not exist "%EXE%" (
    echo [BLAD] Plik nie istnieje: %EXE%
    echo Najpierw uruchom test1.bat
    exit /b 1
)

echo Uruchamiam aplikacje...
"%EXE%" --auto

if %ERRORLEVEL% EQU 0 (
    echo [OK] Aplikacja zakonczona pomyslnie
    exit /b 0
) else (
    echo [BLAD] Aplikacja zwrocila blad: %ERRORLEVEL%
    exit /b 1
)
