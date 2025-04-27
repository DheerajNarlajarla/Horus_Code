@echo off
echo Building installer for Horus Code...

REM Run the PowerShell build script
powershell -ExecutionPolicy Bypass -NoExit -File build_horus_installer.ps1

echo Build script completed!
