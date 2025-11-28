local M = {}

M.specs = {
	{ src = "https://github.com/folke/which-key.nvim" },
}

function M.setup()
	local wk = require("which-key")
	
	wk.setup({
		preset = "modern",
		delay = 0,
		expand = 1,
		notify = true,
		replace = {
			key = {
				{ "<Space>", "SPC" },
				{ "<cr>", "RET" },
				{ "<tab>", "TAB" },
			},
		},
		icons = {
			breadcrumb = "»",
			separator = "➜",
			group = "+",
		},
		show_help = true,
		show_keys = true,
		disable = {
			buftypes = {},
			filetypes = { "TelescopePrompt" },
		},
	})

	-- Register key groups
	wk.add({
		{ "<leader>f", group = "file/find" },
		{ "<leader>g", group = "git" },
		{ "<leader>l", group = "lsp" },
		{ "<leader>s", group = "search" },
		{ "<leader>t", group = "toggle" },
		{ "<leader>w", group = "windows" },
		{ "<leader>x", group = "diagnostics" },
		{ "<leader>n", group = "notifications" },
		{ "<leader>c", group = "code" },
		{ "<leader>d", group = "debug" },
		{ "<leader>h", group = "git hunks" },
		{ "<leader>r", group = "refactor" },
		{ "<leader>u", group = "ui" },
		{ "<leader>q", group = "quit/session" },
		{ "<leader>b", group = "buffers" },
	})
end

return M