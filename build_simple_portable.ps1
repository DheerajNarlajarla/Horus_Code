# PowerShell script to build a simple portable version by downloading VSCodium
Write-Host "Building simple portable version of Custom VS Code Editors..." -ForegroundColor Green
Write-Host "This script will download VSCodium and apply your customizations" -ForegroundColor Yellow
Write-Host "Progress and estimated time will be shown for each step" -ForegroundColor Yellow
Write-Host ""

# Add required assembly for ZIP file handling
Add-Type -AssemblyName System.IO.Compression.FileSystem

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
$totalSteps = 7
$currentStep = 0
$startTime = Get-Date

try {
    # Step 1: Create directory
    $currentStep++
    $activity = "Creating directories"
    Show-Progress -Activity $activity -PercentComplete (($currentStep / $totalSteps) * 100) -TotalSteps $totalSteps -CurrentStep $currentStep -StartTime $startTime

    $portableDir = "CustomVSCode-Portable"
    if (-not (Test-Path $portableDir)) {
        New-Item -Path $portableDir -ItemType Directory -Force | Out-Null
    }
    Write-Host "[$currentStep/$totalSteps] Created directory: $portableDir" -ForegroundColor Green

    # Step 2: Download VSCodium
    $currentStep++
    $activity = "Downloading VSCodium portable version"
    Show-Progress -Activity $activity -PercentComplete (($currentStep / $totalSteps) * 100) -TotalSteps $totalSteps -CurrentStep $currentStep -StartTime $startTime

    $vscodiumUrl = "https://github.com/VSCodium/vscodium/releases/download/1.85.1.23348/VSCodium-win32-x64-1.85.1.23348.zip"
    $zipPath = "VSCodium-portable.zip"

    Write-Host "[$currentStep/$totalSteps] Downloading VSCodium portable version (approx. 100MB)..." -ForegroundColor Yellow

    # Download with progress using Invoke-WebRequest
    Write-Host "Starting download (approx. 100MB)..." -ForegroundColor Yellow
    $downloadStartTime = Get-Date

    try {
        # Use Invoke-WebRequest with progress
        Invoke-WebRequest -Uri $vscodiumUrl -OutFile $zipPath -UseBasicParsing -ErrorAction Stop

        $downloadElapsedTime = (Get-Date) - $downloadStartTime
        Write-Host "Download completed in $($downloadElapsedTime.ToString('mm\:ss'))" -ForegroundColor Green
    }
    catch {
        Write-Host "Error downloading file: $_" -ForegroundColor Red
        throw "Download failed"
    }

    # Step 3: Extract the archive
    $currentStep++
    $activity = "Extracting VSCodium"
    Show-Progress -Activity $activity -PercentComplete (($currentStep / $totalSteps) * 100) -TotalSteps $totalSteps -CurrentStep $currentStep -StartTime $startTime

    Write-Host "[$currentStep/$totalSteps] Extracting VSCodium..." -ForegroundColor Yellow
    $extractStartTime = Get-Date

    # Extract using built-in Expand-Archive cmdlet
    Write-Host "Extracting archive (this may take a few minutes)..." -ForegroundColor Yellow

    if (-not (Test-Path $portableDir)) {
        New-Item -Path $portableDir -ItemType Directory -Force | Out-Null
    }

    try {
        # Use built-in Expand-Archive cmdlet
        Expand-Archive -Path $zipPath -DestinationPath $portableDir -Force

        $extractElapsedTime = (Get-Date) - $extractStartTime
        Write-Host "Extraction completed in $($extractElapsedTime.ToString('mm\:ss'))" -ForegroundColor Green
    }
    catch {
        Write-Host "Error extracting archive: $_" -ForegroundColor Red
        throw "Extraction failed"
    }

    # Step 4: Create directories for customizations
    $currentStep++
    $activity = "Creating theme directories"
    Show-Progress -Activity $activity -PercentComplete (($currentStep / $totalSteps) * 100) -TotalSteps $totalSteps -CurrentStep $currentStep -StartTime $startTime

    Write-Host "[$currentStep/$totalSteps] Creating theme directories..." -ForegroundColor Yellow

    $themesDir = "$portableDir\themes"
    if (-not (Test-Path $themesDir)) {
        New-Item -Path $themesDir -ItemType Directory -Force | Out-Null
    }

    $resourcesDir = "$portableDir\resources\app"
    $mediaDir = "$resourcesDir\out\vs\workbench\browser\media"
    if (-not (Test-Path $mediaDir)) {
        New-Item -Path $mediaDir -ItemType Directory -Force | Out-Null
    }

    Write-Host "Theme directories created" -ForegroundColor Green

    # Step 5: Copy theme files
    $currentStep++
    $activity = "Copying theme files"
    Show-Progress -Activity $activity -PercentComplete (($currentStep / $totalSteps) * 100) -TotalSteps $totalSteps -CurrentStep $currentStep -StartTime $startTime

    Write-Host "[$currentStep/$totalSteps] Copying theme files..." -ForegroundColor Yellow

    # Copy theme files to themes directory
    Copy-Item -Path "src\stable\horuscode-theme.css" -Destination "$themesDir\" -Force
    Copy-Item -Path "src\stable\borealiside-theme.css" -Destination "$themesDir\" -Force
    Copy-Item -Path "src\stable\bloodcode-theme.css" -Destination "$themesDir\" -Force

    # Copy theme files to the media directory
    Copy-Item -Path "src\stable\horuscode-theme.css" -Destination "$mediaDir\horuscode-theme.css" -Force
    Copy-Item -Path "src\stable\borealiside-theme.css" -Destination "$mediaDir\borealiside-theme.css" -Force
    Copy-Item -Path "src\stable\bloodcode-theme.css" -Destination "$mediaDir\bloodcode-theme.css" -Force
    Copy-Item -Path "src\stable\horuscode-theme.css" -Destination "$mediaDir\my-custom-theme.css" -Force

    Write-Host "Theme files copied" -ForegroundColor Green

    # Step 6: Copy custom icons
    $currentStep++
    $activity = "Copying custom icons"
    Show-Progress -Activity $activity -PercentComplete (($currentStep / $totalSteps) * 100) -TotalSteps $totalSteps -CurrentStep $currentStep -StartTime $startTime

    Write-Host "[$currentStep/$totalSteps] Copying custom icons..." -ForegroundColor Yellow
    Copy-Item -Path "icons\stable\mycode_cnl.svg" -Destination "$resourcesDir\resources\win32\code.ico" -Force

    Write-Host "Custom icons copied" -ForegroundColor Green

    # Step 7: Create batch files and finalize
    $currentStep++
    $activity = "Creating theme switcher and launcher"
    Show-Progress -Activity $activity -PercentComplete (($currentStep / $totalSteps) * 100) -TotalSteps $totalSteps -CurrentStep $currentStep -StartTime $startTime

    Write-Host "[$currentStep/$totalSteps] Creating theme switcher and launcher..." -ForegroundColor Yellow

    # Create a theme switcher batch file
    $themeSwitcherContent = @"
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
"@

    # Create theme switcher batch file
    $themeSwitcherContent | Out-File -FilePath "$portableDir\ThemeSwitcher.bat" -Encoding ASCII

    # Create a custom CSS loader
    $customCssLoaderContent = @"
// ==UserScript==
// @name           Custom Theme Loader
// @namespace      CustomVSCode
// @version        1.0
// @description    Loads custom themes for VSCode
// @match          *
// @grant          none
// ==/UserScript==

(function() {
    'use strict';

    // Load the custom theme CSS
    const link = document.createElement('link');
    link.rel = 'stylesheet';
    link.type = 'text/css';
    link.href = 'out/vs/workbench/browser/media/my-custom-theme.css';
    document.head.appendChild(link);
})();
"@

    # Create custom CSS loader
    $customCssLoaderContent | Out-File -FilePath "$resourcesDir\out\vs\workbench\browser\custom-theme-loader.js" -Encoding UTF8

    # Create a launcher batch file
    $launcherContent = @"
@echo off
echo ===================================================
echo Starting Custom VS Code with HorusCode theme...
echo ===================================================
start VSCodium.exe
"@

    # Create launcher batch file
    $launcherContent | Out-File -FilePath "$portableDir\Launch.bat" -Encoding ASCII

    # Create a README file
    $readmeContent = @"
# Custom VS Code Editors

This portable package contains three custom-themed versions of Visual Studio Code:

## The Editors

1. **HorusCode** - Egyptian-themed editor with gold accents and the Eye of Horus
2. **BorealisIDE** - Northern Lights-inspired editor with blues and teals
3. **BloodCode** - Dark and dramatic editor with Oxblood Red and Pitch Black

## How to Use

1. Run `ThemeSwitcher.bat` to select a theme and launch the application
2. Or run `Launch.bat` to start with the default HorusCode theme

## Features

- Multiple beautiful themes to choose from
- Custom icons and styling
- Portable - no installation required
- All the power of VS Code in a customized package
"@

    # Create README file
    $readmeContent | Out-File -FilePath "$portableDir\README.md" -Encoding UTF8

    # Clean up
    Write-Host "Cleaning up temporary files..." -ForegroundColor Yellow
    Remove-Item -Path $zipPath -Force

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
    Write-Host "Portable version is available in: " -NoNewline
    Write-Host "$((Resolve-Path $portableDir).Path)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "To use your custom VS Code:" -ForegroundColor Yellow
    Write-Host "1. Run " -NoNewline
    Write-Host "ThemeSwitcher.bat" -ForegroundColor Cyan -NoNewline
    Write-Host " to select a theme and launch the application"
    Write-Host "2. Or run " -NoNewline
    Write-Host "Launch.bat" -ForegroundColor Cyan -NoNewline
    Write-Host " to start with the default HorusCode theme"
    Write-Host "====================================================" -ForegroundColor Cyan

} catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
    if ($_.ScriptStackTrace) {
        Write-Host "Stack trace: $($_.ScriptStackTrace)" -ForegroundColor Red
    }
} finally {
    Write-Host ""
    Write-Host "Press any key to exit..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
