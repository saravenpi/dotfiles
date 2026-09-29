return {
	{ url = "https://github.com/OXY2DEV/markview.nvim" },
	{ url = "https://github.com/saravenpi/pebble.nvim", config = function()
		require("markview").setup()
		require("pebble").setup({
			auto_setup_keymaps = true,
			global_keymaps = true,
			completion = {
				enabled = true,
				nvim_cmp = {
					enabled = true,
					priority = 100,
					max_item_count = 25,
				},
				debug = false,
			},
			search = {
				ripgrep_path = "rg",
			},
		})
	end },
}