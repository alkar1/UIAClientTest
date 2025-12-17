# Prosty test - tylko kompilacja i uruchomienie
Write-Host "=== PROSTY TEST ===" -ForegroundColor Cyan
Write-Host ""

# Krok 1: Kompilacja
Write-Host "[1/3] Kompilowanie..." -ForegroundColor Yellow
cd $PSScriptRoot
dotnet build --nologo -v q
if ($LASTEXITCODE -ne 0) {
    Write-Host "? Kompilacja nieudana!" -ForegroundColor Red
    exit 1
}
Write-Host "? Kompilacja OK" -ForegroundColor Green
Write-Host ""

# Krok 2: Uruchom Notatnik
Write-Host "[2/3] Uruchamianie Notatnika..." -ForegroundColor Yellow
Get-Process notepad -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1
$notepad = Start-Process notepad.exe -PassThru
Start-Sleep -Seconds 2
Write-Host "? Notatnik uruchomiony (PID: $($notepad.Id))" -ForegroundColor Green
Write-Host ""

# Krok 3: Uruchom aplikacjê
Write-Host "[3/3] Uruchamianie aplikacji..." -ForegroundColor Yellow
$exePath = ".\bin\Debug\net8.0-windows\UIAClientTest.exe"

Start-Process -FilePath $exePath -ArgumentList "--auto" -Wait -NoNewWindow

Write-Host "? Aplikacja zakoñczona" -ForegroundColor Green
Write-Host ""

# SprawdŸ rezultat
Write-Host "=== SPRAWDZAM NOTATNIK ===" -ForegroundColor Cyan
Start-Sleep -Seconds 1

Add-Type -AssemblyName UIAutomationClient
Add-Type -AssemblyName UIAutomationTypes

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
    
    Write-Host "Zawartoœæ:" -ForegroundColor Cyan
    Write-Host $text -ForegroundColor White
    Write-Host ""
    
    if ($text -like "*Witaj œwiecie!*") {
        Write-Host "??? TEST POMYŒLNY! ???" -ForegroundColor Green
    } else {
        Write-Host "??? TEST NIEUDANY! ???" -ForegroundColor Red
    }
} else {
    Write-Host "? Nie mo¿na odczytaæ zawartoœci" -ForegroundColor Red
}

Write-Host ""
Write-Host "Zamykam Notatnik..." -ForegroundColor Gray
$notepad | Stop-Process -Force -ErrorAction SilentlyContinue
Write-Host "Gotowe!" -ForegroundColor Green
