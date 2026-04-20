@echo off
setlocal
set "ROOT=%~dp0"
set "UIROOT=%ROOT%text-game\07-ui-shell"

powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -like '*start-ui-shell-server.ps1*' } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force }" >nul 2>nul
start "Elaris UI Shell" powershell -NoProfile -ExecutionPolicy Bypass -File "%UIROOT%\start-ui-shell-server.ps1" -OpenBrowser true
endlocal
