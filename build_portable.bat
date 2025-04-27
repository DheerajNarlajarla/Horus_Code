@echo off
echo Building portable version of Custom VS Code Editors...

REM Run the PowerShell build script with elevated privileges
powershell -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass -File build_portable.ps1' -Verb RunAs"

echo Build script launched with admin privileges. Check the PowerShell window for progress.
