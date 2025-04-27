@echo off
echo Building simple portable version of Custom VS Code Editors...

REM Run the PowerShell build script
powershell -ExecutionPolicy Bypass -NoExit -File build_simple_portable.ps1

echo Build script completed!
