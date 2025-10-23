local M = {}

local config = require("winshade.config")

local ns_id = vim.api.nvim_create_namespace("winshade")

local function blend_colors(fg, bg, alpha)
	if not fg or not bg then
		return bg
	end

	local fg_r = bit.rshift(bit.band(fg, 0xFF0000), 16)
	local fg_g = bit.rshift(bit.band(fg, 0x00FF00), 8)
	local fg_b = bit.band(fg, 0x0000FF)

	local bg_r = bit.rshift(bit.band(bg, 0xFF0000), 16)
	local bg_g = bit.rshift(bit.band(bg, 0x00FF00), 8)
	local bg_b = bit.band(bg, 0x0000FF)

	local r = math.floor(fg_r * (1 - alpha) + bg_r * alpha)
	local g = math.floor(fg_g * (1 - alpha) + bg_g * alpha)
	local b = math.floor(fg_b * (1 - alpha) + bg_b * alpha)

	return bit.bor(bit.lshift(r, 16), bit.lshift(g, 8), b)
end

local function get_hl_value(hl_name, attr)
	local hl = vim.api.nvim_get_hl(0, { name = hl_name })
	return hl[attr]
end

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

M.setup = function()
	local fade_amount = config.get("fade_amount")
	local bg = get_background_color()

	local all_highlights = vim.api.nvim_get_hl(0, {})

	local excluded_highlights = {
		"TabLineSel",
		"Pmenu",
		"PmenuSel",
		"PmenuKind",
		"PmenuKindSel",
		"PmenuExtra",
		"PmenuExtraSel",
		"PmenuSbar",
		"PmenuThumb",
		"StatusLine",
	}

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

M.apply_to_window = function(winid)
	if not vim.api.nvim_win_is_valid(winid) then
		return
	end

	if config.should_exclude_window(winid) then
		return
	end

	vim.api.nvim_win_set_hl_ns(winid, ns_id)

	-- Apply to terminal windows by fading terminal colors
	local bufnr = vim.api.nvim_win_get_buf(winid)
	if vim.bo[bufnr].buftype == "terminal" then
		local fade_amount = config.get("fade_amount")
		local bg = get_background_color()
		
		-- Fade terminal color palette
		for i = 0, 15 do
			local color_var = "terminal_color_" .. i
			local original_color = vim.g[color_var]
			if original_color then
				local color_num = tonumber(original_color:gsub("#", ""), 16)
				if color_num then
					local faded = blend_colors(color_num, bg, fade_amount)
					vim.api.nvim_buf_set_var(bufnr, color_var, string.format("#%06x", faded))
				end
			end
		end
	end
end

M.clear_window = function(winid)
	if not vim.api.nvim_win_is_valid(winid) then
		return
	end

	vim.api.nvim_win_set_hl_ns(winid, 0)

	-- Clear terminal colors by removing buffer-local overrides
	local bufnr = vim.api.nvim_win_get_buf(winid)
	if vim.bo[bufnr].buftype == "terminal" then
		for i = 0, 15 do
			local color_var = "terminal_color_" .. i
			pcall(vim.api.nvim_buf_del_var, bufnr, color_var)
		end
	end
end

M.apply_to_inactive_windows = function()
	local current_win = vim.api.nvim_get_current_win()
	local wins = vim.api.nvim_list_wins()

	for _, winid in ipairs(wins) do
		if vim.api.nvim_win_is_valid(winid) then
			if winid ~= current_win then
				M.apply_to_window(winid)
			else
				M.clear_window(winid)
			end
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
