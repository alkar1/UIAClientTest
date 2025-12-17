# Test Etap 5: Czyszczenie
Write-Host "=== ETAP 5: Czyszczenie ===" -ForegroundColor Cyan
Write-Host ""

Write-Host "Zamykam wszystkie instancje Notatnika..." -ForegroundColor Yellow
$notepadProcesses = Get-Process notepad -ErrorAction SilentlyContinue

if ($notepadProcesses) {
    $notepadProcesses | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1
    Write-Host "? Notatnik zamkniêty" -ForegroundColor Green
} else {
    Write-Host "? Brak uruchomionych instancji Notatnika" -ForegroundColor Green
}

Write-Host ""
Write-Host "Etap 5 zakoñczony!" -ForegroundColor Green
