local M = {}

local highlight = require("winshade.highlight")

local augroup = nil
local debounce_timer = nil

local function debounced_apply()
	if debounce_timer then
		debounce_timer:stop()
	end
	debounce_timer = vim.defer_fn(function()
		highlight.apply_to_inactive_windows()
		debounce_timer = nil
	end, 10)
end

M.setup = function()
	augroup = vim.api.nvim_create_augroup("Winshade", { clear = true })
	M.enable()
end

M.enable = function()
	if not augroup then
		augroup = vim.api.nvim_create_augroup("Winshade", { clear = true })
	end

	-- Use debounced version for frequent events
	vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
		group = augroup,
		callback = debounced_apply,
	})

	-- FocusGained should apply to all windows immediately
	vim.api.nvim_create_autocmd("FocusGained", {
		group = augroup,
		callback = function()
			vim.schedule(function()
				highlight.apply_to_all_inactive_windows()
			end)
		end,
	})

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = augroup,
		callback = function()
			highlight.setup()
			vim.schedule(function()
				highlight.apply_to_all_inactive_windows()
			end)
		end,
	})
end

M.disable = function()
	if debounce_timer then
		debounce_timer:stop()
		debounce_timer = nil
	end
	if augroup then
		vim.api.nvim_clear_autocmds({ group = augroup })
	end
end

return M
