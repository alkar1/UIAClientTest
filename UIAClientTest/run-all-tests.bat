@echo off
echo ========================================
echo  PELNY TEST AUTOMATYCZNY
echo ========================================
echo.

cd /d "%~dp0"

echo [1/5] Test kompilacji...
call test1.bat
if %ERRORLEVEL% NEQ 0 goto :error
echo.

echo [2/5] Sprawdzenie pliku exe...
call test4-check-exe.bat
if %ERRORLEVEL% NEQ 0 goto :error
echo.

echo [3/5] Uruchomienie Notatnika...
call test2.bat
if %ERRORLEVEL% NEQ 0 goto :error
echo.

echo [4/5] Uruchomienie aplikacji UIA...
call test3.bat
if %ERRORLEVEL% NEQ 0 goto :error
echo.

echo [5/5] Czyszczenie...
call test5-cleanup.bat
echo.

echo ========================================
echo  WSZYSTKIE TESTY ZAKONCZONE SUKCESEM!
echo ========================================
exit /b 0

:error
echo.
echo ========================================
echo  TEST NIEUDANY!
echo ========================================
exit /b 1
