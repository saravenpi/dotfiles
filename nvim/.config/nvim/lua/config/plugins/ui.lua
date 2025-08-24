local M = {}

M.specs = {
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/folke/noice.nvim" },
	{ src = "https://github.com/echasnovski/mini.nvim" },
	{ src = "https://github.com/akinsho/bufferline.nvim" },
}

M.setup = function()
	require("mini.notify").setup({
		content = {
			duration = 2000,
		},
	})
	vim.notify = require("mini.notify").make_notify()

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

	require("lualine").setup({
		options = {
			theme = lualine_theme,
			section_separators = "",
			component_separators = "",
			globalstatus = true,
		},
	})

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
end

return M
