# Test Etap 1: Kompilacja
Write-Host "=== ETAP 1: Kompilacja ===" -ForegroundColor Cyan
Write-Host ""

$projectPath = Join-Path $PSScriptRoot "UIAClientTest.csproj"

Write-Host "Kompilowanie projektu..." -ForegroundColor Yellow
$buildOutput = dotnet build $projectPath 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "? Kompilacja zakoñczona sukcesem" -ForegroundColor Green
    
    $exePath = Join-Path $PSScriptRoot "bin\Debug\net8.0-windows\UIAClientTest.exe"
    if (Test-Path $exePath) {
        Write-Host "? Plik wykonywalny utworzony: $exePath" -ForegroundColor Green
    } else {
        Write-Host "? Brak pliku wykonywalnego!" -ForegroundColor Red
    }
} else {
    Write-Host "? B³¹d kompilacji:" -ForegroundColor Red
    Write-Host $buildOutput -ForegroundColor Gray
    exit 1
}

Write-Host ""
Write-Host "Etap 1 zakoñczony pomyœlnie!" -ForegroundColor Green
