if vim.g.loaded_winshade then
  return
end
vim.g.loaded_winshade = true

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
