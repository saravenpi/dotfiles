local M = {}

M.specs = {
	-- File management
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },

	-- Pickers/Finders
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },

	-- Text manipulation
	{ src = "https://github.com/echasnovski/mini.surround" },

	-- Core dependencies
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },

	-- Syntax and parsing
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },

	-- Document preview
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/OXY2DEV/markview.nvim" },
}

M.setup = function()
	require("mini.pick").setup({
		window = {
			config = {
				anchor = "NW",
				col = math.floor(vim.o.columns * 0.5) - 40,
				row = math.floor(vim.o.lines * 0.5) - 10,
				width = 80,
				height = 20,
			},
		},
	})
	require("oil").setup()

	-- Lazy setup neo-tree only when first called
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			vim.defer_fn(function()
				local ok, neotree = pcall(require, "neo-tree")
				if ok then
					neotree.setup({
						default_component_configs = {
							icon = {
								-- folder_closed = "📁",
								-- folder_open = "📂",
								-- folder_empty = "📁",
								provider = function(icon, node, state)
									if node.type == "file" or node.type == "terminal" then
										local success, mini_icons = pcall(require, "mini.icons")
										if success then
											local name = node.type == "terminal" and "terminal" or node.name
											local devicon, hl, is_default = mini_icons.get("file", name)
											icon.text = devicon or ""
											icon.highlight = hl
										end
									end
								end,
							},
						},
						filesystem = {
							scan_mode = "shallow", -- Use shallow scan for better performance
							use_libuv_file_watcher = false, -- Disable file watching for large dirs
							hijack_netrw_behavior = "disabled", -- Don't hijack netrw
						},
						source_selector = {
							winbar = false, -- Disable winbar for performance
						},
					})
				end
			end, 50) -- Small delay after startup
		end,
		once = true,
	})

	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			-- Core only - others will install on-demand
			"lua",
			"vim",
			"vimdoc",
			"query",
		},
		auto_install = true, -- Install parsers on-demand when opening files
		highlight = {
			enable = true,
			disable = function(lang, buf)
				-- Disable for large files
				local max_filesize = 100 * 1024 -- 100 KB
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					return true
				end
			end,
		},
	})

	require("markview").setup({})

	require("mini.surround").setup({})
end

return M
