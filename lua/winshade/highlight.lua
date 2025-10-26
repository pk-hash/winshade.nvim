---@class winshade.highlight
local M = {}

local config = require("winshade.config")

local ns_id = vim.api.nvim_create_namespace("winshade")
---@type string?
local last_colorscheme = nil

---@param fg number
---@param bg number
---@param alpha number
---@return number
local function blend_colors(fg, bg, alpha)
	if not fg or not bg then
		return bg
	end

	---@diagnostic disable-next-line: deprecated
	local bitlib = vim.bit or bit
	local fg_r = bitlib.rshift(bitlib.band(fg, 0xFF0000), 16)
	local fg_g = bitlib.rshift(bitlib.band(fg, 0x00FF00), 8)
	local fg_b = bitlib.band(fg, 0x0000FF)

	local bg_r = bitlib.rshift(bitlib.band(bg, 0xFF0000), 16)
	local bg_g = bitlib.rshift(bitlib.band(bg, 0x00FF00), 8)
	local bg_b = bitlib.band(bg, 0x0000FF)

	local r = math.floor(fg_r * (1 - alpha) + bg_r * alpha)
	local g = math.floor(fg_g * (1 - alpha) + bg_g * alpha)
	local b = math.floor(fg_b * (1 - alpha) + bg_b * alpha)

	return bitlib.bor(bitlib.lshift(r, 16), bitlib.lshift(g, 8), b)
end

---@param hl_name string
---@param attr string
---@return any
local function get_hl_value(hl_name, attr)
	local hl = vim.api.nvim_get_hl(0, { name = hl_name })
	return hl[attr]
end

---@return number
local function get_background_color()
	local bg = get_hl_value("Normal", "bg")
	if not bg then
		if vim.o.background == "dark" then
			bg = 0x000000
		else
			bg = 0xFFFFFF
		end
	end
	return bg
end

--- Setup highlight groups based on current colorscheme
function M.setup()
	local current = vim.g.colors_name
	if current == last_colorscheme then
		return
	end
	last_colorscheme = current

	local fade_amount = config.options.fade_amount
	local bg = get_background_color()

	local all_highlights = vim.api.nvim_get_hl(0, {})

	-- Get excluded highlights from config
	local excluded_highlights = config.options.excluded_highlights

	for hl_name, hl_def in pairs(all_highlights) do
		if
			type(hl_name) == "string"
			and not hl_name:match("^winshade")
			and not vim.tbl_contains(excluded_highlights, hl_name)
		then
			local faded_hl = {}

			if hl_def.fg then
				faded_hl.fg = blend_colors(hl_def.fg, bg, fade_amount)
			end

			if hl_def.bg then
				faded_hl.bg = blend_colors(hl_def.bg, bg, fade_amount)
			end

			if hl_def.sp then
				faded_hl.sp = blend_colors(hl_def.sp, bg, fade_amount)
			end

			for _, attr in ipairs({ "bold", "italic", "underline", "undercurl", "strikethrough", "reverse" }) do
				if hl_def[attr] then
					faded_hl[attr] = hl_def[attr]
				end
			end

			if hl_def.link then
				faded_hl.link = hl_def.link
			end

			if next(faded_hl) then
				vim.api.nvim_set_hl(ns_id, hl_name, faded_hl)
			end
		end
	end
end

---@type table<number, number>
local terminal_matches = {}

--- Apply shading to a specific window
---@param winid number
function M.apply_to_window(winid)
	if not vim.api.nvim_win_is_valid(winid) then
		return
	end

	local ok, err = pcall(function()
		if config.should_exclude_window(winid) then
			return
		end

		vim.api.nvim_win_set_hl_ns(winid, ns_id)

		-- Apply to terminal windows using matchadd overlay
		local bufnr = vim.api.nvim_win_get_buf(winid)
		if vim.bo[bufnr].buftype == "terminal" then
			if not terminal_matches[winid] then
				---@diagnostic disable-next-line: param-type-mismatch
				terminal_matches[winid] = vim.fn.matchadd("Normal", ".*", 0, -1, { window = winid })
			end
		end
	end)

	if not ok then
		local bufnr = vim.api.nvim_win_is_valid(winid) and vim.api.nvim_win_get_buf(winid) or -1
		local msg =
			string.format("winshade: error applying highlight to window %d (buf %d) - %s", winid, bufnr, tostring(err))
		vim.notify(msg, vim.log.levels.DEBUG)
	end
end

--- Clear shading from a specific window
---@param winid number
function M.clear_window(winid)
	if not vim.api.nvim_win_is_valid(winid) then
		-- Clean up terminal match tracking for invalid windows
		terminal_matches[winid] = nil
		return
	end

	vim.api.nvim_win_set_hl_ns(winid, 0)

	-- Clear terminal match overlay
	if terminal_matches[winid] then
		pcall(vim.fn.matchdelete, terminal_matches[winid], winid)
		terminal_matches[winid] = nil
	end
end

--- Cleanup tracking for a window
---@param winid number
function M.cleanup_window(winid)
	if terminal_matches[winid] then
		terminal_matches[winid] = nil
	end
end

---@type number?
local last_active_win = nil

--- Apply shading to all inactive windows (optimized for window switching)
function M.apply_to_inactive_windows()
	local current_win = vim.api.nvim_get_current_win()

	-- Clear the previously active window
	if last_active_win and last_active_win ~= current_win and vim.api.nvim_win_is_valid(last_active_win) then
		M.apply_to_window(last_active_win)
	end

	-- Clear the newly active window
	M.clear_window(current_win)

	last_active_win = current_win
end

--- Apply shading to all inactive windows (full refresh)
function M.apply_to_all_inactive_windows()
	---@diagnostic disable-next-line: deprecated
	local uv = vim.uv or vim.loop
	local start = config.options.debug and uv.hrtime() or nil

	local current_win = vim.api.nvim_get_current_win()
	local wins = vim.api.nvim_list_wins()

	for _, winid in ipairs(wins) do
		if winid ~= current_win then
			M.apply_to_window(winid)
		else
			M.clear_window(winid)
		end
	end

	last_active_win = current_win

	if start then
		local elapsed = (uv.hrtime() - start) / 1e6
		vim.notify(string.format("winshade: applied to %d windows in %.2fms", #wins, elapsed), vim.log.levels.DEBUG)
	end
end

--- Clear shading from all windows
function M.clear_all_windows()
	local wins = vim.api.nvim_list_wins()
	for _, winid in ipairs(wins) do
		M.clear_window(winid)
	end
end

return M
