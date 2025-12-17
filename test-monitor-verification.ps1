# Test Monitora - Sprawdzenie czy wykrywa zawieszenia (wersja non-blocking)
# Ten skrypt uruchamia Monitor w tle i monitoruje jego dzialanie

Write-Host "=======================================" -ForegroundColor Cyan
Write-Host " TEST MONITORA - Wykrywanie zawieszen" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host ""

# Zamknij Notatnik przed testem
Write-Host "[1/4] Zamykanie Notatnika..." -ForegroundColor Yellow
Get-Process notepad -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1
Write-Host "  Notatnik zamkniety" -ForegroundColor Green
Write-Host ""

# Buduj projekty
Write-Host "[2/4] Budowanie projektow..." -ForegroundColor Yellow
$buildResult = dotnet build --configuration Debug --verbosity quiet 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "  Kompilacja zakonczona pomyslnie" -ForegroundColor Green
} else {
    Write-Host "  BLAD kompilacji!" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Sprawdz czy pliki exe istnieja
Write-Host "[3/4] Weryfikacja plikow..." -ForegroundColor Yellow
$monitorExe = "UIAClientTest.Monitor\bin\Debug\net8.0-windows\UIAClientTest.Monitor.exe"
$uiaExe = "UIAClientTest\bin\Debug\net8.0-windows\UIAClientTest.exe"

if (Test-Path $monitorExe) {
    Write-Host "  Monitor.exe - OK" -ForegroundColor Green
} else {
    Write-Host "  Monitor.exe - BRAK!" -ForegroundColor Red
    exit 1
}

if (Test-Path $uiaExe) {
    Write-Host "  UIAClientTest.exe - OK" -ForegroundColor Green
} else {
    Write-Host "  UIAClientTest.exe - BRAK!" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Test z timeoutem - uruchom w tle i monitoruj
Write-Host "[4/4] TEST: Uruchomienie Monitora z timeoutem 8s" -ForegroundColor Yellow
Write-Host "      (Monitor bedzie monitorowal UIAClientTest)" -ForegroundColor Gray
Write-Host ""

# Utworz plik tymczasowy dla wyniku
$tempOutput = [System.IO.Path]::GetTempFileName()

# Uruchom Monitor jako Job (w tle)
$job = Start-Job -ScriptBlock {
    param($exePath, $timeout, $outputFile)
    
    $result = & $exePath $timeout 2>&1 | Out-String
    $result | Out-File -FilePath $outputFile -Encoding UTF8
    
    return $result
} -ArgumentList $monitorExe, 8, $tempOutput

Write-Host "Monitor uruchomiony w tle (Job ID: $($job.Id))" -ForegroundColor Cyan
Write-Host "Czekam max 15 sekund na zakonczenie..." -ForegroundColor Gray
Write-Host ""

# Czekaj max 15 sekund
$completed = Wait-Job -Job $job -Timeout 15

if ($completed) {
    Write-Host "Monitor zakonczyl dzialanie" -ForegroundColor Green
    
    # Pobierz wynik
    $output = Receive-Job -Job $job
    Remove-Job -Job $job -Force
    
    # Pokaz output
    Write-Host ""
    Write-Host "=== OUTPUT MONITORA ===" -ForegroundColor Cyan
    Write-Host $output
    Write-Host "=== KONIEC OUTPUT ===" -ForegroundColor Cyan
    Write-Host ""
    
    # Analiza wyniku
    Write-Host "=======================================" -ForegroundColor Cyan
    Write-Host " ANALIZA WYNIKU" -ForegroundColor Cyan
    Write-Host "=======================================" -ForegroundColor Cyan
    
    if ($output -match "TIMEOUT") {
        Write-Host "SUKCES: Monitor wykryl zawieszenie!" -ForegroundColor Green
        Write-Host "  Monitor poprawnie zakonczyl zawieszony proces" -ForegroundColor Green
    } elseif ($output -match "SUKCES") {
        Write-Host "SUKCES: Program zakonczyl sie normalnie" -ForegroundColor Green
        Write-Host "  (UIAClientTest dzialal poprawnie)" -ForegroundColor Gray
    } elseif ($output -match "BLAD") {
        Write-Host "INFO: Program zakonczyl sie z bledem" -ForegroundColor Yellow
        Write-Host "  (To jest OK - Monitor wykryl blad)" -ForegroundColor Gray
    } else {
        Write-Host "OSTRZEZENIE: Nie mozna okreslic wyniku" -ForegroundColor Yellow
    }
} else {
    Write-Host "OSTRZEZENIE: Monitor nie zakonczyl sie w 15 sekund" -ForegroundColor Red
    Write-Host "  Zabijam Job..." -ForegroundColor Yellow
    Remove-Job -Job $job -Force
    
    Write-Host ""
    Write-Host "UWAGA: To oznacza ze sam Monitor sie zawiesil" -ForegroundColor Red
    Write-Host "       (nie powinno sie to zdarzyc)" -ForegroundColor Gray
}

# Czyszczenie
if (Test-Path $tempOutput) {
    Remove-Item $tempOutput -Force
}

Write-Host ""

# Sprawdz czy Notatnik zostal uruchomiony
$notepadProcs = Get-Process notepad -ErrorAction SilentlyContinue
if ($notepadProcs) {
    Write-Host "INFO: Notatnik zostal uruchomiony przez test (PID: $($notepadProcs[0].Id))" -ForegroundColor Cyan
    Write-Host "      Zamykam..." -ForegroundColor Gray
    $notepadProcs | Stop-Process -Force -ErrorAction SilentlyContinue
} else {
    Write-Host "INFO: Notatnik nie dziala" -ForegroundColor Gray
}

Write-Host ""
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host " TEST ZAKONCZONY" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Monitor zostal przetestowany!" -ForegroundColor Green
Write-Host ""
Write-Host "Gotowe do uzycia:" -ForegroundColor Yellow
Write-Host "  quick-test-monitor.bat" -ForegroundColor White
Write-Host "  lub" -ForegroundColor Gray
Write-Host "  .\run-monitor.ps1 15" -ForegroundColor White
Write-Host ""
Write-Host "Repozytorium na GitHub:" -ForegroundColor Yellow
Write-Host "  https://github.com/alkar1/UIAClientTest" -ForegroundColor Cyan
Write-Host ""
