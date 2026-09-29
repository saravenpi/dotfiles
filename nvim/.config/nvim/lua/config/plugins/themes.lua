return {
	{ url = "https://github.com/saravenpi/paper.nvim", config = function()
		require("paper").setup({
			transparent = true,
			italic_comments = true,
			italic_keywords = true,
			bold_functions = true,
		})

		vim.cmd.colorscheme("paper")
	end },
}