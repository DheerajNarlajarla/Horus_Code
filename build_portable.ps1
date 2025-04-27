# PowerShell script to build a portable version of custom VSCode
Write-Host "Building portable version of Custom VS Code Editors..." -ForegroundColor Green

# Check if Node.js is installed
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "Node.js is required but not found. Please install Node.js and try again." -ForegroundColor Red
    exit 1
}

# Check if Yarn is installed
if (-not (Get-Command yarn -ErrorAction SilentlyContinue)) {
    Write-Host "Yarn is required but not found. Installing Yarn..." -ForegroundColor Yellow
    npm install -g yarn
}

# Check if we need to clone VSCode
if (-not (Test-Path "vscode")) {
    Write-Host "Cloning VS Code repository..." -ForegroundColor Yellow
    git clone https://github.com/microsoft/vscode.git vscode
}

# First run the custom build script to prepare customizations
Write-Host "Preparing customizations..." -ForegroundColor Yellow
.\build_custom.bat

# Navigate to the vscode directory
Set-Location vscode

# Apply product.json changes
Write-Host "Applying product.json changes..." -ForegroundColor Yellow
Copy-Item -Path "..\product.json" -Destination "product.json" -Force

# Install dependencies
Write-Host "Installing dependencies (this may take a while)..." -ForegroundColor Yellow
yarn

# Build VSCode
Write-Host "Building VSCode (this may take a while)..." -ForegroundColor Yellow
yarn compile

# Create portable build
Write-Host "Creating portable build..." -ForegroundColor Yellow
yarn run gulp vscode-win32-x64-archive

# Return to the original directory
Set-Location ..

# Create a directory for the portable app
$portableDir = "CustomVSCode-Portable"
if (-not (Test-Path $portableDir)) {
    New-Item -Path $portableDir -ItemType Directory -Force | Out-Null
}

# Extract the archive to the portable directory
Write-Host "Extracting portable build..." -ForegroundColor Yellow
Expand-Archive -Path "vscode\.build\win32-x64\archive\VSCode-win32-x64.zip" -DestinationPath $portableDir -Force

# Create a theme switcher batch file
$themeSwitcherContent = @"
@echo off
echo Custom VS Code Theme Switcher
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

echo Theme applied. Starting Custom VS Code...
start Code.exe
"@

# Create themes directory in portable app
$themesDir = "$portableDir\themes"
if (-not (Test-Path $themesDir)) {
    New-Item -Path $themesDir -ItemType Directory -Force | Out-Null
}

# Copy theme files to portable app
Copy-Item -Path "src\stable\horuscode-theme.css" -Destination "$themesDir\" -Force
Copy-Item -Path "src\stable\borealiside-theme.css" -Destination "$themesDir\" -Force
Copy-Item -Path "src\stable\bloodcode-theme.css" -Destination "$themesDir\" -Force

# Create theme switcher batch file
$themeSwitcherContent | Out-File -FilePath "$portableDir\ThemeSwitcher.bat" -Encoding ASCII

Write-Host "Build completed!" -ForegroundColor Green
Write-Host "Portable version is available in the $portableDir directory" -ForegroundColor Green
Write-Host "Run ThemeSwitcher.bat to select a theme and launch the application" -ForegroundColor Green
