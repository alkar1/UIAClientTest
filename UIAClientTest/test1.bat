@echo off
echo === TEST 1: Kompilacja ===
cd /d "%~dp0"
dotnet build --nologo -v minimal
if %ERRORLEVEL% EQU 0 (
    echo [OK] Kompilacja udana
    exit /b 0
) else (
    echo [BLAD] Kompilacja nieudana
    exit /b 1
)
