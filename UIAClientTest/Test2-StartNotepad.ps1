# Test Etap 2: Uruchomienie Notatnika
Write-Host "=== ETAP 2: Uruchomienie Notatnika ===" -ForegroundColor Cyan
Write-Host ""

Write-Host "Zamykam istniej¹ce instancje Notatnika..." -ForegroundColor Yellow
Get-Process notepad -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1

Write-Host "Uruchamiam Notatnik..." -ForegroundColor Yellow
$notepad = Start-Process notepad.exe -PassThru
Start-Sleep -Seconds 2

if ($notepad -ne $null -and -not $notepad.HasExited) {
    Write-Host "? Notatnik uruchomiony (PID: $($notepad.Id))" -ForegroundColor Green
    Write-Host "? Handle okna: $($notepad.MainWindowHandle)" -ForegroundColor Green
    Write-Host "? Tytu³ okna: $($notepad.MainWindowTitle)" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "UWAGA: Notatnik pozostaje uruchomiony dla kolejnego testu!" -ForegroundColor Yellow
    Write-Host "Aby zamkn¹æ: Get-Process notepad | Stop-Process" -ForegroundColor Yellow
} else {
    Write-Host "? B³¹d uruchamiania Notatnika!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Etap 2 zakoñczony pomyœlnie!" -ForegroundColor Green
