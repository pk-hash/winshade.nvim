---@class winshade
local M = {}

local config = require("winshade.config")
local highlight = require("winshade.highlight")
local autocmd = require("winshade.autocmd")

local setup_called = false

--- Setup winshade with the given configuration
---@param opts? winshade.Config
function M.setup(opts)
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

--- Enable window shading
function M.enable()
	config.set_enabled(true)
	autocmd.enable()
	highlight.apply_to_all_inactive_windows()
end

--- Disable window shading
function M.disable()
	config.set_enabled(false)
	autocmd.disable()
	highlight.clear_all_windows()
end

--- Toggle window shading
function M.toggle()
	if config.is_enabled() then
		M.disable()
	else
		M.enable()
	end
end

return M
