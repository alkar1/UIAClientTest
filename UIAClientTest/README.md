# UIAClientTest - Microsoft UI Automation Client

Aplikacja demonstracyjna wykorzystuj¹ca **Microsoft UI Automation API** do automatyzacji aplikacji Windows (Notatnik).

## ?? Opis projektu

Program automatycznie:
1. Znajduje uruchomiony proces Notatnika (lub uruchamia nowy)
2. U¿ywa UI Automation API do lokalizacji pola tekstowego
3. Wpisuje testowy tekst przy pomocy ValuePattern lub SendKeys
4. Wyœwietla informacje diagnostyczne w konsoli

## ?? Technologie

- **.NET 8.0** (net8.0-windows)
- **System.Windows.Automation** - g³ówny framework UI Automation
- **System.Diagnostics** - zarz¹dzanie procesami
- **System.Windows.Forms** - SendKeys jako fallback
- **C# 12** z nullable reference types

## ?? Wymagania systemowe

- Windows 10/11
- .NET 8.0 SDK lub nowszy
- Notatnik Windows (notepad.exe)

## ?? Szybki start

### Kompilacja projektu

```powershell
# Z poziomu solution
dotnet build UIAClientTest.sln

# Lub bezpoœrednio projekt
cd UIAClientTest
dotnet build
```

### Uruchomienie

**Tryb interaktywny** (czeka na Enter):
```powershell
dotnet run
```

**Tryb automatyczny** (koñczy siê automatycznie):
```powershell
dotnet run -- --auto
```

**Uruchomienie z pliku exe**:
```powershell
.\bin\Debug\net8.0-windows\UIAClientTest.exe
.\bin\Debug\net8.0-windows\UIAClientTest.exe --auto
```

## ?? Testowanie

### ?? Monitor - Narzêdzie diagnostyczne (ZALECANE)

**Najlepszy sposób na testowanie aplikacji:**

```powershell
# Windows CMD
run-monitor.bat

# PowerShell (z niestandardowym timeoutem)
.\run-monitor.ps1 15
```

Monitor automatycznie:
- ? Uruchamia UIAClientTest z timeoutem
- ? Wykrywa zawieszenia i timeouty
- ? Raportuje szczegó³owe wyniki
- ? Pokazuje stan Notatnika przed i po teœcie

?? **Pe³na dokumentacja:** `UIAClientTest.Monitor\README.md`

### Szybki test (wszystko w jednym kroku)
```powershell
.\quick-test.bat
# lub
.\SimpleTest.ps1
```

### Automatyczny test pe³ny
```powershell
.\AutoTest.ps1
```

### Testy krok po kroku
```powershell
# Wszystkie testy sekwencyjnie
.\run-all-tests.bat
# lub
.\RunAllTests.ps1

# Poszczególne etapy:
.\test1.bat                # 1. Kompilacja
.\test2.bat                # 2. Uruchomienie Notatnika
.\test3.bat                # 3. Uruchomienie aplikacji
.\test4-check-exe.bat      # 4. Weryfikacja exe
.\test5-cleanup.bat        # 5. Czyszczenie

# Wersje PowerShell:
.\Test1-Build.ps1
.\Test2-StartNotepad.ps1
.\Test3-RunApp.ps1
.\Test4-Verify.ps1
.\Test5-Cleanup.ps1
```

## ?? Struktura projektu

```
UIAClientTest/
??? UIAClientTest.sln          # Solution Visual Studio
??? UIAClientTest/
?   ??? Program.cs              # ?? G³ówna aplikacja
?   ??? QuickTest.cs            # Pomocniczy plik testowy
?   ??? UIAClientTest.csproj    # Plik projektu .NET
?   ?
?   ??? README.md               # Ten plik
?   ??? START-HERE.md           # Przewodnik startowy
?   ??? TESTING.md              # Dokumentacja testów
?   ?
?   ??? quick-test.bat          # Szybki test
?   ??? run-all-tests.bat       # Wszystkie testy
?   ??? test*.bat               # Poszczególne testy (1-5)
?   ?
?   ??? AutoTest.ps1            # Pe³ny test automatyczny
?   ??? SimpleTest.ps1          # Prosty test
?   ??? RunAllTests.ps1         # Uruchom wszystkie testy
?   ??? Test*.ps1               # Poszczególne testy PowerShell
?
??? UIAClientTest.Monitor/      # ?? Program monitoruj¹cy (NOWY!)
?   ??? Program.cs              # Logika monitora
?   ??? UIAClientTest.Monitor.csproj
?   ??? README.md               # Dokumentacja monitora
?
??? run-monitor.bat             # ?? Uruchom monitor (CMD)
??? run-monitor.ps1             # ?? Uruchom monitor (PowerShell)
```

## ?? Jak to dzia³a

### 1. Znalezienie procesu Notatnika
```csharp
Process[] processes = Process.GetProcessesByName("notepad");
Process notepadProcess = processes.Length > 0 ? processes[0] : null;
```

### 2. Pobranie AutomationElement dla okna
```csharp
AutomationElement notepadWindow = 
    AutomationElement.FromHandle(notepadProcess.MainWindowHandle);
```

### 3. Wyszukanie kontrolki edycji tekstu
```csharp
// Próba 1: Kontrolka typu Edit
PropertyCondition editCondition = new PropertyCondition(
    AutomationElement.ControlTypeProperty,
    ControlType.Edit);
AutomationElement editControl = 
    root.FindFirst(TreeScope.Descendants, editCondition);

// Próba 2: Kontrolka typu Document (nowsze wersje Notatnika)
if (editControl == null)
{
    PropertyCondition docCondition = new PropertyCondition(
        AutomationElement.ControlTypeProperty,
        ControlType.Document);
    editControl = root.FindFirst(TreeScope.Descendants, docCondition);
}
```

### 4. Wpisanie tekstu - dwie metody

**Metoda 1: ValuePattern (preferowana)**
```csharp
if (element.TryGetCurrentPattern(ValuePattern.Pattern, out object patternObj) 
    && patternObj is ValuePattern valuePattern)
{
    element.SetFocus();
    valuePattern.SetValue(text);
}
```

**Metoda 2: SendKeys (fallback)**
```csharp
else
{
    element.SetFocus();
    System.Windows.Forms.SendKeys.SendWait(text);
}
```

## ?? Kluczowe koncepcje UI Automation

### AutomationElement
Reprezentuje element interfejsu u¿ytkownika w drzewie UI Automation.

### ControlType
Definiuje typ kontrolki:
- `ControlType.Edit` - pole edycji tekstu (starsze wersje Notatnika)
- `ControlType.Document` - dokument tekstowy (nowsze wersje)
- `ControlType.Button` - przycisk
- i wiele innych...

### Patterns (Wzorce)
Definiuj¹ operacje, które mo¿na wykonaæ na kontrolce:
- `ValuePattern` - ustawianie/pobieranie wartoœci
- `InvokePattern` - wywo³ywanie akcji (np. klikniêcie)
- `TextPattern` - zaawansowana manipulacja tekstem
- `WindowPattern` - operacje na oknach

### TreeScope
Zakres przeszukiwania drzewa UI:
- `TreeScope.Element` - tylko bie¿¹cy element
- `TreeScope.Children` - bezpoœrednie dzieci
- `TreeScope.Descendants` - wszystkie potomki (rekurencyjnie)
- `TreeScope.Subtree` - element + potomkowie

## ?? Konfiguracja projektu

### UIAClientTest.csproj
```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net8.0-windows</TargetFramework>
    <Nullable>enable</Nullable>
    <UseWindowsForms>true</UseWindowsForms>
    <UseWPF>true</UseWPF>
    <StartupObject>UIAClientTest.Program</StartupObject>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="System.Windows.Extensions" Version="8.0.0" />
  </ItemGroup>
</Project>
```

**Kluczowe ustawienia:**
- `StartupObject` - wskazuje g³ówny punkt wejœcia (Program.cs)
- `UseWindowsForms` - w³¹cza dostêp do SendKeys
- `UseWPF` - wymagane dla pe³nego UI Automation API

## ?? Rozwi¹zywanie problemów

### ? "Program has more than one entry point defined"
**Przyczyna:** Wiele plików z metod¹ `Main()`  
**Rozwi¹zanie:** Dodano `<StartupObject>UIAClientTest.Program</StartupObject>` w .csproj

### ? Nie mo¿na znaleŸæ pola edycji
**Mo¿liwe przyczyny:**
- Notatnik nie jest uruchomiony - aplikacja automatycznie go uruchomi
- Nowsza wersja Notatnika u¿ywa `ControlType.Document` - kod obs³uguje obie wersje
- Uprawnienia dostêpu - uruchom jako administrator

### ? Tekst nie jest wpisywany
**Mo¿liwe przyczyny:**
- Kontrolka nie obs³uguje `ValuePattern` - kod u¿ywa `SendKeys` jako fallback
- Notatnik nie ma fokusa - kod wywo³uje `SetFocus()` przed wpisaniem
- Okno jest zminimalizowane - upewnij siê, ¿e Notatnik jest widoczny

### ? Skrypty PowerShell nie dzia³aj¹
**Rozwi¹zanie:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## ?? Dokumentacja dodatkowa

- **START-HERE.md** - Przewodnik dla pocz¹tkuj¹cych
- **TESTING.md** - Szczegó³owa dokumentacja testów
- [Microsoft Docs - UI Automation](https://docs.microsoft.com/windows/win32/winauto/entry-uiauto-win32)
- [.NET API Reference](https://docs.microsoft.com/dotnet/api/system.windows.automation)

## ?? Przyk³ady u¿ycia

### Rozszerzenie na inne aplikacje

Kod mo¿na ³atwo dostosowaæ do automatyzacji innych aplikacji Windows:

```csharp
// Kalkulator
Process calcProcess = Process.Start("calc.exe");
AutomationElement calcWindow = AutomationElement.FromHandle(calcProcess.MainWindowHandle);

// WordPad
Process wordpadProcess = Process.Start("wordpad.exe");
AutomationElement wordpadWindow = AutomationElement.FromHandle(wordpadProcess.MainWindowHandle);
```

### Wyszukiwanie po nazwie
```csharp
PropertyCondition nameCondition = new PropertyCondition(
    AutomationElement.NameProperty,
    "Otwórz");
AutomationElement openButton = 
    root.FindFirst(TreeScope.Descendants, nameCondition);
```

### £¹czenie warunków
```csharp
AndCondition buttonNamedOK = new AndCondition(
    new PropertyCondition(AutomationElement.ControlTypeProperty, ControlType.Button),
    new PropertyCondition(AutomationElement.NameProperty, "OK")
);
```

## ?? Wk³ad w projekt

To projekt edukacyjny demonstruj¹cy podstawy UI Automation. Mo¿esz:
- Rozszerzyæ funkcjonalnoœæ o inne wzorce (Patterns)
- Dodaæ obs³ugê innych aplikacji
- Ulepszyæ obs³ugê b³êdów
- Dodaæ testy jednostkowe

## ?? Licencja

Projekt udostêpniony jako przyk³ad edukacyjny.

## ?? Autor

Projekt demonstracyjny UI Automation dla .NET 8.0

---

**Ostatnia aktualizacja:** Grudzieñ 2025  
**Wersja:** 1.0.0  
**.NET:** 8.0  
**Platform:** Windows
