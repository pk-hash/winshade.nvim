local M = {}

local config = require("winshade.config")
local highlight = require("winshade.highlight")
local autocmd = require("winshade.autocmd")

local setup_called = false

M.setup = function(opts)
	if setup_called then
		vim.notify("winshade: setup() already called, ignoring", vim.log.levels.WARN)
		return
	end
	setup_called = true

	config.setup(opts or {})
	highlight.setup()
	autocmd.setup()
	M.enable()
end

M.enable = function()
	autocmd.enable()
	highlight.apply_to_all_inactive_windows()
end

M.disable = function()
	autocmd.disable()
	highlight.clear_all_windows()
end

M.toggle = function()
	if config.is_enabled() then
		M.disable()
	else
		M.enable()
	end
end

return M
