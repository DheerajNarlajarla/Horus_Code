# PowerShell script to build an installer for Horus Code
Write-Host "Building installer for Horus Code..." -ForegroundColor Green
Write-Host "This script will create an MSI/EXE installer" -ForegroundColor Yellow
Write-Host "Progress and estimated time will be shown for each step" -ForegroundColor Yellow
Write-Host ""

# Error handling
$ErrorActionPreference = "Stop"

# Function to show progress with time estimation
function Show-Progress {
    param (
        [string]$Activity,
        [int]$PercentComplete,
        [int]$TotalSteps,
        [int]$CurrentStep,
        [datetime]$StartTime
    )
    
    $elapsedTime = (Get-Date) - $StartTime
    $estimatedTotalTime = $elapsedTime.TotalSeconds / $CurrentStep * $TotalSteps
    $remainingTime = $estimatedTotalTime - $elapsedTime.TotalSeconds
    
    if ($remainingTime -lt 0) { $remainingTime = 0 }
    
    $remainingTimeStr = "{0:mm}:{0:ss}" -f [timespan]::FromSeconds($remainingTime)
    $elapsedTimeStr = "{0:mm}:{0:ss}" -f $elapsedTime
    
    Write-Progress -Activity $Activity -Status "Step $CurrentStep of $TotalSteps - Elapsed: $elapsedTimeStr - Remaining: $remainingTimeStr" -PercentComplete $PercentComplete
}

# Total number of steps in the build process
$totalSteps = 6
$currentStep = 0
$startTime = Get-Date

try {
    # Step 1: Check dependencies
    $currentStep++
    $activity = "Checking dependencies"
    Show-Progress -Activity $activity -PercentComplete (($currentStep / $totalSteps) * 100) -TotalSteps $totalSteps -CurrentStep $currentStep -StartTime $startTime
    
    Write-Host "[$currentStep/$totalSteps] Checking for required dependencies..." -ForegroundColor Yellow
    
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
    
    # Step 2: Clone or update VSCode repository
    $currentStep++
    $activity = "Preparing VSCode repository"
    Show-Progress -Activity $activity -PercentComplete (($currentStep / $totalSteps) * 100) -TotalSteps $totalSteps -CurrentStep $currentStep -StartTime $startTime
    
    Write-Host "[$currentStep/$totalSteps] Preparing VSCode repository..." -ForegroundColor Yellow
    
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
    
    # Step 3: Prepare customizations
    $currentStep++
    $activity = "Preparing customizations"
    Show-Progress -Activity $activity -PercentComplete (($currentStep / $totalSteps) * 100) -TotalSteps $totalSteps -CurrentStep $currentStep -StartTime $startTime
    
    Write-Host "[$currentStep/$totalSteps] Preparing customizations..." -ForegroundColor Yellow
    
    # Copy custom icons
    Write-Host "Copying custom icons..." -ForegroundColor Yellow
    Copy-Item -Path "icons\stable\mycode_cnl.svg" -Destination "icons\stable\codium_cnl.svg" -Force
    Copy-Item -Path "icons\stable\mycode_clt.svg" -Destination "icons\stable\codium_clt.svg" -Force
    Copy-Item -Path "icons\stable\mycode_cnl_w80_b8.svg" -Destination "icons\stable\codium_cnl_w80_b8.svg" -Force

    # Create media directory if it doesn't exist
    $mediaDir = "vscode\src\vs\workbench\browser\media"
    if (-not (Test-Path $mediaDir)) {
        New-Item -Path $mediaDir -ItemType Directory -Force | Out-Null
    }

    # Copy all custom CSS themes
    Write-Host "Copying theme files..." -ForegroundColor Yellow
    Copy-Item -Path "src\stable\horuscode-theme.css" -Destination "$mediaDir\my-custom-theme.css" -Force
    Copy-Item -Path "src\stable\borealiside-theme.css" -Destination "$mediaDir\aurora-theme.css" -Force
    Copy-Item -Path "src\stable\bloodcode-theme.css" -Destination "$mediaDir\dark-gore-theme.css" -Force

    # Also copy with their original names for reference
    Copy-Item -Path "src\stable\horuscode-theme.css" -Destination "$mediaDir\horuscode-theme.css" -Force
    Copy-Item -Path "src\stable\borealiside-theme.css" -Destination "$mediaDir\borealiside-theme.css" -Force
    Copy-Item -Path "src\stable\bloodcode-theme.css" -Destination "$mediaDir\bloodcode-theme.css" -Force

    # Apply custom patches
    Write-Host "Applying patches..." -ForegroundColor Yellow
    $patchesDir = "patches\user"
    if (-not (Test-Path $patchesDir)) {
        New-Item -Path $patchesDir -ItemType Directory -Force | Out-Null
    }
    Copy-Item -Path "patches\custom-theme.patch" -Destination "$patchesDir\custom-theme.patch" -Force
    
    # Apply product.json changes
    Write-Host "Applying product.json changes..." -ForegroundColor Yellow
    Copy-Item -Path "product.json" -Destination "vscode\product.json" -Force
    
    # Step 4: Build VSCode
    $currentStep++
    $activity = "Building VSCode"
    Show-Progress -Activity $activity -PercentComplete (($currentStep / $totalSteps) * 100) -TotalSteps $totalSteps -CurrentStep $currentStep -StartTime $startTime
    
    Write-Host "[$currentStep/$totalSteps] Building VSCode (this may take a while)..." -ForegroundColor Yellow
    
    # Navigate to the vscode directory
    Set-Location vscode -ErrorAction Stop
    
    # Install dependencies
    Write-Host "Installing dependencies (this may take a while)..." -ForegroundColor Yellow
    yarn
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install dependencies with yarn"
    }

    # Build VSCode
    Write-Host "Compiling VSCode (this may take a while)..." -ForegroundColor Yellow
    yarn compile
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to compile VSCode"
    }
    
    # Step 5: Create installer
    $currentStep++
    $activity = "Creating installer"
    Show-Progress -Activity $activity -PercentComplete (($currentStep / $totalSteps) * 100) -TotalSteps $totalSteps -CurrentStep $currentStep -StartTime $startTime
    
    Write-Host "[$currentStep/$totalSteps] Creating installer..." -ForegroundColor Yellow
    
    # Create Windows installer
    Write-Host "Creating Windows installer (this may take a while)..." -ForegroundColor Yellow
    yarn run gulp vscode-win32-x64-setup
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to create Windows installer"
    }
    
    # Return to the original directory
    Set-Location .. -ErrorAction Stop
    
    # Step 6: Finalize
    $currentStep++
    $activity = "Finalizing"
    Show-Progress -Activity $activity -PercentComplete (($currentStep / $totalSteps) * 100) -TotalSteps $totalSteps -CurrentStep $currentStep -StartTime $startTime
    
    Write-Host "[$currentStep/$totalSteps] Finalizing..." -ForegroundColor Yellow
    
    # Create output directory
    $outputDir = "horus_installer"
    if (-not (Test-Path $outputDir)) {
        New-Item -Path $outputDir -ItemType Directory -Force | Out-Null
    }
    
    # Copy installer to output directory
    $installerPath = "vscode\.build\win32-x64\setup\*.exe"
    if (Test-Path $installerPath) {
        Copy-Item -Path $installerPath -Destination $outputDir -Force
        Write-Host "Installer copied to $outputDir directory" -ForegroundColor Green
    } else {
        Write-Host "Warning: Installer not found at expected location" -ForegroundColor Yellow
    }
    
    # Create a README file
    $readmeContent = @"
# Horus Code - Installer

This directory contains the installer for Horus Code, a customized version of Visual Studio Code with three unique themes:

## The Editors

1. **HorusCode** - Egyptian-themed editor with gold accents and the Eye of Horus
2. **BorealisIDE** - Northern Lights-inspired editor with blues and teals
3. **BloodCode** - Dark and dramatic editor with Oxblood Red and Pitch Black

## Installation

1. Run the installer executable (.exe) file
2. Follow the installation prompts
3. Launch Horus Code from the Start Menu or desktop shortcut

## Features

- Multiple beautiful themes to choose from
- Custom icons and styling
- All the power of VS Code in a customized package

## Notes

- The installer will create a standard installation that can be uninstalled through Windows Control Panel
- Your settings and extensions will be stored in the default location for VS Code
"@
    
    # Create README file
    $readmeContent | Out-File -FilePath "$outputDir\README.md" -Encoding UTF8
    
    # Calculate total build time
    $totalBuildTime = (Get-Date) - $startTime
    $totalBuildTimeStr = "{0:mm}:{0:ss}" -f $totalBuildTime
    
    # Complete
    Write-Progress -Activity "Build Process" -Completed
    
    Write-Host ""
    Write-Host "====================================================" -ForegroundColor Cyan
    Write-Host "Build completed successfully!" -ForegroundColor Green
    Write-Host "====================================================" -ForegroundColor Cyan
    Write-Host "Total build time: $totalBuildTimeStr" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Installer is available in: " -NoNewline
    Write-Host "$((Resolve-Path $outputDir).Path)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "To install Horus Code:" -ForegroundColor Yellow
    Write-Host "1. Navigate to the installer directory" -ForegroundColor Cyan
    Write-Host "2. Run the .exe installer file" -ForegroundColor Cyan
    Write-Host "====================================================" -ForegroundColor Cyan
    
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
