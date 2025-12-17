# Test Etap 4: Weryfikacja zawartoœci Notatnika
Write-Host "=== ETAP 4: Weryfikacja zawartoœci ===" -ForegroundColor Cyan
Write-Host ""

# SprawdŸ czy Notatnik jest uruchomiony
$notepad = Get-Process notepad -ErrorAction SilentlyContinue | Select-Object -First 1

if ($notepad -eq $null) {
    Write-Host "? Notatnik nie jest uruchomiony!" -ForegroundColor Red
    exit 1
}

Write-Host "Odczytujê zawartoœæ Notatnika przy u¿yciu UI Automation..." -ForegroundColor Yellow

Add-Type -AssemblyName UIAutomationClient
Add-Type -AssemblyName UIAutomationTypes

try {
    $notepadWindow = [System.Windows.Automation.AutomationElement]::FromHandle($notepad.MainWindowHandle)
    Write-Host "? Po³¹czono z oknem Notatnika" -ForegroundColor Green
    
    # Szukaj kontrolki Edit
    $editCondition = New-Object System.Windows.Automation.PropertyCondition(
        [System.Windows.Automation.AutomationElement]::ControlTypeProperty,
        [System.Windows.Automation.ControlType]::Edit
    )
    
    $editControl = $notepadWindow.FindFirst([System.Windows.Automation.TreeScope]::Descendants, $editCondition)
    
    # Jeœli nie znaleziono, szukaj Document
    if ($editControl -eq $null) {
        Write-Host "Kontrolka Edit nie znaleziona, szukam Document..." -ForegroundColor Gray
        $docCondition = New-Object System.Windows.Automation.PropertyCondition(
            [System.Windows.Automation.AutomationElement]::ControlTypeProperty,
            [System.Windows.Automation.ControlType]::Document
        )
        $editControl = $notepadWindow.FindFirst([System.Windows.Automation.TreeScope]::Descendants, $docCondition)
    }
    
    if ($editControl -ne $null) {
        Write-Host "? Znaleziono kontrolkê edycji" -ForegroundColor Green
        
        $valuePattern = $editControl.GetCurrentPattern([System.Windows.Automation.ValuePattern]::Pattern)
        $text = $valuePattern.Current.Value
        
        Write-Host ""
        Write-Host "=== ZAWARTOŒÆ NOTATNIKA ===" -ForegroundColor Cyan
        Write-Host $text -ForegroundColor White
        Write-Host "===========================" -ForegroundColor Cyan
        Write-Host ""
        
        # SprawdŸ czy tekst zosta³ wpisany
        $expectedText = "Witaj œwiecie!"
        if ($text -like "*$expectedText*") {
            Write-Host "? TEST POMYŒLNY: Tekst zosta³ poprawnie wpisany!" -ForegroundColor Green
            $testResult = 0
        } else {
            Write-Host "? TEST NIEUDANY: Oczekiwany tekst nie zosta³ znaleziony!" -ForegroundColor Red
            Write-Host "Oczekiwano fragmentu: '$expectedText'" -ForegroundColor Yellow
            $testResult = 1
        }
    } else {
        Write-Host "? Nie mo¿na znaleŸæ kontrolki edycji!" -ForegroundColor Red
        $testResult = 1
    }
} catch {
    Write-Host "? B³¹d podczas weryfikacji: $_" -ForegroundColor Red
    $testResult = 1
}

Write-Host ""
Write-Host "Etap 4 zakoñczony!" -ForegroundColor Green
exit $testResult
