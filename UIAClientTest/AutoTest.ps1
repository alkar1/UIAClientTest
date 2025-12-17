# Automatyczny test klienta UI Automation

Write-Host "=== Automatyczny Test Klienta Microsoft UI Automation ===" -ForegroundColor Cyan
Write-Host ""

# Krok 1: Zamknij wszystkie instancje Notatnika
Write-Host "[1/5] Zamykam istniej¹ce instancje Notatnika..." -ForegroundColor Yellow
Get-Process notepad -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1

# Krok 2: Uruchom Notatnik
Write-Host "[2/5] Uruchamiam Notatnik..." -ForegroundColor Yellow
$notepad = Start-Process notepad.exe -PassThru
Start-Sleep -Seconds 2

if ($notepad -eq $null -or $notepad.HasExited) {
    Write-Host "B£¥D: Nie mo¿na uruchomiæ Notatnika!" -ForegroundColor Red
    exit 1
}

Write-Host "    Notatnik uruchomiony (PID: $($notepad.Id))" -ForegroundColor Green

# Krok 3: Uruchom aplikacjê UI Automation
Write-Host "[3/5] Uruchamiam klienta UI Automation..." -ForegroundColor Yellow

$buildPath = Join-Path $PSScriptRoot "bin\Debug\net8.0-windows\UIAClientTest.exe"

if (-not (Test-Path $buildPath)) {
    Write-Host "B£¥D: Nie znaleziono skompilowanej aplikacji: $buildPath" -ForegroundColor Red
    Write-Host "Kompilowanie aplikacji..." -ForegroundColor Yellow
    dotnet build "$PSScriptRoot\UIAClientTest.csproj" | Out-Null
    Start-Sleep -Seconds 2
}

# Uruchom aplikacjê w tle i przechwytuj wyjœcie
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $buildPath
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardInput = $true
$psi.CreateNoWindow = $true

$process = New-Object System.Diagnostics.Process
$process.StartInfo = $psi
$process.Start() | Out-Null

# Czytaj wyjœcie
$output = ""
$timeout = 10
$elapsed = 0

while ($elapsed -lt $timeout -and -not $process.HasExited) {
    if ($process.StandardOutput.Peek() -ge 0) {
        $line = $process.StandardOutput.ReadLine()
        $output += $line + "`n"
        Write-Host "    $line" -ForegroundColor Gray
    }
    Start-Sleep -Milliseconds 100
    $elapsed += 0.1
}

# Zakoñcz proces (symuluj Enter)
try {
    $process.StandardInput.WriteLine()
    Start-Sleep -Milliseconds 500
    if (-not $process.HasExited) {
        $process.Kill()
    }
} catch {
    # Proces ju¿ zakoñczony
}

# Krok 4: Weryfikuj zawartoœæ Notatnika
Write-Host "[4/5] Weryfikujê zawartoœæ Notatnika..." -ForegroundColor Yellow
Start-Sleep -Seconds 1

# U¿yj UI Automation do odczytania zawartoœci
Add-Type -AssemblyName UIAutomationClient
Add-Type -AssemblyName UIAutomationTypes

try {
    $notepadWindow = [System.Windows.Automation.AutomationElement]::FromHandle($notepad.MainWindowHandle)
    
    $editCondition = New-Object System.Windows.Automation.PropertyCondition(
        [System.Windows.Automation.AutomationElement]::ControlTypeProperty,
        [System.Windows.Automation.ControlType]::Edit
    )
    
    $editControl = $notepadWindow.FindFirst([System.Windows.Automation.TreeScope]::Descendants, $editCondition)
    
    if ($editControl -eq $null) {
        $docCondition = New-Object System.Windows.Automation.PropertyCondition(
            [System.Windows.Automation.AutomationElement]::ControlTypeProperty,
            [System.Windows.Automation.ControlType]::Document
        )
        $editControl = $notepadWindow.FindFirst([System.Windows.Automation.TreeScope]::Descendants, $docCondition)
    }
    
    if ($editControl -ne $null) {
        $valuePattern = $editControl.GetCurrentPattern([System.Windows.Automation.ValuePattern]::Pattern)
        $text = $valuePattern.Current.Value
        
        Write-Host "    Zawartoœæ Notatnika:" -ForegroundColor Cyan
        Write-Host "    -------------------" -ForegroundColor Cyan
        Write-Host "    $text" -ForegroundColor White
        Write-Host "    -------------------" -ForegroundColor Cyan
        
        # SprawdŸ czy tekst zosta³ wpisany
        $expectedText = "Witaj œwiecie!"
        if ($text -like "*$expectedText*") {
            Write-Host "    ? Tekst zosta³ poprawnie wpisany!" -ForegroundColor Green
            $testPassed = $true
        } else {
            Write-Host "    ? Tekst NIE zosta³ wpisany poprawnie!" -ForegroundColor Red
            $testPassed = $false
        }
    } else {
        Write-Host "    ? Nie mo¿na znaleŸæ kontrolki edycji!" -ForegroundColor Red
        $testPassed = $false
    }
} catch {
    Write-Host "    ? B³¹d podczas weryfikacji: $_" -ForegroundColor Red
    $testPassed = $false
}

# Krok 5: Czyszczenie
Write-Host "[5/5] Czyszczenie..." -ForegroundColor Yellow
Start-Sleep -Seconds 2
Get-Process notepad -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "=== WYNIK TESTU ===" -ForegroundColor Cyan

if ($testPassed) {
    Write-Host "? TEST ZAKOÑCZONY SUKCESEM" -ForegroundColor Green
    Write-Host ""
    Write-Host "Aplikacja UI Automation dzia³a poprawnie!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "? TEST NIEUDANY" -ForegroundColor Red
    Write-Host ""
    Write-Host "Wyjœcie aplikacji:" -ForegroundColor Yellow
    Write-Host $output -ForegroundColor Gray
    exit 1
}
