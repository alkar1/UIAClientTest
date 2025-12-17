# UIAClientTest Monitor - Skrypt PowerShell
# Buduje i uruchamia program monitoruj¹cy

Write-Host "===================================" -ForegroundColor Cyan
Write-Host " UIAClientTest Monitor - Uruchomienie" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""

# Parametr timeout (domyœlnie 10 sekund)
$timeout = 10
if ($args.Count -gt 0) {
    $timeout = [int]$args[0]
}

# Budowanie projektu Monitor
Write-Host "[1/3] Budowanie UIAClientTest.Monitor..." -ForegroundColor Yellow
$buildResult = dotnet build "UIAClientTest.Monitor\UIAClientTest.Monitor.csproj" --configuration Debug 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "B£¥D: Nie uda³o siê zbudowaæ projektu Monitor" -ForegroundColor Red
    Write-Host $buildResult
    Read-Host "Naciœnij Enter aby zakoñczyæ"
    exit 1
}

Write-Host "? Kompilacja zakoñczona pomyœlnie" -ForegroundColor Green
Write-Host ""

# Sprawdzenie czy UIAClientTest.exe istnieje
Write-Host "[2/3] Sprawdzanie UIAClientTest.exe..." -ForegroundColor Yellow
$uiaPath = "UIAClientTest\bin\Debug\net8.0-windows\UIAClientTest.exe"

if (Test-Path $uiaPath) {
    Write-Host "? Znaleziono UIAClientTest.exe" -ForegroundColor Green
} else {
    Write-Host "? UIAClientTest.exe nie istnieje - budujê..." -ForegroundColor Yellow
    dotnet build "UIAClientTest\UIAClientTest.csproj" --configuration Debug | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "? UIAClientTest zbudowany" -ForegroundColor Green
    }
}

Write-Host ""

# Uruchamianie monitora
Write-Host "[3/3] Uruchamianie monitora (timeout: $timeout s)..." -ForegroundColor Yellow
Write-Host ""

& "UIAClientTest.Monitor\bin\Debug\net8.0-windows\UIAClientTest.Monitor.exe" $timeout
