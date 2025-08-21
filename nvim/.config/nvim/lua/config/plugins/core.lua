local M = {}

M.specs = {
	-- File management
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },
	{ src = "https://github.com/rachartier/tiny-code-action.nvim" },

	-- Pickers/Finders
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },

	-- Text manipulation
	{ src = "https://github.com/echasnovski/mini.surround" },
	{ src = "https://github.com/smjonas/inc-rename.nvim" },

	-- Core dependencies
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },

	-- Syntax and parsing
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },

	-- Document preview
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
}

M.setup = function()
	require("telescope").setup({
		defaults = {
			mappings = {
				i = {
					["<C-j>"] = "move_selection_next",
					["<C-k>"] = "move_selection_previous",
				},
			},
			layout_config = {
				center = {
					height = 0.4,
					preview_cutoff = 40,
					prompt_position = "top",
					width = 0.5,
				},
			},
			layout_strategy = "center",
			sorting_strategy = "ascending",
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
						close_if_last_window = false,
						enable_git_status = true,
						enable_diagnostics = true,
						default_component_configs = {
							icon = {
								provider = function(icon, node)
									if node.type == "file" or node.type == "terminal" then
										local success, mini_icons = pcall(require, "mini.icons")
										if success then
											local name = node.type == "terminal" and "terminal" or node.name
											local devicon, hl = mini_icons.get("file", name)
											icon.text = devicon or "📄"
											icon.highlight = hl
										end
									end
								end,
							},
						},
						filesystem = {
							follow_current_file = {
								enabled = true,
								leave_dirs_open = false,
							},
							use_libuv_file_watcher = true,
						},
						source_selector = {
							winbar = false,
						},
						event_handlers = {
							{
								event = "file_open_requested",
								handler = function()
									require("neo-tree.command").execute({ action = "close" })
								end,
							},
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

	require("mini.surround").setup({})

	require("tiny-code-action").setup({
		picker = {
			"buffer",
			opts = {
				hotkeys = true, -- Enable hotkeys for quick selection of actions
				hotkeys_mode = "text_diff_based", -- Modes for generating hotkeys
				auto_preview = true, -- Enable or disable automatic preview
				auto_accept = false, -- Automatically accept the selected action
				position = "cursor", -- Position of the picker window
				winborder = "rounded",
				custom_keys = {
					{ key = "m", pattern = "Fill match arms" },
					{ key = "r", pattern = "Rename.*" }, -- Lua pattern matching
				},
				signs = {
					quickfix = { "", { link = "DiagnosticWarning" } },
					others = { "", { link = "DiagnosticWarning" } },
					refactor = { "", { link = "DiagnosticInfo" } },
					["refactor.move"] = { "󰪹", { link = "DiagnosticInfo" } },
					["refactor.extract"] = { "", { link = "DiagnosticError" } },
					["source.organizeImports"] = { "", { link = "DiagnosticWarning" } },
					["source.fixAll"] = { "󰃢", { link = "DiagnosticError" } },
					["source"] = { "", { link = "DiagnosticError" } },
					["rename"] = { "󰑕", { link = "DiagnosticWarning" } },
					["codeAction"] = { "", { link = "DiagnosticWarning" } },
				},
			},
		},
	})

	require("inc_rename").setup()
end

return M
