local M = {}

M.specs = {
	{ src = "https://github.com/stevearc/overseer.nvim" },
	{ src = "https://github.com/aserowy/tmux.nvim" },
}

M.setup = function()
	require("overseer").setup({})

	require("tmux").setup({
		copy_sync = { enable = false },
		navigation = { enable_default_keybindings = true, cycle_navigation = false },
		resize = { enable_default_keybindings = true },
	})
end

return M

