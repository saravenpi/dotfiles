return {
	{ url = "https://github.com/stevearc/overseer.nvim" },
	{ url = "https://github.com/aserowy/tmux.nvim", config = function()
		require("overseer").setup({})

		require("tmux").setup({
			copy_sync = { enable = false },
			navigation = { enable_default_keybindings = true, cycle_navigation = false },
			resize = { enable_default_keybindings = true },
		})
	end },
}