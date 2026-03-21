local M = {}

M.specs = {
	{ src = "https://github.com/saravenpi/paper.nvim" },
}

M.setup = function()
	require("paper").setup({
		transparent = true,
		italic_comments = true,
		italic_keywords = true,
		bold_functions = true,
	})

	vim.cmd.colorscheme("paper")
end

return M
