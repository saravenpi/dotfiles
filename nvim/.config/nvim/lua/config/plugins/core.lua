return {
	{ url = "https://github.com/nvim-neo-tree/neo-tree.nvim", dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim", "echasnovski/mini.icons" } },
	{ url = "https://github.com/rachartier/tiny-code-action.nvim", config = function()
		require("tiny-code-action").setup({
			picker = {
				"buffer",
				opts = {
					hotkeys = true,
					hotkeys_mode = "text_diff_based",
					auto_preview = true,
					auto_accept = false,
					position = "cursor",
					winborder = "rounded",
					custom_keys = {
						{ key = "m", pattern = "Fill match arms" },
						{ key = "r", pattern = "Rename.*" },
					},
					signs = {
						quickfix = { "", { link = "DiagnosticWarning" } },
						others = { "", { link = "DiagnosticWarning" } },
						refactor = { "", { link = "DiagnosticInfo" } },
						["refactor.move"] = { "󰪹", { link = "DiagnosticInfo" } },
						["refactor.extract"] = { "󰂭", { link = "DiagnosticError" } },
						["source.organizeImports"] = { "", { link = "DiagnosticWarning" } },
						["source.fixAll"] = { "󰃢", { link = "DiagnosticError" } },
						["source"] = { "", { link = "DiagnosticError" } },
						["rename"] = { "󰑕", { link = "DiagnosticWarning" } },
						["codeAction"] = { "", { link = "DiagnosticWarning" } },
					},
				},
			},
		})
	end },
	{ url = "https://github.com/nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" }, config = function()
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
	end },
	{ url = "https://github.com/echasnovski/mini.surround", config = function()
		require("mini.surround").setup({})
	end },
	{ url = "https://github.com/smjonas/inc-rename.nvim", config = function()
		require("inc_rename").setup()
	end },
	{ url = "https://github.com/nvim-lua/plenary.nvim" },
	{ url = "https://github.com/MunifTanjim/nui.nvim" },
	{ url = "https://github.com/nvim-treesitter/nvim-treesitter", config = function()
		require("nvim-treesitter").setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
		})

		require("nvim-treesitter").install({
			"lua",
			"vim",
			"vimdoc",
			"query",
		})

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local buf = args.buf
				local ft = vim.bo[buf].filetype
				local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > 100 * 1024 then
					return
				end
				pcall(vim.treesitter.start, buf, ft)
			end,
		})
	end },
	{ url = "https://github.com/chomosuke/typst-preview.nvim" },
}