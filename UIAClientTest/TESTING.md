# INSTRUKCJA TESTOWANIA

## Pliki testowe (.bat - dzia³aj¹ bez zawieszania)

### Pojedyncze testy:

1. **test1.bat** - Kompilacja projektu
   ```cmd
   test1.bat
   ```

2. **test2.bat** - Uruchomienie Notatnika
   ```cmd
   test2.bat
   ```

3. **test3.bat** - Uruchomienie aplikacji UIA (wymaga Notatnika!)
   ```cmd
   test3.bat
   ```

4. **test4-check-exe.bat** - Sprawdzenie czy exe istnieje
   ```cmd
   test4-check-exe.bat
   ```

5. **test5-cleanup.bat** - Zamkniêcie Notatnika
   ```cmd
   test5-cleanup.bat
   ```

### Kompletny test automatyczny:

```cmd
run-all-tests.bat
```

To uruchomi wszystkie testy po kolei i wyœwietli wynik.

## Rêczne testowanie krok po kroku:

### Opcja 1: Wszystko automatycznie
```cmd
run-all-tests.bat
```

### Opcja 2: Krok po kroku
```cmd
test1.bat          REM Kompilacja
test4-check-exe.bat REM Sprawdzenie czy skompilowano
test2.bat          REM Uruchom Notatnik
test3.bat          REM Uruchom aplikacjê (wpisze tekst)
                   REM SprawdŸ Notatnik - powinien zawieraæ tekst!
test5-cleanup.bat  REM Zamknij Notatnik
```

## Co robi aplikacja?

Gdy uruchomisz `test3.bat`:
1. Znajduje uruchomiony Notatnik
2. U¿ywa UI Automation do znalezienia pola tekstowego
3. Wpisuje tekst: "Witaj œwiecie!\nTo jest test Microsoft UI Automation.\nDzia³a poprawnie! ??"

## Rozwi¹zywanie problemów

**Test1 (kompilacja) nie dzia³a:**
- SprawdŸ czy masz .NET 8 SDK: `dotnet --version`
- SprawdŸ czy jesteœ w folderze UIAClientTest

**Test2 (Notatnik) nie dzia³a:**
- SprawdŸ Task Manager czy notepad.exe nie jest ju¿ uruchomiony

**Test3 (aplikacja) nie dzia³a:**
- Najpierw uruchom test2.bat (Notatnik musi byæ uruchomiony)
- SprawdŸ logi aplikacji - wyœwietlaj¹ siê w konsoli

**Aplikacja nie mo¿e znaleŸæ pola edycji:**
- To mo¿e byæ problem z nowszymi wersjami Notatnika
- Aplikacja próbuje zarówno ControlType.Edit jak i ControlType.Document

## Szybki test - jedna komenda

```cmd
run-all-tests.bat
```

Jeœli wszystko dzia³a, zobaczysz:
```
[OK] Kompilacja udana
[OK] Plik istnieje
[OK] Notatnik uruchomiony
[OK] Aplikacja zakonczona pomyslnie
[OK] Notatnik zamkniety
WSZYSTKIE TESTY ZAKONCZONE SUKCESEM!
```
