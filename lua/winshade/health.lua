local M = {}

M.check = function()
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
	vim.health.ok(string.format("Fade amount: %.2f", config.get("fade_amount")))

	-- Check for excluded filetypes
	local excluded_ft = config.get("excluded_filetypes")
	if excluded_ft and #excluded_ft > 0 then
		vim.health.info(string.format("Excluded filetypes: %s", table.concat(excluded_ft, ", ")))
	end

	-- Check for excluded buftypes
	local excluded_bt = config.get("excluded_buftypes")
	if excluded_bt and #excluded_bt > 0 then
		vim.health.info(string.format("Excluded buftypes: %s", table.concat(excluded_bt, ", ")))
	end

	-- Check floating window settings
	if config.get("ignore_floating") then
		vim.health.ok(
			string.format("Ignoring floating windows with zindex > %d", config.get("floating_zindex_threshold"))
		)
	else
		vim.health.info("Floating windows are not ignored")
	end
end

return M
