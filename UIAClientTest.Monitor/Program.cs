using System;
using System.Diagnostics;
using System.IO;
using System.Threading;
using System.Threading.Tasks;

namespace UIAClientTest.Monitor
{
    /// <summary>
    /// Program monitoruj¹cy dzia³anie UIAClientTest
    /// Uruchamia aplikacjê z timeoutem i raportuje wyniki
    /// </summary>
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("=== UIAClientTest Monitor ===");
            Console.WriteLine("Program monitoruj¹cy dzia³anie UIAClientTest\n");

            int timeoutSeconds = 10;
            if (args.Length > 0 && int.TryParse(args[0], out int customTimeout))
            {
                timeoutSeconds = customTimeout;
            }

            Console.WriteLine($"Timeout: {timeoutSeconds} sekund");
            Console.WriteLine(new string('=', 50) + "\n");

            // ZnajdŸ œcie¿kê do UIAClientTest.exe
            string exePath = FindUIAClientTestExe();
            
            if (string.IsNullOrEmpty(exePath))
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine("? B£¥D: Nie znaleziono UIAClientTest.exe");
                Console.ResetColor();
                Console.WriteLine("\nSzukano w:");
                Console.WriteLine("  - ..\\UIAClientTest\\bin\\Debug\\net8.0-windows\\UIAClientTest.exe");
                Console.WriteLine("  - ..\\bin\\Debug\\net8.0-windows\\UIAClientTest.exe");
                Environment.Exit(1);
                return;
            }

            Console.WriteLine($"? Znaleziono: {exePath}\n");

            // Test 1: SprawdŸ czy Notatnik jest uruchomiony
            Console.WriteLine("Test 1: Sprawdzanie stanu Notatnika...");
            var notepadProcesses = Process.GetProcessesByName("notepad");
            bool wasNotepadRunning = notepadProcesses.Length > 0;
            
            if (wasNotepadRunning)
            {
                Console.ForegroundColor = ConsoleColor.Yellow;
                Console.WriteLine($"? Notatnik ju¿ uruchomiony (PID: {notepadProcesses[0].Id})");
                Console.ResetColor();
            }
            else
            {
                Console.WriteLine("? Notatnik nie jest uruchomiony");
            }

            // Test 2: Uruchom UIAClientTest z timeoutem
            Console.WriteLine($"\nTest 2: Uruchamianie UIAClientTest (timeout: {timeoutSeconds}s)...");
            
            var result = RunWithTimeout(exePath, "--auto", timeoutSeconds * 1000);

            Console.WriteLine("\n" + new string('=', 50));
            Console.WriteLine("WYNIKI TESTU:");
            Console.WriteLine(new string('=', 50));

            if (result.TimedOut)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine($"? TIMEOUT: Program nie zakoñczy³ siê w {timeoutSeconds} sekund");
                Console.ResetColor();
                Console.WriteLine("\nMo¿liwe przyczyny:");
                Console.WriteLine("  - Program zawiesi³ siê na SetFocus()");
                Console.WriteLine("  - Notatnik nie otrzyma³ fokusa");
                Console.WriteLine("  - Program czeka na Enter (nie u¿ywa --auto)");
            }
            else if (result.ExitCode == 0)
            {
                Console.ForegroundColor = ConsoleColor.Green;
                Console.WriteLine("? SUKCES: Program zakoñczy³ siê poprawnie");
                Console.ResetColor();
                Console.WriteLine($"  Czas wykonania: {result.ExecutionTime.TotalSeconds:F2}s");
            }
            else
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine($"? B£¥D: Program zakoñczy³ siê z kodem: {result.ExitCode}");
                Console.ResetColor();
                Console.WriteLine($"  Czas wykonania: {result.ExecutionTime.TotalSeconds:F2}s");
            }

            if (!string.IsNullOrEmpty(result.Output))
            {
                Console.WriteLine("\nWYJŒCIE PROGRAMU:");
                Console.WriteLine(new string('-', 50));
                Console.WriteLine(result.Output);
                Console.WriteLine(new string('-', 50));
            }

            if (!string.IsNullOrEmpty(result.Error))
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine("\nB£ÊDY:");
                Console.WriteLine(new string('-', 50));
                Console.WriteLine(result.Error);
                Console.WriteLine(new string('-', 50));
                Console.ResetColor();
            }

            // Test 3: SprawdŸ stan Notatnika po teœcie
            Console.WriteLine("\nTest 3: Stan Notatnika po wykonaniu...");
            notepadProcesses = Process.GetProcessesByName("notepad");
            
            if (notepadProcesses.Length > 0)
            {
                Console.ForegroundColor = ConsoleColor.Cyan;
                Console.WriteLine($"? Notatnik dzia³a (PID: {notepadProcesses[0].Id})");
                Console.ResetColor();
                
                if (!wasNotepadRunning)
                {
                    Console.WriteLine("? Notatnik zosta³ uruchomiony przez UIAClientTest");
                }
            }
            else
            {
                Console.WriteLine("? Notatnik nie dzia³a");
            }

            Console.WriteLine("\n" + new string('=', 50));
            Console.WriteLine("Naciœnij Enter aby zakoñczyæ...");
            Console.ReadLine();
        }

        static string FindUIAClientTestExe()
        {
            string[] possiblePaths = new[]
            {
                Path.Combine("..", "UIAClientTest", "bin", "Debug", "net8.0-windows", "UIAClientTest.exe"),
                Path.Combine("..", "bin", "Debug", "net8.0-windows", "UIAClientTest.exe"),
                Path.Combine("UIAClientTest", "bin", "Debug", "net8.0-windows", "UIAClientTest.exe"),
            };

            foreach (var path in possiblePaths)
            {
                string fullPath = Path.GetFullPath(path);
                if (File.Exists(fullPath))
                {
                    return fullPath;
                }
            }

            return string.Empty;
        }

        static TestResult RunWithTimeout(string exePath, string arguments, int timeoutMs)
        {
            var result = new TestResult();
            var startTime = DateTime.Now;

            try
            {
                var processStartInfo = new ProcessStartInfo
                {
                    FileName = exePath,
                    Arguments = arguments,
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    CreateNoWindow = true
                };

                using (var process = new Process { StartInfo = processStartInfo })
                {
                    var output = new System.Text.StringBuilder();
                    var error = new System.Text.StringBuilder();

                    process.OutputDataReceived += (sender, e) => 
                    { 
                        if (e.Data != null) 
                        {
                            output.AppendLine(e.Data);
                            Console.WriteLine($"  > {e.Data}");
                        }
                    };
                    
                    process.ErrorDataReceived += (sender, e) => 
                    { 
                        if (e.Data != null) 
                        {
                            error.AppendLine(e.Data);
                            Console.ForegroundColor = ConsoleColor.Red;
                            Console.WriteLine($"  ! {e.Data}");
                            Console.ResetColor();
                        }
                    };

                    process.Start();
                    process.BeginOutputReadLine();
                    process.BeginErrorReadLine();

                    Console.Write("Czekam na zakoñczenie");
                    bool finished = false;
                    
                    // Animacja kropek podczas oczekiwania
                    var waitTask = Task.Run(() =>
                    {
                        while (!finished)
                        {
                            Console.Write(".");
                            Thread.Sleep(500);
                        }
                    });

                    if (process.WaitForExit(timeoutMs))
                    {
                        finished = true;
                        process.WaitForExit(); // Czeka na zakoñczenie odczytu output
                        result.ExitCode = process.ExitCode;
                        result.TimedOut = false;
                    }
                    else
                    {
                        finished = true;
                        Console.WriteLine("\n? Timeout - zabijam proces...");
                        process.Kill(true);
                        result.TimedOut = true;
                    }

                    waitTask.Wait();
                    Console.WriteLine();

                    result.Output = output.ToString();
                    result.Error = error.ToString();
                }
            }
            catch (Exception ex)
            {
                result.Error = $"Wyj¹tek: {ex.Message}\n{ex.StackTrace}";
                result.ExitCode = -1;
            }

            result.ExecutionTime = DateTime.Now - startTime;
            return result;
        }

        class TestResult
        {
            public bool TimedOut { get; set; }
            public int ExitCode { get; set; }
            public string Output { get; set; } = string.Empty;
            public string Error { get; set; } = string.Empty;
            public TimeSpan ExecutionTime { get; set; }
        }
    }
}
