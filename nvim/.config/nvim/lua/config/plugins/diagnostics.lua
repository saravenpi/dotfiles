local M = {}

M.specs = {
	{ src = "https://github.com/folke/trouble.nvim" },
	{ src = "https://github.com/folke/todo-comments.nvim" },
}

M.setup = function()
	require("trouble").setup({
		auto_close = true,
		use_diagnostic_signs = true,
	})

	require("todo-comments").setup({
		signs = true,
		highlight = {
			multiline = false,
		},
	})
end

return M

