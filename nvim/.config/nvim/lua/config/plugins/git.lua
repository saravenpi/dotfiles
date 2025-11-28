local M = {}

M.specs = {
	{ src = "https://github.com/NeogitOrg/neogit" },
	{ src = "https://github.com/sindrets/diffview.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
}

M.setup = function()
	-- Lazy load gitsigns to avoid git scanning on startup
	vim.api.nvim_create_autocmd({"BufEnter", "BufNewFile"}, {
		callback = function()
			if vim.fn.isdirectory(vim.fn.getcwd() .. "/.git") == 1 then
				require("gitsigns").setup({
					current_line_blame = false, -- Disable for performance
					signs = {
						add = { text = "│" },
						change = { text = "│" },
						delete = { text = "_" },
						topdelete = { text = "‾" },
						changedelete = { text = "~" },
					},
					attach_to_untracked = false, -- Skip untracked files
					max_file_length = 40000, -- Skip large files
				})
			end
		end,
		once = true
	})
end

return M