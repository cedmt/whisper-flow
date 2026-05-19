$log = "C:\Users\griff\whisper\diagnose.log"
"=== diagnose at $(Get-Date) ===" | Out-File $log

$procs = Get-WmiObject Win32_Process | Where-Object {
    $_.CommandLine -match 'whisper_flow' -and $_.Name -match 'python'
}
if ($procs) {
    foreach ($p in $procs) {
        "ALIVE: PID $($p.ProcessId) ($($p.Name))" | Out-File $log -Append
        $cpu = (Get-Counter "\Process($($p.Name)*)\% Processor Time" -ErrorAction SilentlyContinue).CounterSamples | Where-Object { $_.InstanceName -like "*$($p.ProcessId)*" }
        "  CPU sample: $($cpu.CookedValue)%" | Out-File $log -Append
    }
} else {
    "NO whisper instance running - pythonw crashed silently" | Out-File $log -Append
}

# Check lock file
if (Test-Path "C:\Users\griff\whisper\.whisper_flow.lock") {
    "Lock file exists" | Out-File $log -Append
    try { Get-Content "C:\Users\griff\whisper\.whisper_flow.lock" -ErrorAction Stop | Out-File $log -Append }
    catch { "  (held exclusively)" | Out-File $log -Append }
} else {
    "Lock file MISSING - process is dead" | Out-File $log -Append
}
