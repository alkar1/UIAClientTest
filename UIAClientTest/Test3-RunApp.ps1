# Test Etap 3: Uruchomienie aplikacji UI Automation (bez interakcji)
Write-Host "=== ETAP 3: Uruchomienie aplikacji UIA ===" -ForegroundColor Cyan
Write-Host ""

# SprawdŸ czy Notatnik jest uruchomiony
$notepad = Get-Process notepad -ErrorAction SilentlyContinue | Select-Object -First 1

if ($notepad -eq $null) {
    Write-Host "? Notatnik nie jest uruchomiony!" -ForegroundColor Red
    Write-Host "Najpierw uruchom: .\Test2-StartNotepad.ps1" -ForegroundColor Yellow
    exit 1
}

Write-Host "? Znaleziono uruchomiony Notatnik (PID: $($notepad.Id))" -ForegroundColor Green
Write-Host ""

$exePath = Join-Path $PSScriptRoot "bin\Debug\net8.0-windows\UIAClientTest.exe"

if (-not (Test-Path $exePath)) {
    Write-Host "? Brak skompilowanej aplikacji!" -ForegroundColor Red
    Write-Host "Najpierw uruchom: .\Test1-Build.ps1" -ForegroundColor Yellow
    exit 1
}

Write-Host "Uruchamiam aplikacjê UIA w trybie automatycznym..." -ForegroundColor Yellow
Write-Host ""

# Uruchom z parametrem --auto aby nie czeka³a na Enter
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $exePath
$psi.Arguments = "--auto"
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.CreateNoWindow = $false

$process = New-Object System.Diagnostics.Process
$process.StartInfo = $psi
$process.Start() | Out-Null

Write-Host "Czekam na zakoñczenie aplikacji (max 10 sekund)..." -ForegroundColor Gray

# Czytaj wyjœcie w czasie rzeczywistym
$output = ""
$timeout = 10000 # 10 sekund w milisekundach
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

while (-not $process.HasExited -and $stopwatch.ElapsedMilliseconds -lt $timeout) {
    if ($process.StandardOutput.Peek() -ge 0) {
        $line = $process.StandardOutput.ReadLine()
        Write-Host "    $line" -ForegroundColor Gray
        $output += $line + "`n"
    }
    Start-Sleep -Milliseconds 50
}

$stopwatch.Stop()

if ($process.HasExited) {
    $exitCode = $process.ExitCode
    Write-Host ""
    if ($exitCode -eq 0) {
        Write-Host "? Aplikacja zakoñczona pomyœlnie (kod: $exitCode)" -ForegroundColor Green
    } else {
        Write-Host "? Aplikacja zakoñczona z b³êdem (kod: $exitCode)" -ForegroundColor Red
        
        # Wyœwietl b³êdy jeœli s¹
        if ($process.StandardError.Peek() -ge 0) {
            $errors = $process.StandardError.ReadToEnd()
            Write-Host "B³êdy:" -ForegroundColor Red
            Write-Host $errors -ForegroundColor Red
        }
        
        exit $exitCode
    }
} else {
    Write-Host "? Aplikacja przekroczy³a limit czasu - wymuszam zakoñczenie" -ForegroundColor Yellow
    $process.Kill()
    exit 1
}

Write-Host ""
Write-Host "Etap 3 zakoñczony!" -ForegroundColor Green
Write-Host "SprawdŸ Notatnik - tekst powinien byæ wpisany." -ForegroundColor Cyan
