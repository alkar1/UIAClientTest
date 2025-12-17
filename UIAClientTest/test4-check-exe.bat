@echo off
echo === TEST 4: Sprawdz czy plik exe istnieje ===
cd /d "%~dp0"

set EXE=bin\Debug\net8.0-windows\UIAClientTest.exe

if exist "%EXE%" (
    echo [OK] Plik istnieje: %EXE%
    dir "%EXE%"
    exit /b 0
) else (
    echo [BLAD] Plik nie istnieje: %EXE%
    exit /b 1
)
