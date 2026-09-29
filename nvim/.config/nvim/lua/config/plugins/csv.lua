return {
	{ url = "https://github.com/hat0uma/csvview.nvim", config = function()
		require("csvview").setup({
			view = {
				display_mode = "border",
				sticky_header = {
					enabled = true,
					separator = "─",
				},
			},
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "csv", "tsv" },
			callback = function()
				require("csvview").enable()
			end,
		})
	end },
}