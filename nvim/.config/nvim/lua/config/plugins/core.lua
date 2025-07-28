local M = {}

M.specs = {
	-- File management
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },

	-- Pickers/Finders
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },

	-- Core dependencies
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },

	-- Syntax and parsing
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },

	-- Document preview
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/OXY2DEV/markview.nvim" },
}

M.setup = function()
	require("mini.pick").setup()
	require("oil").setup()
	require("neo-tree").setup()

	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			-- Core
			"lua",
			"vim",
			"vimdoc",
			"query",
			-- Web / Frontend
			"typescript",
			"tsx",
			"javascript",
			"svelte",
			"html",
			"css",
			"json",
			"jsonc",
			"yaml",
			"toml",
			-- Backend / Others
			"elixir",
			"heex",
			"sql",
			"bash",
			"dockerfile",
			"markdown",
			"markdown_inline",
			"c",
			"typst",
		},
		highlight = { enable = true },
	})

	require("markview").setup({})
end

return M

