@echo off
echo === QUICK TEST - Podstawowa funkcjonalnosc ===
cd /d "%~dp0"

echo Kompilowanie QuickTest...
csc /target:exe /out:QuickTest.exe /r:UIAutomationClient.dll /r:UIAutomationTypes.dll QuickTest.cs 2>nul

if exist QuickTest.exe (
    echo [OK] Kompilacja udana
    echo.
    echo Uruchamiam QuickTest...
    QuickTest.exe
    del QuickTest.exe
) else (
    echo [BLAD] Kompilacja nieudana
    echo Probuje z dotnet...
    echo.
    
    REM U¿yj g³ównej aplikacji zamiast
    if exist bin\Debug\net8.0-windows\UIAClientTest.exe (
        echo Uruchamiam glowna aplikacje w trybie test...
        bin\Debug\net8.0-windows\UIAClientTest.exe --auto
    ) else (
        echo Najpierw uruchom: test1.bat
        exit /b 1
    )
)
