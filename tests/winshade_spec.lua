---@module "luassert"

describe("winshade", function()
	before_each(function()
		-- Reset module state
		package.loaded["winshade"] = nil
		package.loaded["winshade.config"] = nil
		package.loaded["winshade.highlight"] = nil
		package.loaded["winshade.autocmd"] = nil
	end)

	describe("setup", function()
		it("can be initialized with default config", function()
			require("winshade").setup()
			local cfg = require("winshade.config")
			assert.is_true(cfg.is_enabled())
			assert.equals(0.3, cfg.options.fade_amount)
		end)

		it("accepts custom fade_amount", function()
			require("winshade").setup({ fade_amount = 0.5 })
			local cfg = require("winshade.config")
			assert.equals(0.5, cfg.options.fade_amount)
		end)

		it("accepts excluded_filetypes", function()
			require("winshade").setup({ excluded_filetypes = { "help", "terminal" } })
			local cfg = require("winshade.config")
			assert.equals(2, #cfg.options.excluded_filetypes)
			assert.is_true(vim.tbl_contains(cfg.options.excluded_filetypes, "help"))
		end)

		it("accepts excluded_buftypes", function()
			require("winshade").setup({ excluded_buftypes = { "nofile" } })
			local cfg = require("winshade.config")
			assert.equals(1, #cfg.options.excluded_buftypes)
		end)

		it("accepts debug option", function()
			require("winshade").setup({ debug = true })
			local cfg = require("winshade.config")
			assert.is_true(cfg.options.debug)
		end)

		it("accepts custom debounce_ms", function()
			require("winshade").setup({ debounce_ms = 50 })
			local cfg = require("winshade.config")
			assert.equals(50, cfg.options.debounce_ms)
		end)

		it("accepts custom excluded_highlights", function()
			require("winshade").setup({ excluded_highlights = { "Normal", "Comment" } })
			local cfg = require("winshade.config")
			assert.equals(2, #cfg.options.excluded_highlights)
		end)
	end)

	describe("enable/disable", function()
		it("can be enabled and disabled", function()
			local ws = require("winshade")
			local cfg = require("winshade.config")

			ws.setup()
			assert.is_true(cfg.is_enabled())

			ws.disable()
			assert.is_false(cfg.is_enabled())

			ws.enable()
			assert.is_true(cfg.is_enabled())
		end)

		it("can be toggled", function()
			local ws = require("winshade")
			local cfg = require("winshade.config")

			ws.setup()
			local initial_state = cfg.is_enabled()

			ws.toggle()
			assert.equals(not initial_state, cfg.is_enabled())

			ws.toggle()
			assert.equals(initial_state, cfg.is_enabled())
		end)
	end)

	describe("config", function()
		it("merges user config with defaults", function()
			require("winshade").setup({
				fade_amount = 0.7,
				debug = true,
			})
			local cfg = require("winshade.config")

			-- User values
			assert.equals(0.7, cfg.options.fade_amount)
			assert.is_true(cfg.options.debug)

			-- Default values should still exist
			assert.equals(10, cfg.options.debounce_ms)
			assert.is_true(cfg.options.ignore_floating)
		end)

		it("should_exclude_window works for filetypes", function()
			require("winshade").setup({ excluded_filetypes = { "help" } })
			local cfg = require("winshade.config")

			-- Create a help buffer
			local bufnr = vim.api.nvim_create_buf(false, true)
			vim.bo[bufnr].filetype = "help"
			local winid = vim.api.nvim_get_current_win()
			vim.api.nvim_win_set_buf(winid, bufnr)

			assert.is_true(cfg.should_exclude_window(winid))

			-- Cleanup
			vim.api.nvim_buf_delete(bufnr, { force = true })
		end)

		it("should_exclude_window works for buftypes", function()
			require("winshade").setup({ excluded_buftypes = { "nofile" } })
			local cfg = require("winshade.config")

			-- Create a nofile buffer
			local bufnr = vim.api.nvim_create_buf(false, true)
			vim.bo[bufnr].buftype = "nofile"
			local winid = vim.api.nvim_get_current_win()
			vim.api.nvim_win_set_buf(winid, bufnr)

			assert.is_true(cfg.should_exclude_window(winid))

			-- Cleanup
			vim.api.nvim_buf_delete(bufnr, { force = true })
		end)
	end)

	describe("highlight", function()
		it("setup can be called without errors", function()
			require("winshade").setup()
			local highlight = require("winshade.highlight")

			assert.has_no.errors(function()
				highlight.setup()
			end)
		end)

		it("apply_to_window handles invalid window", function()
			require("winshade").setup()
			local highlight = require("winshade.highlight")

			-- Should not error on invalid window
			assert.has_no.errors(function()
				highlight.apply_to_window(99999)
			end)
		end)

		it("clear_window handles invalid window", function()
			require("winshade").setup()
			local highlight = require("winshade.highlight")

			-- Should not error on invalid window
			assert.has_no.errors(function()
				highlight.clear_window(99999)
			end)
		end)
	end)
end)
