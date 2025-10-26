---@class winshade.config
local M = {}

local defaults ---@type winshade.ResolvedConfig?

---@type winshade.ResolvedConfig
M.options = {} ---@diagnostic disable-line: missing-fields

---@type boolean
M.enabled = false

--- Get the merged configuration
---@param opts? winshade.Config
---@return winshade.ResolvedConfig
function M.get(opts)
	if not defaults then
		defaults = require("winshade.config.defaults").defaults
	end

	if not opts then
		return M.options
	end

	return vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts) ---@type winshade.ResolvedConfig
end

--- Setup the configuration
---@param opts? winshade.Config
function M.setup(opts)
	M.options = M.get(opts)
	M.enabled = true
end

--- Check if winshade is enabled
---@return boolean
function M.is_enabled()
	return M.enabled
end

--- Set enabled state
---@param enabled boolean
function M.set_enabled(enabled)
	M.enabled = enabled
end

--- Check if a window should be excluded from shading
---@param winid number
---@return boolean
function M.should_exclude_window(winid)
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
		if win_config.relative ~= "" then
			local threshold = M.options.floating_zindex_threshold
			local zindex = win_config.zindex or 0
			if zindex > threshold then
				return true
			end
		end
	end

	return false
end

return M
