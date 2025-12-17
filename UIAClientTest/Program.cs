using System;
using System.Diagnostics;
using System.Threading;
using System.Windows.Automation;

namespace UIAClientTest
{
    class Program
    {
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

                // Wpisz tekst
                string textToType = "Witaj œwiecie!\nTo jest test Microsoft UI Automation.\nDzia³a poprawnie! ??";
                TypeTextInControl(editControl, textToType);

                Console.WriteLine($"\nPomyœlnie wpisano tekst:\n\"{textToType}\"");
                
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
        /// Wpisuje tekst w kontrolce u¿ywaj¹c ValuePattern
        /// </summary>
        static void TypeTextInControl(AutomationElement element, string text)
        {
            // SprawdŸ czy kontrolka obs³uguje ValuePattern
            if (element.TryGetCurrentPattern(ValuePattern.Pattern, out object? patternObj) && patternObj is ValuePattern valuePattern)
            {
                Console.WriteLine("U¿ywam ValuePattern do wpisania tekstu...");
                
                // Ustaw fokus na kontrolce
                element.SetFocus();
                Thread.Sleep(100);
                
                // Wpisz tekst u¿ywaj¹c ValuePattern
                valuePattern.SetValue(text);
            }
            else
            {
                // Fallback: u¿yj SendKeys (mniej niezawodne, ale dzia³a w niektórych przypadkach)
                Console.WriteLine("ValuePattern niedostêpny, u¿ywam SendKeys...");
                element.SetFocus();
                Thread.Sleep(100);
                System.Windows.Forms.SendKeys.SendWait(text);
            }
        }
    }
}
