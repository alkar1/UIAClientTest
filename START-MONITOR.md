# ?? START-HERE: Monitor

## Najszybszy sposób na przetestowanie UIAClientTest

### ? Szybki start (1 komenda)

```powershell
# Windows CMD
quick-test-monitor.bat

# PowerShell
.\quick-test-monitor.ps1
```

To polecenie:
1. ? Buduje oba projekty (UIAClientTest + Monitor)
2. ? Zamyka wszystkie instancje Notatnika
3. ? Uruchamia Monitor z timeoutem 15 sekund
4. ? Monitor automatycznie uruchamia UIAClientTest
5. ? Raportuje szczegó³owe wyniki

---

## ?? Co to jest Monitor?

**UIAClientTest.Monitor** to narzêdzie diagnostyczne, które:
- Uruchamia UIAClientTest z automatycznym timeoutem
- Wykrywa zawieszenia i b³êdy
- Pokazuje pe³ne wyjœcie w czasie rzeczywistym
- Raportuje czy test zakoñczy³ siê sukcesem

---

## ?? Przyk³adowe u¿ycie

### Podstawowy test
```powershell
.\run-monitor.ps1
```

### Test z d³u¿szym timeoutem
```powershell
.\run-monitor.ps1 30  # 30 sekund
```

### Test bez zamykania Notatnika
```powershell
# Najpierw uruchom Notatnik rêcznie
notepad.exe

# Potem uruchom monitor
.\run-monitor.ps1
```

---

## ? Przyk³adowy sukces

```
=== UIAClientTest Monitor ===
Timeout: 15 sekund
==================================================

? Znaleziono: C:\...\UIAClientTest.exe

Test 1: Sprawdzanie stanu Notatnika...
? Notatnik nie jest uruchomiony

Test 2: Uruchamianie UIAClientTest (timeout: 15s)...
  > Uruchamianie klienta Microsoft UI Automation...
  > Znaleziono Notatnik (PID: 12345)
  > Znaleziono pole edycji tekstu.
  > U¿ywam ValuePattern do wpisania tekstu...
  > Pomyœlnie wpisano tekst

==================================================
WYNIKI TESTU:
==================================================
? SUKCES: Program zakoñczy³ siê poprawnie
  Czas wykonania: 3.45s
```

---

## ? Przyk³adowy timeout (zawieszenie)

```
=== UIAClientTest Monitor ===
Timeout: 15 sekund
==================================================

Test 2: Uruchamianie UIAClientTest (timeout: 15s)...
  > Uruchamianie klienta Microsoft UI Automation...
  > Znaleziono Notatnik (PID: 12345)
  > Znaleziono pole edycji tekstu.
  > U¿ywam ValuePattern do wpisania tekstu...
? Timeout - zabijam proces...

==================================================
WYNIKI TESTU:
==================================================
? TIMEOUT: Program nie zakoñczy³ siê w 15 sekund

Mo¿liwe przyczyny:
  - Program zawiesi³ siê na SetFocus()
  - Notatnik nie otrzyma³ fokusa
  - Program czeka na Enter (nie u¿ywa --auto)
```

---

## ??? Rozwi¹zywanie problemów

### Problem: "Nie znaleziono UIAClientTest.exe"
**Rozwi¹zanie:** U¿yj `quick-test-monitor.bat` - buduje wszystko automatycznie

### Problem: Monitor zawsze pokazuje timeout
**Mo¿liwe przyczyny:**
1. UIAClientTest zawiesza siê na `SetFocus()`
2. Notatnik jest w tle i nie mo¿e dostaæ fokusa
3. Windows blokuje dostêp do okna

**Rozwi¹zanie:**
1. Ustaw Notatnik jako aktywne okno przed testem
2. Spróbuj z d³u¿szym timeoutem: `.\run-monitor.ps1 30`
3. Zobacz pe³n¹ dokumentacjê w `UIAClientTest.Monitor\README.md`

### Problem: Notatnik nie jest uruchamiany
Monitor automatycznie uruchomi Notatnik jeœli nie jest aktywny

---

## ?? Wiêcej informacji

- **Pe³na dokumentacja Monitora:** `UIAClientTest.Monitor\README.md`
- **Dokumentacja UIAClientTest:** `UIAClientTest\README.md`
- **Przewodnik testowania:** `UIAClientTest\TESTING.md`

---

## ?? Dlaczego Monitor jest przydatny?

? **Automatyczna detekcja problemów** - od razu widzisz czy program siê zawiesi³

? **Timeout protection** - nie musisz rêcznie przerywaæ zawieszonego programu

? **Szczegó³owe logi** - widzisz ka¿dy krok wykonania

? **Stan œrodowiska** - sprawdza Notatnik przed i po teœcie

? **£atwy w u¿yciu** - jedna komenda i wszystko gotowe

---

**Gotowy do testowania? Uruchom:**
```powershell
quick-test-monitor.bat
```
