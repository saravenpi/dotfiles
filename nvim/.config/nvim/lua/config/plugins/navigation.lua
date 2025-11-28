local M = {}

M.specs = {
	{ src = "https://github.com/SmiteshP/nvim-navbuddy" },
	{ src = "https://github.com/SmiteshP/nvim-navic" },
	{ src = "https://github.com/folke/flash.nvim" },
}

M.setup = function()
	require("nvim-navbuddy").setup({
		window = { border = "rounded" },
		lsp = { auto_attach = true },
	})

	require("flash").setup({})
end

return M