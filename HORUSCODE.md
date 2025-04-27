# Custom VS Code Editors with Multiple Themes

This project provides three custom-themed versions of Visual Studio Code, each with its own unique aesthetic. Built on top of the open-source VSCodium project, these editors provide freely-licensed binaries of VS Code without Microsoft branding/telemetry/licensing.

## The Editors

- **HorusCode**: Egyptian-themed editor with gold accents and the Eye of Horus
- **BorealisIDE**: Northern Lights-inspired editor with blues and teals
- **BloodCode**: Dark and dramatic editor with Oxblood Red and Pitch Black

## Features

- **Multiple Beautiful Themes**:
  - **HorusCode**: Dark theme with gold accents inspired by ancient Egyptian aesthetics
  - **BorealisIDE**: Inspired by the Northern Lights with blues and teals
  - **BloodCode**: Dramatic Oxblood Red and Pitch Black for a bold look
- **Custom Icons**: Unique icons for each theme
- **Theme Switcher**: Easily switch between themes with the built-in theme switcher
- **All VSCode Features**: Retains all the powerful features of Visual Studio Code

## Building from Source

To build HorusCode from source:

1. Ensure you have the following prerequisites installed:
   - Git
   - Node.js (version 20.x or later)
   - Python
   - C/C++ build tools for your platform

2. Clone this repository:
   ```
   git clone https://github.com/yourusername/horuscode.git
   cd horuscode
   ```

3. Run the build script:
   ```
   ./build_custom.bat  # On Windows
   # OR
   ./build_custom.sh   # On Linux/macOS
   ```

4. The build process will take some time. Once completed, you'll find the built application in the appropriate directory for your platform.

## Customization

This project includes several customizations:

1. **Application Branding**: Three distinct editor identities
2. **Custom Icons**: Unique icons for each theme
3. **Multiple Custom CSS Themes**:
   - **HorusCode**: Dark theme with gold accents inspired by ancient Egyptian aesthetics
   - **BorealisIDE**: Beautiful blues and teals inspired by the Northern Lights
   - **BloodCode**: Dramatic Oxblood Red and Pitch Black for a bold, intense look
4. **Theme Switcher**: A convenient UI element to switch between themes
5. **Custom Fonts**: Support for special fonts where available

### Theme Details

#### HorusCode
- **Primary Color**: Gold (#E6A23C)
- **Background**: Dark black/gray
- **Accents**: Gold highlights and borders
- **Inspiration**: Ancient Egyptian art and the Eye of Horus
- **Special Features**: Support for Egyptian hieroglyphic fonts if available

#### BorealisIDE
- **Primary Color**: Teal (#56B6C2)
- **Background**: Deep blue (#0E1621)
- **Accents**: Various blues and teals
- **Special Effect**: Rainbow gradient line at the top of the editor
- **Inspiration**: The colors of the Northern Lights

#### BloodCode
- **Primary Color**: Oxblood Red (#6B0F1A)
- **Background**: Pitch Black (#0A0A0A)
- **Accents**: Various shades of red
- **Special Effect**: Blood drip styling at the top of the editor
- **Inspiration**: Dark, dramatic aesthetics

## License

HorusCode is released under the MIT License, the same as VSCodium and VS Code - OSS.

## Credits

- Based on [VSCodium](https://github.com/VSCodium/vscodium)
- Built from [Microsoft's VS Code](https://github.com/microsoft/vscode)
- Eye of Horus design inspired by ancient Egyptian symbolism
