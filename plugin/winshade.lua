if vim.g.loaded_winshade then
	return
end
vim.g.loaded_winshade = true

-- Auto-setup if user hasn't called setup manually
vim.defer_fn(function()
	if not package.loaded["winshade"] or not require("winshade.config").is_enabled() then
		require("winshade").setup()
	end
end, 0)

-- Create user commands
vim.api.nvim_create_user_command("WinshadeEnable", function()
	require("winshade").enable()
end, {})

vim.api.nvim_create_user_command("WinshadeDisable", function()
	require("winshade").disable()
end, {})

vim.api.nvim_create_user_command("WinshadeToggle", function()
	require("winshade").toggle()
end, {})
