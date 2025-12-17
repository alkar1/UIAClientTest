# G³ówny skrypt uruchamiaj¹cy wszystkie testy
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  AUTOMATYCZNY TEST KLIENTA UIA" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$scriptPath = $PSScriptRoot
$allPassed = $true

# Etap 1: Kompilacja
Write-Host ""
& "$scriptPath\Test1-Build.ps1"
if ($LASTEXITCODE -ne 0) { 
    Write-Host "? Etap 1 nieudany!" -ForegroundColor Red
    exit 1 
}

# Etap 2: Uruchomienie Notatnika
Write-Host ""
& "$scriptPath\Test2-StartNotepad.ps1"
if ($LASTEXITCODE -ne 0) { 
    Write-Host "? Etap 2 nieudany!" -ForegroundColor Red
    exit 1 
}

# Etap 3: Uruchomienie aplikacji
Write-Host ""
& "$scriptPath\Test3-RunApp.ps1"
if ($LASTEXITCODE -ne 0) { 
    Write-Host "? Etap 3 z ostrze¿eniami" -ForegroundColor Yellow
}

# Czekaj chwilê na zakoñczenie dzia³ania aplikacji
Start-Sleep -Seconds 2

# Etap 4: Weryfikacja
Write-Host ""
& "$scriptPath\Test4-Verify.ps1"
if ($LASTEXITCODE -ne 0) { 
    Write-Host "? Etap 4 nieudany!" -ForegroundColor Red
    $allPassed = $false
}

# Etap 5: Czyszczenie
Write-Host ""
& "$scriptPath\Test5-Cleanup.ps1"

# Podsumowanie
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
if ($allPassed) {
    Write-Host "  ? WSZYSTKIE TESTY ZAKOÑCZONE SUKCESEM" -ForegroundColor Green
} else {
    Write-Host "  ? TESTY NIEUDANE" -ForegroundColor Red
}
Write-Host "========================================" -ForegroundColor Cyan

exit $(if ($allPassed) { 0 } else { 1 })
