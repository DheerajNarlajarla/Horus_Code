@echo off
echo Building portable version of Horus Code...

REM Run the PowerShell build script
powershell -ExecutionPolicy Bypass -NoExit -File build_horus_portable.ps1

echo Build script completed!
