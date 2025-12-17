# ?? INSTRUKCJA TESTOWANIA - UIAClientTest z Monitorem

## ? Status projektu: GOTOWY DO TESTOWANIA

---

## ?? Najszybszy sposób (1 komenda)

### Windows CMD:
```cmd
quick-test-monitor.bat
```

### PowerShell:
```powershell
.\quick-test-monitor.ps1
```

**To polecenie automatycznie:**
1. ? Kompiluje oba projekty
2. ? Zamyka Notatnik (czysty start)
3. ? Uruchamia Monitor z timeoutem 15 sekund
4. ? Monitor uruchamia UIAClientTest --auto
5. ? Pokazuje szczegó³owe wyniki

---

## ?? Co Monitor testuje

### Test 1: Stan pocz¹tkowy
```
Test 1: Sprawdzanie stanu Notatnika...
? Notatnik nie jest uruchomiony
```
Lub:
```
? Notatnik ju¿ uruchomiony (PID: 12345)
```

### Test 2: Uruchomienie UIAClientTest
Monitor uruchamia `UIAClientTest.exe --auto` i monitoruje:
- Ka¿d¹ liniê wyjœcia (na ¿ywo)
- Czas wykonania
- Kod wyjœcia
- Czy program siê zawiesi (timeout)

### Test 3: Stan koñcowy
```
Test 3: Stan Notatnika po wykonaniu...
? Notatnik dzia³a (PID: 12345)
? Notatnik zosta³ uruchomiony przez UIAClientTest
```

---

## ?? Mo¿liwe wyniki

### ? SUKCES - Program dzia³a poprawnie
```
==================================================
WYNIKI TESTU:
==================================================
? SUKCES: Program zakoñczy³ siê poprawnie
  Czas wykonania: 3.45s
```

**Co to oznacza:**
- UIAClientTest uruchomi³ Notatnik
- Znalaz³ pole edycji
- Wpisa³ tekst
- Zakoñczy³ siê bez b³êdów

---

### ?? TIMEOUT - Program siê zawiesi³
```
==================================================
WYNIKI TESTU:
==================================================
? TIMEOUT: Program nie zakoñczy³ siê w 15 sekund

Mo¿liwe przyczyny:
  - Program zawiesi³ siê na SetFocus()
  - Notatnik nie otrzyma³ fokusa
  - Program czeka na Enter (nie u¿ywa --auto)
```

**Co to oznacza:**
- Program zawiesi³ siê podczas wykonywania
- Najczêœciej na `SetFocus()` - znany problem Windows UI Automation
- Monitor automatycznie zabi³ zawieszony proces

**Co zrobiæ:**
1. Zobacz WYJŒCIE PROGRAMU - znajdŸ ostatni¹ liniê przed zawieszeniem
2. SprawdŸ czy Notatnik jest widoczny (nie zminimalizowany)
3. Spróbuj z d³u¿szym timeoutem:
   ```powershell
   .\run-monitor.ps1 30
   ```

---

### ? B£¥D - Program zwróci³ b³¹d
```
==================================================
WYNIKI TESTU:
==================================================
? B£¥D: Program zakoñczy³ siê z kodem: 1
  Czas wykonania: 2.15s

B£ÊDY:
--------------------------------------------------
Wyst¹pi³ b³¹d: Nie mo¿na ustawiæ fokusu...
--------------------------------------------------
```

**Co to oznacza:**
- Program napotka³ wyj¹tek i zakoñczy³ siê
- Zobacz sekcjê B£ÊDY aby zobaczyæ szczegó³y

---

## ?? Ró¿ne sposoby testowania

### 1. Szybki test kompletny (ZALECANE)
```cmd
quick-test-monitor.bat
```
? Najlepsze do codziennego testowania

### 2. Monitor z domyœlnym timeoutem (10s)
```cmd
run-monitor.bat
```
? Zak³ada ¿e projekty s¹ ju¿ zbudowane

### 3. Monitor z customowym timeoutem (PowerShell)
```powershell
# 20 sekund
.\run-monitor.ps1 20

# 30 sekund
.\run-monitor.ps1 30
```
? Przydatne dla wolniejszych systemów

### 4. Bezpoœrednie uruchomienie exe
```cmd
UIAClientTest.Monitor\bin\Debug\net8.0-windows\UIAClientTest.Monitor.exe 15
```
? Dla zaawansowanych u¿ytkowników

### 5. Demo interaktywne
```cmd
demo-monitor.bat
```
? Przewodnik krok po kroku

---

## ?? Rozwi¹zywanie problemów

### Problem: "Nie znaleziono UIAClientTest.exe"
**Rozwi¹zanie:**
```cmd
quick-test-monitor.bat
```
Ten skrypt automatycznie zbuduje projekty.

Lub rêcznie:
```cmd
dotnet build UIAClientTest\UIAClientTest.csproj
```

---

### Problem: Monitor zawsze pokazuje timeout
**Mo¿liwe przyczyny i rozwi¹zania:**

1. **UIAClientTest zawiesza siê na SetFocus()**
   - To znany problem Windows UI Automation
   - Notatnik musi byæ w pierwszym planie
   - Zobacz wyjœcie programu - ostatnia linia przed timeoutem

2. **Timeout za krótki**
   ```powershell
   .\run-monitor.ps1 30  # Spróbuj d³u¿szy timeout
   ```

3. **Notatnik zminimalizowany**
   - Upewnij siê ¿e Notatnik jest widoczny
   - Nie minimalizuj okna podczas testu

---

### Problem: Skrypty PowerShell nie dzia³aj¹
**Rozwi¹zanie:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Lub u¿yj wersji .bat:
```cmd
quick-test-monitor.bat
run-monitor.bat
```

---

### Problem: "Program has more than one entry point"
To by³o rozwi¹zane przez `<StartupObject>` w .csproj.
Jeœli wystêpuje, przebuduj:
```cmd
dotnet clean
dotnet build
```

---

## ?? Dokumentacja

| Plik | Opis |
|------|------|
| **START-MONITOR.md** | ?? Szybki przewodnik - jak zacz¹æ |
| **MONITOR-SUMMARY.md** | ?? Podsumowanie projektu Monitor |
| **TEST-RESULTS.md** | ?? Wyniki testów i przyk³ady |
| **UIAClientTest.Monitor/README.md** | ?? Pe³na dokumentacja (180 linii) |
| **UIAClientTest/README.md** | ?? G³ówna dokumentacja (zaktualizowana) |

---

## ?? Przyk³ad - Typowy scenariusz testowania

### Krok 1: Uruchom szybki test
```cmd
C:\PROJ\VS2026\UIAClientTest> quick-test-monitor.bat
```

### Krok 2: Zobacz wyniki
```
========================================
 SZYBKI TEST - UIAClientTest + Monitor
========================================

[1/3] Budowanie projektów...
? Kompilacja zakoñczona pomyœlnie

[2/3] Zamykanie Notatnika...
? Notatnik zamkniêty

[3/3] Uruchamianie monitora (timeout: 15s)...

=== UIAClientTest Monitor ===
Program monitoruj¹cy dzia³anie UIAClientTest

Timeout: 15 sekund
==================================================

? Znaleziono: C:\...\UIAClientTest.exe

Test 1: Sprawdzanie stanu Notatnika...
? Notatnik nie jest uruchomiony

Test 2: Uruchamianie UIAClientTest (timeout: 15s)...
  > Uruchamianie klienta Microsoft UI Automation...
  > Szukam Notatnika (notepad.exe)...
  > Notatnik nie jest uruchomiony. Uruchamiam Notatnik...
  > Znaleziono Notatnik (PID: 12345)
  > Tytu³ okna: Bez tytu³u — Notatnik
  > Znaleziono pole edycji tekstu.
  > U¿ywam ValuePattern do wpisania tekstu...
Czekam na zakoñczenie.........

? Timeout - zabijam proces...

==================================================
WYNIKI TESTU:
==================================================
? TIMEOUT: Program nie zakoñczy³ siê w 15 sekund

Mo¿liwe przyczyny:
  - Program zawiesi³ siê na SetFocus()  ? Tu jest problem!
  - Notatnik nie otrzyma³ fokusa
  - Program czeka na Enter (nie u¿ywa --auto)
```

### Krok 3: Analiza
Z wyjœcia widaæ ¿e:
- ? Notatnik zosta³ uruchomiony
- ? Pole edycji zosta³o znalezione
- ? Program próbowa³ u¿yæ ValuePattern
- ? **Zawieszenie po "U¿ywam ValuePattern..."**

**Wniosek:** Program zawiesza siê na `SetFocus()` lub `SetValue()`

---

## ? Podsumowanie

### Monitor zosta³ utworzony aby:
1. ? **Wykrywaæ zawieszenia** - automatyczny timeout
2. ? **Pokazywaæ gdzie wisi** - widzisz ostatni¹ liniê
3. ? **Raportowaæ wyniki** - sukces/b³¹d/timeout
4. ? **Monitorowaæ œrodowisko** - stan Notatnika
5. ? **Oszczêdzaæ czas** - nie musisz rêcznie zabijaæ procesu

### Gotowy do testowania!

Uruchom pierwszy test:
```cmd
quick-test-monitor.bat
```

**Powodzenia!** ??

---

**Utworzono:** Grudzieñ 2024  
**Wersja:** 1.0  
**.NET:** 8.0  
**Status:** ? GOTOWY DO U¯YCIA
