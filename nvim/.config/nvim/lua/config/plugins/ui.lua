return {
	{ url = "https://github.com/echasnovski/mini.nvim", config = function()
		require("mini.notify").setup({
			content = {
				duration = 2000,
			},
		})
		vim.notify = require("mini.notify").make_notify()
	end },
	{ url = "https://github.com/folke/noice.nvim", config = function()
		require("noice").setup({
			notify = {
				enabled = false,
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
			},
		})
	end },
	{ url = "https://github.com/nvim-lualine/lualine.nvim", config = function()
		local ok_pal, pal = pcall(require, "palette")
		local lua_theme = (ok_pal and pal.lualine_theme) or "auto"

		require("lualine").setup({
			options = {
				theme = lua_theme,
				section_separators = "",
				component_separators = "",
				globalstatus = true,
			},
		})
	end },
	{ url = "https://github.com/akinsho/bufferline.nvim", config = function()
		require("bufferline").setup({
			options = {
				numbers = "none",
				diagnostics = "nvim_lsp",
				separator_style = "thin",
				show_buffer_close_icons = true,
				show_close_icon = true,
				show_tab_indicators = true,
				offsets = {
					{
						filetype = "NvimTree",
						text = "File Explorer",
						text_align = "left",
						separator = true,
					},
				},
			},
		})
	end },
	{ url = "https://github.com/folke/zen-mode.nvim" },
}