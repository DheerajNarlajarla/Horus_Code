#!/bin/bash

# Linux build script for Horus Code
echo "Building Horus Code for Linux..."
echo "This script will create a portable version of Horus Code"

# Create output directory
PORTABLE_DIR="horus_portable"
mkdir -p "$PORTABLE_DIR"

# Download VSCodium
echo "Downloading VSCodium..."
VSCODIUM_URL="https://github.com/VSCodium/vscodium/releases/download/1.85.1.23348/VSCodium-linux-x64-1.85.1.23348.tar.gz"
wget -O vscodium.tar.gz "$VSCODIUM_URL"

# Extract archive
echo "Extracting VSCodium..."
tar -xzf vscodium.tar.gz -C "$PORTABLE_DIR"

# Create theme directories
echo "Creating theme directories..."
mkdir -p "$PORTABLE_DIR/themes"
mkdir -p "$PORTABLE_DIR/resources/app/out/vs/workbench/browser/media"

# Copy theme files
echo "Copying theme files..."
cp src/stable/horuscode-theme.css "$PORTABLE_DIR/themes/"
cp src/stable/borealiside-theme.css "$PORTABLE_DIR/themes/"
cp src/stable/bloodcode-theme.css "$PORTABLE_DIR/themes/"

cp src/stable/horuscode-theme.css "$PORTABLE_DIR/resources/app/out/vs/workbench/browser/media/horuscode-theme.css"
cp src/stable/borealiside-theme.css "$PORTABLE_DIR/resources/app/out/vs/workbench/browser/media/borealiside-theme.css"
cp src/stable/bloodcode-theme.css "$PORTABLE_DIR/resources/app/out/vs/workbench/browser/media/bloodcode-theme.css"
cp src/stable/horuscode-theme.css "$PORTABLE_DIR/resources/app/out/vs/workbench/browser/media/my-custom-theme.css"

# Copy custom icons
echo "Copying custom icons..."
cp icons/stable/mycode_cnl.svg "$PORTABLE_DIR/resources/app/resources/linux/code.png"

# Create theme switcher script
echo "Creating theme switcher script..."
cat > "$PORTABLE_DIR/theme-switcher.sh" << 'EOF'
#!/bin/bash

echo "==================================================="
echo "       Horus Code Theme Switcher"
echo "==================================================="
echo ""
echo "1. HorusCode (Egyptian Gold)"
echo "2. BorealisIDE (Northern Lights)"
echo "3. BloodCode (Dark Gore)"
echo ""
read -p "Select a theme (1-3): " choice

if [ "$choice" = "1" ]; then
    echo "Applying HorusCode theme..."
    cp "themes/horuscode-theme.css" "resources/app/out/vs/workbench/browser/media/my-custom-theme.css"
elif [ "$choice" = "2" ]; then
    echo "Applying BorealisIDE theme..."
    cp "themes/borealiside-theme.css" "resources/app/out/vs/workbench/browser/media/my-custom-theme.css"
elif [ "$choice" = "3" ]; then
    echo "Applying BloodCode theme..."
    cp "themes/bloodcode-theme.css" "resources/app/out/vs/workbench/browser/media/my-custom-theme.css"
else
    echo "Invalid choice. Using default HorusCode theme."
    cp "themes/horuscode-theme.css" "resources/app/out/vs/workbench/browser/media/my-custom-theme.css"
fi

echo ""
echo "Theme applied. Starting Horus Code..."
echo "==================================================="
./codium
EOF

# Create launcher script
echo "Creating launcher script..."
cat > "$PORTABLE_DIR/launch.sh" << 'EOF'
#!/bin/bash

echo "==================================================="
echo "Starting Horus Code with HorusCode theme..."
echo "==================================================="
./codium
EOF

# Make scripts executable
chmod +x "$PORTABLE_DIR/theme-switcher.sh"
chmod +x "$PORTABLE_DIR/launch.sh"

# Create README file
echo "Creating README file..."
cat > "$PORTABLE_DIR/README.md" << 'EOF'
# Horus Code - Portable Edition for Linux

This portable package contains three custom-themed versions of Visual Studio Code:

## The Editors

1. **HorusCode** - Egyptian-themed editor with gold accents and the Eye of Horus
2. **BorealisIDE** - Northern Lights-inspired editor with blues and teals
3. **BloodCode** - Dark and dramatic editor with Oxblood Red and Pitch Black

## How to Use

1. Run `./theme-switcher.sh` to select a theme and launch the application
2. Or run `./launch.sh` to start with the default HorusCode theme

## Features

- Multiple beautiful themes to choose from
- Custom icons and styling
- Portable - no installation required
- All the power of VS Code in a customized package

## Installation

No installation required! This is a portable version that can be run from any location.

1. Copy this entire folder to any location
2. Run one of the shell scripts to start the application

## Notes

- Your settings and extensions will be stored within this folder
- This makes it easy to carry your development environment with you
EOF

# Clean up
echo "Cleaning up..."
rm vscodium.tar.gz

echo "Build completed!"
echo "Portable version is available in the '$PORTABLE_DIR' directory"
echo "To use Horus Code:"
echo "1. Run './theme-switcher.sh' to select a theme and launch the application"
echo "2. Or run './launch.sh' to start with the default HorusCode theme"
