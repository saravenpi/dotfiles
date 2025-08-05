local M = {}

M.specs = {
	-- Document preview
	{ src = "https://github.com/OXY2DEV/markview.nvim" },

	-- Markdown links
	{ src = "https://github.com/saravenpi/pebble.nvim" },
}

M.setup = function()
	require("markview").setup({})
	require("pebble").setup({
		-- Automatically set up keymaps for markdown files
		auto_setup_keymaps = true,

		-- Set up global keymaps (disabled by default)
		global_keymaps = true,
	})
end

return M

