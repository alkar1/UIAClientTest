# Szybki test - UIAClientTest + Monitor
# Kompiluje oba projekty, zamyka Notatnik i uruchamia monitor

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " SZYBKI TEST - UIAClientTest + Monitor" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Krok 1: Budowanie
Write-Host "[1/3] Budowanie projektów..." -ForegroundColor Yellow
$buildOutput = dotnet build --configuration Debug 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "? B£¥D kompilacji!" -ForegroundColor Red
    Write-Host $buildOutput
    Read-Host "Naciœnij Enter"
    exit 1
}

Write-Host "? Kompilacja zakoñczona pomyœlnie" -ForegroundColor Green
Write-Host ""

# Krok 2: Zamykanie Notatnika
Write-Host "[2/3] Zamykanie Notatnika..." -ForegroundColor Yellow
$notepadProcs = Get-Process notepad -ErrorAction SilentlyContinue
if ($notepadProcs) {
    $notepadProcs | Stop-Process -Force
    Write-Host "? Notatnik zamkniêty" -ForegroundColor Green
} else {
    Write-Host "? Notatnik nie by³ uruchomiony" -ForegroundColor Green
}
Start-Sleep -Seconds 1
Write-Host ""

# Krok 3: Uruchomienie monitora
Write-Host "[3/3] Uruchamianie monitora (timeout: 15s)..." -ForegroundColor Yellow
Write-Host ""

& "UIAClientTest.Monitor\bin\Debug\net8.0-windows\UIAClientTest.Monitor.exe" 15
