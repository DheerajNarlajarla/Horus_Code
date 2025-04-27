@echo off
echo ===================================================
echo       Custom VS Code Theme Switcher
echo ===================================================
echo.
echo 1. HorusCode (Egyptian Gold)
echo 2. BorealisIDE (Northern Lights)
echo 3. BloodCode (Dark Gore)
echo.
set /p choice=Select a theme (1-3):

if "%choice%"=="1" (
    echo Applying HorusCode theme...
    copy /Y "themes\horuscode-theme.css" "resources\app\out\vs\workbench\browser\media\my-custom-theme.css"
) else if "%choice%"=="2" (
    echo Applying BorealisIDE theme...
    copy /Y "themes\borealiside-theme.css" "resources\app\out\vs\workbench\browser\media\my-custom-theme.css"
) else if "%choice%"=="3" (
    echo Applying BloodCode theme...
    copy /Y "themes\bloodcode-theme.css" "resources\app\out\vs\workbench\browser\media\my-custom-theme.css"
) else (
    echo Invalid choice. Using default HorusCode theme.
    copy /Y "themes\horuscode-theme.css" "resources\app\out\vs\workbench\browser\media\my-custom-theme.css"
)

echo.
echo Theme applied. Starting Custom VS Code...
echo ===================================================
start VSCodium.exe
