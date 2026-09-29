return {
	{ url = "https://github.com/NeogitOrg/neogit" },
	{ url = "https://github.com/sindrets/diffview.nvim" },
	{ url = "https://github.com/lewis6991/gitsigns.nvim", config = function()
		-- Lazy load gitsigns to avoid git scanning on startup.
		vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
			callback = function()
				if vim.fn.isdirectory(vim.fn.getcwd() .. "/.git") == 1 then
					require("gitsigns").setup({
						current_line_blame = false,
						signs = {
							add = { text = "│" },
							change = { text = "│" },
							delete = { text = "_" },
							topdelete = { text = "‾" },
							changedelete = { text = "~" },
						},
						attach_to_untracked = false,
						max_file_length = 40000,
					})
				end
			end,
			once = true,
		})
	end },
}