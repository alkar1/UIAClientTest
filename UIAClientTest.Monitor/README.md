# UIAClientTest.Monitor

## ?? Opis

Program monitoruj¹cy s³u¿¹cy do testowania i diagnostyki **UIAClientTest**. Monitor uruchamia aplikacjê g³ówn¹ z timeoutem i raportuje szczegó³owe wyniki, w tym:

- ? Stan wykonania (sukces/b³¹d/timeout)
- ?? Czas wykonania
- ?? Pe³ne wyjœcie programu
- ?? B³êdy i wyj¹tki
- ?? Stan Notatnika przed i po teœcie

## ?? Jak u¿ywaæ

### Szybkie uruchomienie

```powershell
# Windows CMD
run-monitor.bat

# PowerShell
.\run-monitor.ps1
```

### Z niestandardowym timeoutem

```powershell
# PowerShell - timeout 15 sekund
.\run-monitor.ps1 15

# Bezpoœrednio exe
UIAClientTest.Monitor\bin\Debug\net8.0-windows\UIAClientTest.Monitor.exe 20
```

## ?? Co robi Monitor?

### Test 1: Stan pocz¹tkowy Notatnika
Sprawdza czy Notatnik jest ju¿ uruchomiony przed testem

### Test 2: Uruchomienie UIAClientTest
- Uruchamia UIAClientTest.exe z argumentem `--auto`
- Monitoruje wyjœcie w czasie rzeczywistym
- Wymusza zakoñczenie po przekroczeniu timeoutu
- Przechwytuje kod wyjœcia

### Test 3: Stan koñcowy Notatnika
Sprawdza czy Notatnik pozosta³ uruchomiony po teœcie

## ?? Przyk³adowe wyjœcie

```
=== UIAClientTest Monitor ===
Program monitoruj¹cy dzia³anie UIAClientTest

Timeout: 10 sekund
==================================================

? Znaleziono: C:\...\UIAClientTest.exe

Test 1: Sprawdzanie stanu Notatnika...
? Notatnik nie jest uruchomiony

Test 2: Uruchamianie UIAClientTest (timeout: 10s)...
  > Uruchamianie klienta Microsoft UI Automation...
  > Szukam Notatnika (notepad.exe)...
  > ...
Czekam na zakoñczenie....

==================================================
WYNIKI TESTU:
==================================================
? SUKCES: Program zakoñczy³ siê poprawnie
  Czas wykonania: 3.45s

WYJŒCIE PROGRAMU:
--------------------------------------------------
[pe³ne wyjœcie programu]
--------------------------------------------------

Test 3: Stan Notatnika po wykonaniu...
? Notatnik dzia³a (PID: 12345)
? Notatnik zosta³ uruchomiony przez UIAClientTest

==================================================
Naciœnij Enter aby zakoñczyæ...
```

## ? Wykrywanie problemów

### Timeout
```
? TIMEOUT: Program nie zakoñczy³ siê w 10 sekund

Mo¿liwe przyczyny:
  - Program zawiesi³ siê na SetFocus()
  - Notatnik nie otrzyma³ fokusa
  - Program czeka na Enter (nie u¿ywa --auto)
```

### B³¹d wykonania
```
? B£¥D: Program zakoñczy³ siê z kodem: 1
  Czas wykonania: 2.15s

B£ÊDY:
--------------------------------------------------
Wyst¹pi³ b³¹d: Nie mo¿na ustawiæ fokusu...
--------------------------------------------------
```

## ??? Budowanie

```powershell
# Budowanie tylko Monitor
dotnet build UIAClientTest.Monitor\UIAClientTest.Monitor.csproj

# Budowanie ca³ego solution (obu projektów)
dotnet build
```

## ?? Struktura plików

```
UIAClientTest.Monitor/
??? Program.cs                    # G³ówna logika monitora
??? UIAClientTest.Monitor.csproj  # Plik projektu
??? bin/Debug/net8.0-windows/
    ??? UIAClientTest.Monitor.exe # Skompilowany program
```

## ?? Konfiguracja

### Domyœlny timeout
Domyœlnie: **10 sekund**

Mo¿na zmieniæ przekazuj¹c argument:
```powershell
UIAClientTest.Monitor.exe 30  # 30 sekund
```

### Szukane œcie¿ki UIAClientTest.exe

Monitor szuka pliku w nastêpuj¹cej kolejnoœci:
1. `..\UIAClientTest\bin\Debug\net8.0-windows\UIAClientTest.exe`
2. `..\bin\Debug\net8.0-windows\UIAClientTest.exe`
3. `UIAClientTest\bin\Debug\net8.0-windows\UIAClientTest.exe`

## ?? Zastosowania

### 1. Automatyczne testy CI/CD
```powershell
# Uruchom monitor i sprawdŸ kod wyjœcia
.\run-monitor.ps1 15
if ($LASTEXITCODE -eq 0) {
    Write-Host "Test passed"
} else {
    Write-Host "Test failed"
    exit 1
}
```

### 2. Debugowanie zawieszeñ
Monitor pokazuje dok³adnie gdzie program siê zawiesza

### 3. Testy regresyjne
Szybko sprawdŸ czy aplikacja dalej dzia³a po zmianach

## ?? Rozwi¹zywanie problemów

### Monitor nie znajduje UIAClientTest.exe
**Rozwi¹zanie:** Najpierw zbuduj UIAClientTest
```powershell
dotnet build UIAClientTest\UIAClientTest.csproj
```

### Monitor sam siê zawiesza
**Rozwi¹zanie:** U¿yj krótszego timeoutu
```powershell
.\run-monitor.ps1 5
```

## ?? Wymagania

- .NET 8.0 SDK
- Windows 10/11
- UIAClientTest zbudowany w trybie Debug

## ?? Zalety u¿ywania Monitora

? **Automatyczna detekcja timeoutów** - nie musisz rêcznie przerywaæ zawieszonego programu

? **Pe³ne logowanie** - widzisz wszystko co dzieje siê w testowanej aplikacji

? **Raportowanie stanu** - jasne komunikaty sukces/b³¹d/timeout

? **Diagnostyka Notatnika** - sprawdza czy Notatnik zosta³ poprawnie uruchomiony

? **£atwa integracja** - prosty w u¿yciu z poziomu wiersza poleceñ

## ?? Zobacz te¿

- `README.md` - G³ówna dokumentacja UIAClientTest
- `TESTING.md` - Szczegó³y testowania
- `START-HERE.md` - Przewodnik startowy

---

**Utworzono:** Grudzieñ 2024  
**Wersja:** 1.0  
**.NET:** 8.0
