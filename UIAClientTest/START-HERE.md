# STARTUJ TUTAJ - Instrukcja testowania

## Najprostszy sposÛb - JEDNA KOMENDA:

```cmd
run-all-tests.bat
```

To wykona wszystkie testy automatycznie i pokaøe wynik.

---

## Jeúli powyøsze nie dzia≥a - testuj krok po kroku:

### KROK 1: Kompilacja
```cmd
test1.bat
```
Powinno pokazaÊ: `[OK] Kompilacja udana`

### KROK 2: Sprawdü czy exe istnieje
```cmd
test4-check-exe.bat
```
Powinno pokazaÊ úcieøkÍ do pliku exe.

### KROK 3: Uruchom Notatnik
```cmd
test2.bat
```
Powinno pokazaÊ: `[OK] Notatnik uruchomiony`
**NOTATNIK POWINIEN BY∆ WIDOCZNY NA EKRANIE!**

### KROK 4: Uruchom aplikacjÍ UIA
```cmd
test3.bat
```
Powinno pokazaÊ:
- `Znaleziono Notatnik`
- `Znaleziono pole edycji tekstu`
- `Pomyúlnie wpisano tekst`
- `[OK] Aplikacja zakonczona pomyslnie`

**SPRAWDè NOTATNIK - POWINIEN ZAWIERA∆ TEKST!**

### KROK 5: Posprzπtaj
```cmd
test5-cleanup.bat
```
Zamyka Notatnik.

---

## Co sprawdza kaødy test?

| Test | Plik | Co robi |
|------|------|---------|
| 1 | test1.bat | Kompiluje projekt C# |
| 2 | test2.bat | Uruchamia Notatnik |
| 3 | test3.bat | Uruchamia aplikacjÍ UIA ktÛra wpisuje tekst |
| 4 | test4-check-exe.bat | Sprawdza czy plik exe zosta≥ utworzony |
| 5 | test5-cleanup.bat | Zamyka Notatnik |

---

## Oczekiwany rezultat koÒcowy:

Po test3.bat Notatnik powinien zawieraÊ:
```
Witaj úwiecie!
To jest test Microsoft UI Automation.
Dzia≥a poprawnie! ??
```

---

## Problemy?

**"B≥πd kompilacji"**
- Sprawdü: `dotnet --version` (potrzebujesz .NET 8.0+)

**"Notatnik nie jest uruchomiony"**
- RÍcznie uruchom Notatnik przed test3.bat

**"Nie moøna znaleüÊ pola edycji"**
- To moøe byÊ problem z wersjπ Notatnika
- Aplikacja prÛbuje 2 metody (Edit i Document)

**"Tekst nie zosta≥ wpisany"**
- Sprawdü czy Notatnik jest na wierzchu (nie zminimalizowany)
- Sprawdü output w konsoli - aplikacja pokazuje co robi

---

## Szybkie debugowanie:

```cmd
REM Zobacz co wypisuje aplikacja:
bin\Debug\net8.0-windows\UIAClientTest.exe --auto

REM Lub w trybie interaktywnym (czeka na Enter):
bin\Debug\net8.0-windows\UIAClientTest.exe
```

---

## UWAGA: Pliki .ps1 mogπ siÍ zawieszaÊ!

Uøywaj plikÛw **.bat** - sπ bardziej niezawodne:
- ? test1.bat, test2.bat, test3.bat...
- ? Test1-Build.ps1, SimpleTest.ps1... (mogπ siÍ zawiesiÊ)
