local M = {}

local highlight = require("winshade.highlight")

local augroup = nil

M.setup = function()
	augroup = vim.api.nvim_create_augroup("Winshade", { clear = true })
	M.enable()
end

M.enable = function()
	if not augroup then
		augroup = vim.api.nvim_create_augroup("Winshade", { clear = true })
	end

	vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
		group = augroup,
		callback = function()
			highlight.apply_to_inactive_windows()
		end,
	})

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = augroup,
		callback = function()
			highlight.setup()
			highlight.apply_to_inactive_windows()
		end,
	})
end

M.disable = function()
	if augroup then
		vim.api.nvim_clear_autocmds({ group = augroup })
	end
end

return M
