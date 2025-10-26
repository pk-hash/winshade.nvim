local M = {}

--- User-provided configuration (all fields optional)
---@class winshade.Config
---@field fade_amount? number Amount to fade inactive windows (0.0 to 1.0). Default: 0.3
---@field excluded_filetypes? string[] List of filetypes to exclude from fading
---@field excluded_buftypes? string[] List of buffer types to exclude from fading
---@field ignore_floating? boolean Don't shade floating windows. Default: true
---@field floating_zindex_threshold? number Threshold for floating window z-index. Default: 50
---@field debug? boolean Enable debug mode. Default: false
---@field debounce_ms? number Debounce time in milliseconds for window changes. Default: 10
---@field excluded_highlights? string[] Additional highlight groups to exclude from fading

--- Resolved configuration (all fields guaranteed to exist after setup)
---@class winshade.ResolvedConfig
---@field fade_amount number Amount to fade inactive windows (0.0 to 1.0)
---@field excluded_filetypes string[] List of filetypes to exclude from fading
---@field excluded_buftypes string[] List of buffer types to exclude from fading
---@field ignore_floating boolean Don't shade floating windows
---@field floating_zindex_threshold number Threshold for floating window z-index
---@field debug boolean Enable debug mode
---@field debounce_ms number Debounce time in milliseconds for window changes
---@field excluded_highlights string[] List of highlight groups to exclude from fading

---@type winshade.ResolvedConfig
local defaults = {
	fade_amount = 0.3,
	excluded_filetypes = {},
	excluded_buftypes = {},
	ignore_floating = true,
	floating_zindex_threshold = 50,
	debug = false,
	debounce_ms = 10,
	excluded_highlights = {
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
}

M.defaults = defaults

return M
