@echo off
echo Building installable version of Custom VS Code Editors...

REM Run the PowerShell build script with elevated privileges and keep the window open
powershell -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass -NoExit -File build_installer.ps1' -Verb RunAs"

echo Build script launched with admin privileges. Check the PowerShell window for progress.
echo The PowerShell window will remain open to show any errors.
