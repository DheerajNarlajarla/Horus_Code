<div id="custom-editors-logo" align="center">
    <br />
    <img src="./icons/stable/mycode_cnl.svg" alt="Horus Code Logo" width="200"/>
    <h1>Horus Code Project</h1>
    <h3>Three Uniquely Themed Code Editors Based on VSCodium</h3>
</div>

<div id="editors" align="center">
    <table>
        <tr>
            <td align="center"><strong>HorusCode</strong></td>
            <td align="center"><strong>BorealisIDE</strong></td>
            <td align="center"><strong>BloodCode</strong></td>
        </tr>
        <tr>
            <td align="center">Egyptian-themed with gold accents</td>
            <td align="center">Northern Lights-inspired blues and teals</td>
            <td align="center">Dark and dramatic with Oxblood Red</td>
        </tr>
    </table>
</div>

**This project provides three custom-themed versions of Visual Studio Code, each with its own unique aesthetic and branding. Built on top of the open-source VSCodium project, which provides freely-licensed binaries of VS Code without Microsoft branding/telemetry/licensing.**

## Table of Contents

- [The Editors](#the-editors)
- [Features](#features)
- [Build](#build)
- [Theme Switching](#theme-switching)
- [Customization](#customization)
- [Documentation](#documentation)

## <a id="the-editors"></a>The Editors

This project provides three custom-themed versions of Visual Studio Code:

1. **HorusCode** - Egyptian-themed editor with gold accents and the Eye of Horus
   - Primary Color: Gold (#E6A23C)
   - Background: Dark black/gray
   - Inspiration: Ancient Egyptian art and the Eye of Horus

2. **BorealisIDE** - Northern Lights-inspired editor with blues and teals
   - Primary Color: Teal (#56B6C2)
   - Background: Deep blue (#0E1621)
   - Special Effect: Rainbow gradient line at the top of the editor
   - Inspiration: The colors of the Northern Lights

3. **BloodCode** - Dark and dramatic editor with Oxblood Red and Pitch Black
   - Primary Color: Oxblood Red (#6B0F1A)
   - Background: Pitch Black (#0A0A0A)
   - Special Effect: Blood drip styling at the top of the editor
   - Inspiration: Dark, dramatic aesthetics

## <a id="features"></a>Features

- **Multiple Beautiful Themes**: Three distinct visual styles to choose from
- **Custom Icons**: Unique application icon featuring the Eye of Horus
- **Theme Switcher**: Easily switch between themes with the built-in theme switcher
- **All VSCode Features**: Retains all the powerful features of Visual Studio Code
- **Telemetry-Free**: Based on VSCodium, with Microsoft telemetry disabled


## <a id="build"></a>Build

To build the custom editors:

1. Ensure you have the following prerequisites installed:
   - Git
   - Node.js (version 20.x or later)
   - Python
   - C/C++ build tools for your platform

2. Clone this repository:
   ```bash
   git clone https://github.com/DheerajNarlajarla/Horus_Code.git
   cd Horus_Code
   ```

3. Run one of the build scripts:

   **Portable Build (Recommended):**
   ```bash
   # On Windows
   .\build_portable.bat

   # On Linux
   ./build_linux.sh
   ```
   This will download VSCodium and create a portable version with all three themes.

   **Installer Build (Advanced):**
   ```bash
   # On Windows
   .\build_installer.bat
   ```

4. The build process will take some time. Once completed:
   - For the portable build: Navigate to the "horus_portable" directory
   - For the installer build: Find the installer in the "horus_installer" directory

## <a id="theme-switching"></a>Theme Switching

The application includes a built-in theme switcher that allows you to easily switch between the three themes:

- **HorusCode**: Egyptian theme with gold accents
- **BorealisIDE**: Northern Lights theme with blues and teals
- **BloodCode**: Dark Gore theme with Oxblood Red and Pitch Black

The theme switcher appears as a set of buttons in the bottom-right corner of the editor. Your theme preference is saved between sessions.

## <a id="customization"></a>Customization

This project includes several customizations:

1. **Application Branding**: Three distinct editor identities
2. **Custom Icons**: Unique icons for each theme
3. **Multiple Custom CSS Themes**:
   - **HorusCode**: Dark theme with gold accents inspired by ancient Egyptian aesthetics
   - **BorealisIDE**: Beautiful blues and teals inspired by the Northern Lights
   - **BloodCode**: Dramatic Oxblood Red and Pitch Black for a bold, intense look
4. **Theme Switcher**: A convenient UI element to switch between themes
5. **Custom Fonts**: Support for special fonts where available

## <a id="documentation"></a>Documentation

For detailed information about the editors, themes, and customization options, see [CUSTOM-EDITORS.md](CUSTOM-EDITORS.md).

## <a id="license"></a>License

This project is released under the MIT License, the same as VSCodium and VS Code - OSS.

## <a id="credits"></a>Credits

- Based on [VSCodium](https://github.com/VSCodium/vscodium)
- Built from [Microsoft's VS Code](https://github.com/microsoft/vscode)
- Custom themes and icons created for this project
