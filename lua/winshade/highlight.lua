local M = {}

local config = require("winshade.config")

M.setup = function()
	-- TODO: Create highlight groups based on fade_amount
	-- Will need to blend Normal highlight with background
end

M.apply_to_window = function(winid)
	if config.should_exclude_window(winid) then
		return
	end

	-- TODO: Apply winhighlight to fade the window
end

M.clear_window = function(winid)
	-- TODO: Remove winhighlight from window
end

M.apply_to_inactive_windows = function()
	local current_win = vim.api.nvim_get_current_win()
	local wins = vim.api.nvim_list_wins()

	for _, winid in ipairs(wins) do
		if winid ~= current_win then
			M.apply_to_window(winid)
		else
			M.clear_window(winid)
		end
	end
end

M.clear_all_windows = function()
	local wins = vim.api.nvim_list_wins()
	for _, winid in ipairs(wins) do
		M.clear_window(winid)
	end
end

return M
