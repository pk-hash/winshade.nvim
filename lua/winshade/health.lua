---@class winshade.health
local M = {}

--- Run health checks for winshade
function M.check()
	vim.health.start("winshade")

	-- Check Neovim version
	if vim.fn.has("nvim-0.8.0") == 1 then
		vim.health.ok("Neovim >= 0.8.0")
	else
		vim.health.error("Neovim < 0.8.0", "Update to Neovim 0.8.0 or later")
	end

	-- Check if enabled
	local config = require("winshade.config")
	if config.is_enabled() then
		vim.health.ok("Winshade is enabled")
	else
		vim.health.info("Winshade is disabled")
	end

	-- Check configuration
	local opts = config.options
	vim.health.ok(string.format("Fade amount: %.2f", opts.fade_amount))

	-- Check for excluded filetypes
	if opts.excluded_filetypes and #opts.excluded_filetypes > 0 then
		vim.health.info(string.format("Excluded filetypes: %s", table.concat(opts.excluded_filetypes, ", ")))
	end

	-- Check for excluded buftypes
	if opts.excluded_buftypes and #opts.excluded_buftypes > 0 then
		vim.health.info(string.format("Excluded buftypes: %s", table.concat(opts.excluded_buftypes, ", ")))
	end

	-- Check floating window settings
	if opts.ignore_floating then
		vim.health.ok(string.format("Ignoring floating windows with zindex > %d", opts.floating_zindex_threshold))
	else
		vim.health.info("Floating windows are not ignored")
	end
end

return M
