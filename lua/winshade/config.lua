local M = {}

local defaults = {
	fade_amount = 0.3,
	excluded_filetypes = {},
	excluded_buftypes = {},
	ignore_floating = true,
}

M.options = {}
M.enabled = false

M.setup = function(opts)
	M.options = vim.tbl_deep_extend("force", defaults, opts or {})
	M.enabled = true
end

M.get = function(key)
	return M.options[key]
end

M.is_enabled = function()
	return M.enabled
end

M.should_exclude_window = function(winid)
	local bufnr = vim.api.nvim_win_get_buf(winid)
	local filetype = vim.bo[bufnr].filetype
	local buftype = vim.bo[bufnr].buftype

	-- Check if filetype is excluded
	if vim.tbl_contains(M.options.excluded_filetypes, filetype) then
		return true
	end

	-- Check if buftype is excluded
	if vim.tbl_contains(M.options.excluded_buftypes, buftype) then
		return true
	end

	-- Check if floating window should be ignored
	if M.options.ignore_floating then
		local win_config = vim.api.nvim_win_get_config(winid)
		if win_config.relative ~= "" and (win_config.zindex or 50) > 50 then
			return true
		end
	end

	return false
end

return M
