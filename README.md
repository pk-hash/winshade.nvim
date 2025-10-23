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

```lua
{
  "yourusername/winshade",
  config = function()
    require("winshade").setup({
      -- your configuration here
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
})
```

### Example with exclusions

```lua
require("winshade").setup({
  fade_amount = 0.4,
  excluded_filetypes = { "NvimTree", "neo-tree", "dashboard" },
  excluded_buftypes = { "terminal" },
})
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

## 📝 License

MIT

## 🤝 Contributing

Contributions are welcome! Please follow [Conventional Commits](https://www.conventionalcommits.org/) for commit messages.
