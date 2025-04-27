# PowerShell script to build a complete installer for custom VSCode
Write-Host "Building installable version of Custom VS Code Editors..." -ForegroundColor Green
Write-Host "This script will show detailed progress and errors" -ForegroundColor Yellow

# Error handling
$ErrorActionPreference = "Stop"
$global:LastExitCode = 0

try {
    # Check if Node.js is installed
    Write-Host "Checking for Node.js..." -ForegroundColor Yellow
    if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
        Write-Host "Node.js is required but not found. Please install Node.js and try again." -ForegroundColor Red
        throw "Node.js not found"
    }

    $nodeVersion = node --version
    Write-Host "Found Node.js version: $nodeVersion" -ForegroundColor Green

    # Check if Git is installed
    Write-Host "Checking for Git..." -ForegroundColor Yellow
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Host "Git is required but not found. Please install Git and try again." -ForegroundColor Red
        throw "Git not found"
    }

    $gitVersion = git --version
    Write-Host "Found Git version: $gitVersion" -ForegroundColor Green

    # Check if Python is installed
    Write-Host "Checking for Python..." -ForegroundColor Yellow
    if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
        Write-Host "Python is required but not found. Please install Python and try again." -ForegroundColor Red
        throw "Python not found"
    }

    $pythonVersion = python --version
    Write-Host "Found Python version: $pythonVersion" -ForegroundColor Green

    # Check if Yarn is installed
    Write-Host "Checking for Yarn..." -ForegroundColor Yellow
    if (-not (Get-Command yarn -ErrorAction SilentlyContinue)) {
        Write-Host "Yarn is required but not found. Installing Yarn..." -ForegroundColor Yellow
        npm install -g yarn
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to install Yarn"
        }
    }

    $yarnVersion = yarn --version
    Write-Host "Found Yarn version: $yarnVersion" -ForegroundColor Green

    # Check if we need to clone VSCode
    if (-not (Test-Path "vscode")) {
        Write-Host "Cloning VS Code repository (this may take a while)..." -ForegroundColor Yellow
        git clone https://github.com/microsoft/vscode.git vscode
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to clone VSCode repository"
        }
    } else {
        Write-Host "VSCode repository already exists" -ForegroundColor Green
    }

    # First run the custom build script to prepare customizations
    Write-Host "Preparing customizations..." -ForegroundColor Yellow
    & .\build_custom.bat
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to prepare customizations"
    }

    # Navigate to the vscode directory
    Set-Location vscode -ErrorAction Stop

    # Apply product.json changes
    Write-Host "Applying product.json changes..." -ForegroundColor Yellow
    Copy-Item -Path "..\product.json" -Destination "product.json" -Force

    # Install dependencies
    Write-Host "Installing dependencies (this may take a while)..." -ForegroundColor Yellow
    yarn
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install dependencies with yarn"
    }

    # Build VSCode
    Write-Host "Building VSCode (this may take a while)..." -ForegroundColor Yellow
    yarn compile
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to compile VSCode"
    }

    # Create Windows installer
    Write-Host "Creating Windows installer..." -ForegroundColor Yellow
    yarn run gulp vscode-win32-x64-setup
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to create Windows installer"
    }

    # Return to the original directory
    Set-Location .. -ErrorAction Stop

    Write-Host "Build completed successfully!" -ForegroundColor Green
    Write-Host "Installer should be available in the vscode\.build\win32-x64\setup directory" -ForegroundColor Green

} catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
    if ($_.ScriptStackTrace) {
        Write-Host "Stack trace: $($_.ScriptStackTrace)" -ForegroundColor Red
    }
} finally {
    # Make sure we're back in the original directory
    try {
        if ((Get-Location).Path -like "*\vscode") {
            Set-Location .. -ErrorAction SilentlyContinue
        }
    } catch {
        # Ignore errors in the finally block
    }

    Write-Host ""
    Write-Host "Press any key to exit..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
