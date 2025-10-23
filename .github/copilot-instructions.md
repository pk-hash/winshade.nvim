# Copilot Instructions for Winshade

## Project Overview
Winshade is a Neovim Lua plugin that automatically fades (shades) inactive windows to help users focus on the active window. It's designed to work with lazy.nvim plugin manager.

## Code Style and Conventions

### Lua Style
- Use 2 spaces for indentation
- Use snake_case for function and variable names
- Use PascalCase for module names
- Prefer local variables and functions
- Add type annotations in comments where helpful
- Keep functions small and focused

### Commit Messages
- Follow Conventional Commits specification
- Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`
- Format: `type(scope): subject`
- Examples:
  - `feat(core): add window fade functionality`
  - `fix(highlight): correct opacity calculation`
  - `docs(readme): update installation instructions`

## Project Structure
```
winshade/
├── lua/
│   └── winshade/
│       ├── init.lua          # Main entry point
│       ├── config.lua        # Configuration management
│       ├── highlight.lua     # Highlight group management
│       └── autocmd.lua       # Autocommand setup
├── plugin/
│   └── winshade.lua          # Plugin initialization
├── doc/
│   └── winshade.txt          # Vim help documentation
├── README.md
├── LICENSE
└── .github/
    └── copilot-instructions.md
```

## Architecture Guidelines

### Module Design
- **init.lua**: Main module, exports setup function
- **config.lua**: Handle user configuration and defaults
- **highlight.lua**: Manage highlight groups and window shading
- **autocmd.lua**: Set up autocommands for window events

### Key Concepts
- Use `WinEnter` and `WinLeave` autocommands to detect window changes
- Apply shading via highlight groups and `winhighlight` option
- Support for multiple colorschemes
- Efficient - avoid unnecessary redraws

### Configuration
Default configuration structure:
```lua
{
  fade_amount = 0.3,        -- Amount to fade (0.0 to 1.0)
  excluded_filetypes = {},  -- Filetypes to exclude
  excluded_buftypes = {},   -- Buffer types to exclude
  ignore_floating = true,   -- Don't shade floating windows
}
```

## API Design
- `setup(opts)`: Initialize plugin with user configuration
- `enable()`: Enable window shading
- `disable()`: Disable window shading
- `toggle()`: Toggle window shading

## Testing Considerations
- Test with different colorschemes
- Test with split windows, tabs, and floating windows
- Test with excluded filetypes (e.g., NvimTree, Telescope)
- Verify performance with many windows open

## Dependencies
- Neovim >= 0.8.0 (for newer Lua API features)
- lazy.nvim for plugin management

## Best Practices
- Use `vim.api` for Neovim API calls
- Use `vim.fn` sparingly, prefer Lua APIs
- Handle errors gracefully with pcall/xpcall
- Validate user configuration
- Provide helpful error messages
- Document all public functions
