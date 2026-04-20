@echo off
setlocal
set "ROOT=%~dp0"
for /f "tokens=2 delims=," %%P in ('tasklist /fo csv /nh ^| findstr /i "powershell.exe"') do (
  powershell -ExecutionPolicy Bypass -Command "$proc = Get-CimInstance Win32_Process | Where-Object { $_.ProcessId -eq %%~P -and $_.CommandLine -like '*start-ui-shell-server.ps1*' }; if ($proc) { Stop-Process -Id $proc.ProcessId -Force }" >nul 2>nul
)
start "Elaris UI Shell" powershell -ExecutionPolicy Bypass -File "%ROOT%start-ui-shell-server.ps1" -OpenBrowser false
powershell -ExecutionPolicy Bypass -Command "$deadline=(Get-Date).AddSeconds(5); do { try { Invoke-WebRequest -UseBasicParsing 'http://127.0.0.1:43124/api/health' | Out-Null; break } catch { Start-Sleep -Milliseconds 250 } } while ((Get-Date) -lt $deadline)" >nul 2>nul
start "" "http://127.0.0.1:43124/?v=%RANDOM%%RANDOM%"
