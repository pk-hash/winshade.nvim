local M = {}

local config = require("winshade.config")
local highlight = require("winshade.highlight")
local autocmd = require("winshade.autocmd")

M.setup = function(opts)
	config.setup(opts)
	highlight.setup()
	autocmd.setup()
	M.enable()
end

M.enable = function()
	autocmd.enable()
	highlight.apply_to_inactive_windows()
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
