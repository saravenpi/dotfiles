local M = {}

M.specs = {
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/folke/noice.nvim" },
	{ src = "https://github.com/rcarriga/nvim-notify" },
}

M.setup = function()
	local notify_ok, notify = pcall(require, "notify")
	if notify_ok then
		notify.setup({ render = "compact" })
		vim.notify = notify
	end

	require("noice").setup({
		presets = {
			bottom_search = true,
			command_palette = true,
			long_message_to_split = true,
		},
	})

	local lualine_theme = "gruvbox-material"
	local ok_theme, _ = pcall(require, "lualine.themes." .. lualine_theme)
	if not ok_theme then
		lualine_theme = "gruvbox"
	end

	require("lualine").setup({
		options = {
			theme = lualine_theme,
			section_separators = "",
			component_separators = "",
			globalstatus = true,
		},
	})
end

return M