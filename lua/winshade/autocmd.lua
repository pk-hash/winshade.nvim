---@class winshade.autocmd
local M = {}

local config = require("winshade.config")
local highlight = require("winshade.highlight")

---@type number?
local augroup = nil
---@type table?
local debounce_timer = nil

local function debounced_apply()
	if debounce_timer then
		debounce_timer:stop()
	end
	local debounce_time = config.options.debounce_ms
	debounce_timer = vim.defer_fn(function()
		highlight.apply_to_inactive_windows()
		debounce_timer = nil
	end, debounce_time)
end

--- Setup autocommands
function M.setup()
	augroup = vim.api.nvim_create_augroup("Winshade", { clear = true })
	M.enable()
end

--- Enable autocommands
function M.enable()
	if not augroup then
		augroup = vim.api.nvim_create_augroup("Winshade", { clear = true })
	end

	config.set_enabled(true)

	-- Use debounced version for frequent events
	vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "WinNew" }, {
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

	vim.api.nvim_create_autocmd("WinClosed", {
		group = augroup,
		callback = function(args)
			local winid = tonumber(args.match)
			if winid then
				highlight.cleanup_window(winid)
			end
		end,
	})
end

--- Disable autocommands
function M.disable()
	if debounce_timer then
		debounce_timer:stop()
		debounce_timer = nil
	end
	if augroup then
		vim.api.nvim_clear_autocmds({ group = augroup })
	end
	config.set_enabled(false)
end

return M
