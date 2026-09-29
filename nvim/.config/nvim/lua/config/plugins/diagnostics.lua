return {
	{ url = "https://github.com/folke/trouble.nvim", config = function()
		require("trouble").setup({
			auto_close = true,
			use_diagnostic_signs = true,
		})
	end },
	{ url = "https://github.com/folke/todo-comments.nvim", config = function()
		require("todo-comments").setup({
			signs = true,
			highlight = {
				multiline = false,
			},
		})
	end },
	{ url = "https://github.com/rachartier/tiny-inline-diagnostic.nvim", config = function()
		require("tiny-inline-diagnostic").setup({
			preset = "modern",
			transparent_bg = false,
			transparent_cursorline = true,
			hi = {
				error = "DiagnosticError",
				warn = "DiagnosticWarn",
				info = "DiagnosticInfo",
				hint = "DiagnosticHint",
				arrow = "NonText",
				background = "CursorLine",
				mixing_color = "Normal",
			},
			options = {
				show_source = {
					enabled = false,
					if_many = false,
				},
				use_icons_from_diagnostic = true,
				set_arrow_to_diag_color = false,
				add_messages = true,
				throttle = 20,
				softwrap = 30,
				multilines = {
					enabled = true,
					always_show = false,
					trim_whitespaces = false,
					tabstop = 4,
				},
				show_all_diags_on_cursorline = false,
				enable_on_insert = false,
				enable_on_select = false,
				overflow = {
					mode = "wrap",
					padding = 0,
				},
				break_line = {
					enabled = false,
					after = 30,
				},
				format = nil,
				virt_texts = {
					priority = 2048,
				},
				severity = {
					vim.diagnostic.severity.ERROR,
					vim.diagnostic.severity.WARN,
					vim.diagnostic.severity.INFO,
					vim.diagnostic.severity.HINT,
				},
				overwrite_events = nil,
			},
			disabled_ft = {},
		})
		vim.diagnostic.config({ virtual_text = false })
	end },
}