using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Threading;
using System.Windows.Automation;

namespace UIAClientTest
{
    class Program
    {
        // Windows API do aktywacji okna
        [DllImport("user32.dll")]
        private static extern bool SetForegroundWindow(IntPtr hWnd);
        
        [DllImport("user32.dll")]
        private static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
        
        private const int SW_RESTORE = 9;
        private const int SW_SHOW = 5;

        [STAThread]  // WYMAGANE dla UI Automation!
        static void Main(string[] args)
        {
            // SprawdŸ czy uruchomiono w trybie automatycznym
            bool autoMode = args.Length > 0 && args[0] == "--auto";
            
            Console.WriteLine("Uruchamianie klienta Microsoft UI Automation...");
            Console.WriteLine("Szukam Notatnika (notepad.exe)...\n");

            try
            {
                // ZnajdŸ proces Notatnika
                Process? notepadProcess = FindNotepadProcess();

                if (notepadProcess == null)
                {
                    Console.WriteLine("Notatnik nie jest uruchomiony. Uruchamiam Notatnik...");
                    notepadProcess = Process.Start("notepad.exe");
                    Thread.Sleep(2000); // Czekamy a¿ Notatnik siê uruchomi
                }

                if (notepadProcess == null)
                {
                    Console.WriteLine("B³¹d: Nie mo¿na uruchomiæ Notatnika.");
                    Environment.Exit(1);
                    return;
                }

                Console.WriteLine($"Znaleziono Notatnik (PID: {notepadProcess.Id})");

                // Pobierz AutomationElement dla okna Notatnika
                AutomationElement? notepadWindow = AutomationElement.FromHandle(notepadProcess.MainWindowHandle);

                if (notepadWindow == null)
                {
                    Console.WriteLine("B³¹d: Nie mo¿na uzyskaæ dostêpu do okna Notatnika.");
                    Environment.Exit(1);
                    return;
                }

                Console.WriteLine($"Tytu³ okna: {notepadWindow.Current.Name}");

                // ZnajdŸ pole edycji tekstu
                AutomationElement? editControl = FindEditControl(notepadWindow);

                if (editControl == null)
                {
                    Console.WriteLine("B³¹d: Nie mo¿na znaleŸæ pola edycji w Notatniku.");
                    Environment.Exit(1);
                    return;
                }

                Console.WriteLine("Znaleziono pole edycji tekstu.");

                // Wpisz tekst - z aktualn¹ dat¹ i godzin¹
                string textToType = $@"========================================
   TEST UI AUTOMATION - SUKCES!
========================================

Data i czas: {DateTime.Now:yyyy-MM-dd HH:mm:ss}

Ten tekst zosta³ wpisany automatycznie
przez program UIAClientTest u¿ywaj¹c
Microsoft UI Automation API.

Technologie:
- .NET 8.0
- System.Windows.Automation
- ValuePattern

[STAThread] dzia³a poprawnie!
========================================";

                TypeTextInControl(editControl, textToType);

                Console.WriteLine($"\nPomyœlnie wpisano tekst do Notatnika!");
                
                if (autoMode)
                {
                    Console.WriteLine("\nTryb automatyczny - zakoñczenie...");
                    Environment.Exit(0);
                }
                else
                {
                    Console.WriteLine("\nNaciœnij Enter, aby zakoñczyæ...");
                    Console.ReadLine();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Wyst¹pi³ b³¹d: {ex.Message}");
                Console.WriteLine($"Stack trace: {ex.StackTrace}");
                Environment.Exit(1);
            }
        }

        /// <summary>
        /// Znajduje proces Notatnika
        /// </summary>
        static Process? FindNotepadProcess()
        {
            Process[] processes = Process.GetProcessesByName("notepad");
            return processes.Length > 0 ? processes[0] : null;
        }

        /// <summary>
        /// Znajduje kontrolkê edycji tekstu w oknie
        /// </summary>
        static AutomationElement? FindEditControl(AutomationElement root)
        {
            // Szukamy kontrolki typu Edit lub Document
            PropertyCondition editCondition = new PropertyCondition(
                AutomationElement.ControlTypeProperty,
                ControlType.Edit);

            AutomationElement? editControl = root.FindFirst(TreeScope.Descendants, editCondition);

            if (editControl == null)
            {
                // Próbujemy znaleŸæ kontrolkê typu Document (dla nowszych wersji Notatnika)
                PropertyCondition docCondition = new PropertyCondition(
                    AutomationElement.ControlTypeProperty,
                    ControlType.Document);

                editControl = root.FindFirst(TreeScope.Descendants, docCondition);
            }

            return editControl;
        }

        /// <summary>
        /// Wpisuje tekst w kontrolce u¿ywaj¹c ValuePattern lub SendKeys
        /// </summary>
        static void TypeTextInControl(AutomationElement element, string text)
        {
            // Pobierz uchwyt okna i aktywuj je
            try
            {
                var windowElement = GetParentWindow(element);
                if (windowElement != null)
                {
                    IntPtr hwnd = new IntPtr(windowElement.Current.NativeWindowHandle);
                    if (hwnd != IntPtr.Zero)
                    {
                        Console.WriteLine("Aktywujê okno Notatnika...");
                        ShowWindow(hwnd, SW_RESTORE);
                        SetForegroundWindow(hwnd);
                        Thread.Sleep(300);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Uwaga: Nie uda³o siê aktywowaæ okna: {ex.Message}");
            }

            // Metoda 1: Spróbuj ValuePattern
            if (element.TryGetCurrentPattern(ValuePattern.Pattern, out object? patternObj) && patternObj is ValuePattern valuePattern)
            {
                try
                {
                    Console.WriteLine("Próbujê ValuePattern...");
                    
                    // SprawdŸ czy nie jest tylko do odczytu
                    if (!valuePattern.Current.IsReadOnly)
                    {
                        element.SetFocus();
                        Thread.Sleep(100);
                        valuePattern.SetValue(text);
                        Console.WriteLine("Tekst wpisany przez ValuePattern!");
                        return;
                    }
                    else
                    {
                        Console.WriteLine("ValuePattern jest tylko do odczytu, próbujê innej metody...");
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"ValuePattern nie zadzia³a³: {ex.Message}");
                }
            }

            // Metoda 2: U¿yj SendKeys (dzia³a z nowszym Notatnikiem Windows 11)
            Console.WriteLine("U¿ywam SendKeys do wpisania tekstu...");
            try
            {
                // Ustaw fokus przez klikniêcie
                try { element.SetFocus(); } catch { }
                Thread.Sleep(200);
                
                // Wyœlij tekst przez SendKeys
                // Zamieñ znaki specjalne
                string safeText = text
                    .Replace("{", "{{")
                    .Replace("}", "}}")
                    .Replace("+", "{+}")
                    .Replace("^", "{^}")
                    .Replace("%", "{%}")
                    .Replace("~", "{~}")
                    .Replace("(", "{(}")
                    .Replace(")", "{)}")
                    .Replace("\r\n", "{ENTER}")
                    .Replace("\n", "{ENTER}");
                
                System.Windows.Forms.SendKeys.SendWait(safeText);
                Console.WriteLine("Tekst wpisany przez SendKeys!");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"SendKeys nie zadzia³a³: {ex.Message}");
                
                // Metoda 3: Clipboard jako ostatecznoœæ
                Console.WriteLine("Próbujê przez schowek...");
                try
                {
                    System.Windows.Forms.Clipboard.SetText(text);
                    Thread.Sleep(100);
                    System.Windows.Forms.SendKeys.SendWait("^v"); // Ctrl+V
                    Console.WriteLine("Tekst wklejony ze schowka!");
                }
                catch (Exception ex2)
                {
                    Console.WriteLine($"B³¹d schowka: {ex2.Message}");
                    throw;
                }
            }
        }

        /// <summary>
        /// Znajduje nadrzêdne okno dla elementu
        /// </summary>
        static AutomationElement? GetParentWindow(AutomationElement element)
        {
            var walker = TreeWalker.ControlViewWalker;
            var current = element;
            
            while (current != null)
            {
                if (current.Current.ControlType == ControlType.Window)
                {
                    return current;
                }
                current = walker.GetParent(current);
            }
            
            return null;
        }
    }
}
