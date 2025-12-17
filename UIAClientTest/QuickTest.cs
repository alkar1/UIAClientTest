using System;

namespace QuickTest
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("=== QUICK TEST ===");
            Console.WriteLine("Test 1: Console output - OK");
            
            // Test 2: Sprawdz czy Notatnik jest uruchomiony
            var notepad = System.Diagnostics.Process.GetProcessesByName("notepad");
            if (notepad.Length > 0)
            {
                Console.WriteLine($"Test 2: Notatnik znaleziony (PID: {notepad[0].Id}) - OK");
            }
            else
            {
                Console.WriteLine("Test 2: Notatnik NIE uruchomiony - OSTRZEZENIE");
            }
            
            // Test 3: Sprawdz czy UI Automation dziala
            try
            {
                var automation = System.Windows.Automation.AutomationElement.RootElement;
                Console.WriteLine("Test 3: UI Automation API - OK");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Test 3: UI Automation API - BLAD: {ex.Message}");
            }
            
            Console.WriteLine("=== TEST ZAKONCZONY ===");
            Environment.Exit(0);
        }
    }
}
