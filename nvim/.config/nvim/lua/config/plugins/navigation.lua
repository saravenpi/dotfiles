return {
	{ url = "https://github.com/SmiteshP/nvim-navbuddy", dependencies = { "SmiteshP/nvim-navic" } },
	{ url = "https://github.com/SmiteshP/nvim-navic" },
	{ url = "https://github.com/hedyhli/outline.nvim" },
	{ url = "https://github.com/folke/flash.nvim", config = function()
		require("nvim-navbuddy").setup({
			window = { border = "rounded" },
			lsp = { auto_attach = true },
		})

		require("outline").setup({})
		require("flash").setup({})
	end },
}