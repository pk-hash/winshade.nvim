# 🪟 Winshade

A Neovim plugin that automatically fades inactive windows to help you focus on what matters.

## ✨ Features

- 🎨 Automatically shades inactive windows
- ⚡ Lightweight and performant
- 🎛️ Configurable fade amount
- 🚫 Exclude specific filetypes and buffer types
- 🪟 Smart handling of floating windows
- 🌈 Works with any colorscheme

## 📦 Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

Basic installation:

```lua
{
  "yourusername/winshade",
  event = "VeryLazy",
  config = function()
    require("winshade").setup()
  end,
}
```

With custom configuration:

```lua
{
  "yourusername/winshade",
  event = "VeryLazy",
  opts = {
    fade_amount = 0.3,
    excluded_filetypes = { "NvimTree", "neo-tree" },
  },
}
```

Or load on specific events:

```lua
{
  "yourusername/winshade",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("winshade").setup({
      fade_amount = 0.4,
    })
  end,
}
```

## ⚙️ Configuration

Default configuration:

```lua
require("winshade").setup({
  fade_amount = 0.3,             -- Amount to fade inactive windows (0.0 to 1.0)
  excluded_filetypes = {},       -- Filetypes to exclude from shading
  excluded_buftypes = {},        -- Buffer types to exclude from shading
  ignore_floating = true,        -- Don't shade floating windows
  floating_zindex_threshold = 50, -- Exclude floating windows with z-index > this value
  debug = false,                 -- Enable performance monitoring
  debounce_ms = 10,              -- Debounce time for window events (milliseconds)
  excluded_highlights = {        -- UI highlight groups to exclude from fading
    "TabLineSel",
    "Pmenu",
    "PmenuSel",
    "PmenuKind",
    "PmenuKindSel",
    "PmenuExtra",
    "PmenuExtraSel",
    "PmenuSbar",
    "PmenuThumb",
    "StatusLine",
  },
})
```

### Example with exclusions

```lua
require("winshade").setup({
  fade_amount = 0.4,
  excluded_filetypes = { "NvimTree", "neo-tree", "dashboard" },
  excluded_buftypes = { "terminal" },
  excluded_highlights = { "TabLineSel", "Pmenu", "StatusLine" }, -- Custom UI elements to exclude
})
```

## 🩺 Health Check

Run `:checkhealth winshade` to verify your installation and view current configuration.

## 🐛 Debugging

Enable debug mode to see performance metrics as notifications:

```lua
require("winshade").setup({
  debug = true,
})
```

You'll see timing information displayed as notifications:
```
winshade: applied to 5 windows in 1.23ms
```

## 🎮 Commands

- `:WinshadeEnable` - Enable window shading
- `:WinshadeDisable` - Disable window shading
- `:WinshadeToggle` - Toggle window shading

## 📚 API

```lua
local winshade = require("winshade")

-- Initialize the plugin
winshade.setup(config)

-- Enable/disable programmatically
winshade.enable()
winshade.disable()
winshade.toggle()
```

## 🔧 Requirements

- Neovim >= 0.8.0

## 🧪 Testing

This plugin includes automated tests.

To run tests:
```bash
make test
```

See [tests/README.md](tests/README.md) for more information.

## 📝 License

MIT

## 🤝 Contributing

Contributions are welcome! Please follow [Conventional Commits](https://www.conventionalcommits.org/) for commit messages.
