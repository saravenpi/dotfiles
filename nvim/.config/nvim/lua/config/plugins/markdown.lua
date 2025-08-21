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
		auto_setup_keymaps = true,
		global_keymaps = true,
	})
	
	
end

return M
