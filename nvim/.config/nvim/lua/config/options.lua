vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.wrap = false
vim.opt.tabstop = 2
vim.opt.swapfile = false
vim.opt.winborder = "rounded"
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.g.colorcolum = "80"
vim.g.mapleader = " "

-- Disable LSP logging to prevent large log files
vim.lsp.set_log_level("off")

vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		spacing = 4,
		source = "if_many",
		format = function(diagnostic)
			return string.format("%s (%s)", diagnostic.message, diagnostic.source or "")
		end,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "✘",
			[vim.diagnostic.severity.WARN] = "▲",
			[vim.diagnostic.severity.HINT] = "⚑",
			[vim.diagnostic.severity.INFO] = "»",
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		focusable = true,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
		format = function(diagnostic)
			return string.format("%s (%s) [%s]", 
				diagnostic.message, 
				diagnostic.source or "unknown",
				vim.diagnostic.severity[diagnostic.severity]
			)
		end,
	},
})
