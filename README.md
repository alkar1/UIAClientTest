# UIAClientTest - Microsoft UI Automation Client + Monitor

Aplikacja demonstracyjna wykorzystuj¹ca **Microsoft UI Automation API** do automatyzacji aplikacji Windows (Notatnik) + zaawansowane narzêdzie monitoruj¹ce.

## ?? Projekt sk³ada siê z dwóch czêœci

### 1. UIAClientTest
G³ówna aplikacja demonstruj¹ca UI Automation API
- Automatyczne uruchamianie Notatnika
- Wyszukiwanie kontrolek UI
- Wpisywanie tekstu przez ValuePattern lub SendKeys

### 2. UIAClientTest.Monitor (? NOWE!)
Narzêdzie diagnostyczne i testowe
- ? Uruchamia UIAClientTest z automatycznym timeoutem
- ? Wykrywa zawieszenia programu
- ? Raportuje szczegó³owe wyniki
- ? Monitoruje stan Notatnika

## ?? Szybki start

```cmd
quick-test-monitor.bat
```

To polecenie automatycznie:
1. Buduje oba projekty
2. Zamyka Notatnik (czysty start)
3. Uruchamia Monitor z timeoutem 15s
4. Pokazuje szczegó³owe wyniki

## ?? Dokumentacja

| Plik | Opis |
|------|------|
| **INSTRUKCJA-TESTOWANIA.md** | ???? Kompletna instrukcja po polsku |
| **START-MONITOR.md** | ?? Szybki przewodnik u¿ycia Monitor |
| **UIAClientTest/README.md** | ?? Dokumentacja g³ównej aplikacji |
| **UIAClientTest.Monitor/README.md** | ?? Pe³na dokumentacja Monitor |

## ?? Wymagania

- .NET 8.0 SDK
- Windows 10/11
- Visual Studio 2022 (opcjonalnie)

## ?? Struktura projektu

```
UIAClientTest/
??? UIAClientTest/              # G³ówna aplikacja UI Automation
?   ??? Program.cs
?   ??? UIAClientTest.csproj
?   ??? README.md
?
??? UIAClientTest.Monitor/      # Narzêdzie monitoruj¹ce
?   ??? Program.cs
?   ??? UIAClientTest.Monitor.csproj
?   ??? README.md
?
??? quick-test-monitor.bat      # Szybki test (zalecane)
??? run-monitor.bat             # Uruchom tylko monitor
??? demo-monitor.bat            # Interaktywne demo
?
??? Dokumentacja/
    ??? INSTRUKCJA-TESTOWANIA.md
    ??? START-MONITOR.md
    ??? MONITOR-SUMMARY.md
    ??? TEST-RESULTS.md
```

## ?? U¿ycie

### Podstawowe testowanie
```cmd
quick-test-monitor.bat
```

### Z niestandardowym timeoutem
```powershell
.\run-monitor.ps1 30  # 30 sekund
```

### Demo interaktywne
```cmd
demo-monitor.bat
```

## ?? Kluczowe funkcje Monitor

- ?? **Automatyczny timeout** - nie musisz rêcznie zabijaæ zawieszonego programu
- ?? **Live monitoring** - widzisz ka¿d¹ liniê wyjœcia w czasie rzeczywistym
- ?? **Szczegó³owe raporty** - sukces/b³¹d/timeout z pe³n¹ diagnostyk¹
- ?? **Wykrywanie zawieszenia** - pokazuje dok³adnie gdzie program siê zawiesi³
- ?? **Stan œrodowiska** - sprawdza Notatnik przed i po teœcie

## ?? Licencja

Projekt edukacyjny - open source

## ?? Autor

alkar1

---

**Technologie:** .NET 8.0, C# 12, UI Automation API  
**Platform:** Windows  
**Status:** ? Gotowy do u¿ycia
