@echo off
setlocal
cd /d "%~dp0"

powershell.exe -ExecutionPolicy Bypass -File "%~dp0play-elaris.ps1"

if errorlevel 1 (
  echo.
  echo Elaris text game framework failed to start.
  echo Please check that PowerShell is available and the files are still in place.
  pause
)

endlocal
