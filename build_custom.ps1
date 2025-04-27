# PowerShell build script for Custom VS Code Editors
Write-Host "Building Custom VS Code Editors - HorusCode, BorealisIDE, and BloodCode..." -ForegroundColor Green

# Copy custom icons
Copy-Item -Path "icons\stable\mycode_cnl.svg" -Destination "icons\stable\codium_cnl.svg" -Force
Copy-Item -Path "icons\stable\mycode_clt.svg" -Destination "icons\stable\codium_clt.svg" -Force
Copy-Item -Path "icons\stable\mycode_cnl_w80_b8.svg" -Destination "icons\stable\codium_cnl_w80_b8.svg" -Force

# Create media directory if it doesn't exist
$mediaDir = "vscode\src\vs\workbench\browser\media"
if (-not (Test-Path $mediaDir)) {
    New-Item -Path $mediaDir -ItemType Directory -Force | Out-Null
}

# Copy all custom CSS themes with their new names
Copy-Item -Path "src\stable\horuscode-theme.css" -Destination "$mediaDir\my-custom-theme.css" -Force
Copy-Item -Path "src\stable\borealiside-theme.css" -Destination "$mediaDir\aurora-theme.css" -Force
Copy-Item -Path "src\stable\bloodcode-theme.css" -Destination "$mediaDir\dark-gore-theme.css" -Force

# Also copy with their original names for reference
Copy-Item -Path "src\stable\horuscode-theme.css" -Destination "$mediaDir\horuscode-theme.css" -Force
Copy-Item -Path "src\stable\borealiside-theme.css" -Destination "$mediaDir\borealiside-theme.css" -Force
Copy-Item -Path "src\stable\bloodcode-theme.css" -Destination "$mediaDir\bloodcode-theme.css" -Force

# Apply custom patches
$patchesDir = "patches\user"
if (-not (Test-Path $patchesDir)) {
    New-Item -Path $patchesDir -ItemType Directory -Force | Out-Null
}
Copy-Item -Path "patches\custom-theme.patch" -Destination "$patchesDir\custom-theme.patch" -Force

# Check if we need to clone VSCode
if (-not (Test-Path "vscode")) {
    Write-Host "Cloning VS Code repository..." -ForegroundColor Yellow
    git clone https://github.com/microsoft/vscode.git vscode
    
    # Apply our patches
    Write-Host "Applying patches..." -ForegroundColor Yellow
    Get-ChildItem -Path "$patchesDir\*.patch" | ForEach-Object {
        Set-Location vscode
        git apply --ignore-whitespace --ignore-space-change "../$($_.FullName)"
        Set-Location ..
    }
}

Write-Host "Build preparation completed!" -ForegroundColor Green
Write-Host ""
Write-Host "To complete the build process, you would need to run the following commands:" -ForegroundColor Yellow
Write-Host "cd vscode" -ForegroundColor Cyan
Write-Host "yarn" -ForegroundColor Cyan
Write-Host "yarn compile" -ForegroundColor Cyan
Write-Host "yarn watch" -ForegroundColor Cyan
Write-Host ""
Write-Host "Note: The full build process requires Node.js, yarn, and other dependencies." -ForegroundColor Yellow
Write-Host "For a simpler approach, you can use the VSCode Extension approach described in the documentation." -ForegroundColor Yellow
