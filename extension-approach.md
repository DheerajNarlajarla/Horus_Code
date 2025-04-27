# Using VSCode Extensions for Custom Themes

If you're encountering issues with the full build process, you can use a simpler approach by creating VSCode extensions for each theme. This approach doesn't require rebuilding VSCode from source and is much easier to implement.

## Creating Theme Extensions

### 1. Install VSCode Extension Generator

```bash
npm install -g yo generator-code
```

### 2. Generate a Theme Extension for Each Theme

For each theme (HorusCode, BorealisIDE, BloodCode), follow these steps:

```bash
# Create a directory for the extension
mkdir horuscode-theme
cd horuscode-theme

# Run the extension generator
yo code

# Select "New Color Theme"
# Then select "Start fresh"
# Fill in the extension details
```

### 3. Copy Theme Files

Copy the CSS content from each theme file into the appropriate theme JSON file:

- `horuscode-theme.css` → `themes/horuscode-color-theme.json`
- `borealiside-theme.css` → `themes/borealiside-color-theme.json`
- `bloodcode-theme.css` → `themes/bloodcode-color-theme.json`

You'll need to convert the CSS to the VSCode theme JSON format.

### 4. Package the Extensions

```bash
# Install vsce
npm install -g vsce

# Package the extension
vsce package
```

This will create a `.vsix` file that you can install in VSCode.

### 5. Install the Extensions

In VSCode:
1. Go to Extensions view (Ctrl+Shift+X)
2. Click on the "..." menu
3. Select "Install from VSIX..."
4. Choose the `.vsix` file you created

## Using Custom CSS and JS Loader Extension

An even simpler approach is to use the "Custom CSS and JS Loader" extension:

1. Install the [Custom CSS and JS Loader](https://marketplace.visualstudio.com/items?itemName=be5invis.vscode-custom-css) extension
2. Configure it to load your custom CSS files:

```json
{
    "vscode_custom_css.imports": [
        "file:///path/to/horuscode-theme.css"
        // or
        // "file:///path/to/borealiside-theme.css"
        // "file:///path/to/bloodcode-theme.css"
    ]
}
```

3. Run the "Reload Custom CSS and JS" command

This approach allows you to use your custom CSS without rebuilding VSCode.

## Creating a Theme Switcher Extension

You can also create a simple extension that adds a theme switcher to VSCode:

1. Generate a new extension:
```bash
yo code
# Select "New Extension (TypeScript)"
```

2. Implement a command that switches between your custom CSS files
3. Add a status bar item that shows the current theme and allows switching

This would provide a similar experience to the theme switcher in the full build, but without requiring a complete rebuild of VSCode.
