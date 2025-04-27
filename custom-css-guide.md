# Using Custom CSS and JS Loader for Theme Customization

This guide explains how to use the Custom CSS and JS Loader extension to apply our custom themes (HorusCode, BorealisIDE, and BloodCode) without rebuilding VSCode.

## Prerequisites

1. Install [Visual Studio Code](https://code.visualstudio.com/) or [VSCodium](https://vscodium.com/)
2. Install the [Custom CSS and JS Loader](https://marketplace.visualstudio.com/items?itemName=be5invis.vscode-custom-css) extension

## Setup

### 1. Prepare the CSS Files

First, make sure you have the CSS files for each theme in a location accessible to VSCode:

- `horuscode-theme.css`
- `borealiside-theme.css`
- `bloodcode-theme.css`

You can copy these files to a convenient location, such as:
- Windows: `C:\Users\YourUsername\Documents\VSCodeThemes\`
- macOS: `/Users/YourUsername/Documents/VSCodeThemes/`
- Linux: `/home/YourUsername/Documents/VSCodeThemes/`

### 2. Configure the Extension

1. Open VSCode settings (File > Preferences > Settings or Ctrl+,)
2. Search for "custom css"
3. Click "Edit in settings.json"
4. Add the following configuration (adjust the file paths to match your system):

```json
{
    "vscode_custom_css.imports": [
        "file:///C:/Users/YourUsername/Documents/VSCodeThemes/horuscode-theme.css"
        // Uncomment one of these to switch themes:
        // "file:///C:/Users/YourUsername/Documents/VSCodeThemes/borealiside-theme.css"
        // "file:///C:/Users/YourUsername/Documents/VSCodeThemes/bloodcode-theme.css"
    ]
}
```

### 3. Apply the Theme

1. Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on macOS) to open the Command Palette
2. Type "Reload Custom CSS and JS" and select the command
3. VSCode will prompt you to restart - click "Restart"

## Switching Themes

To switch between themes:

1. Open your settings.json file
2. Comment out the current theme and uncomment the theme you want to use
3. Save the file
4. Run the "Reload Custom CSS and JS" command again
5. Restart VSCode

## Creating a Theme Switcher

For a more convenient way to switch themes, you could create a simple extension that adds commands to switch between themes. The extension would:

1. Add commands like "Switch to HorusCode Theme", "Switch to BorealisIDE Theme", etc.
2. Each command would update the settings.json file and reload the custom CSS
3. Add a status bar item to show the current theme and allow quick switching

## Troubleshooting

### If the theme doesn't apply:

1. Make sure the file paths in your settings.json are correct
2. Check that you've run the "Reload Custom CSS and JS" command
3. Try running VSCode as administrator (Windows) or with sudo (Linux)
4. On macOS, you might need to disable System Integrity Protection or use an alternative approach

### If VSCode shows warnings about unsupported modifications:

This is normal. The Custom CSS and JS Loader extension modifies VSCode in ways not officially supported. You can safely ignore these warnings.

## Notes

- When VSCode updates, you might need to reapply the custom CSS
- This approach doesn't change the application name or icon, only the UI appearance
- For a complete rebrand including name and icon changes, you would need to build from source as described in the main documentation
