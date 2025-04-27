@echo off
echo Running PowerShell build script for Custom VS Code Editors...

REM Run the PowerShell build script
powershell -ExecutionPolicy Bypass -File build_custom.ps1

echo Build script completed!
