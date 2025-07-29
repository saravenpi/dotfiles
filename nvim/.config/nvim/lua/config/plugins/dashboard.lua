local M = {}

M.specs = {
	{ src = "https://github.com/goolord/alpha-nvim" },
}

function M.setup()
	local alpha = require("alpha")
	local dashboard = require("alpha.themes.dashboard")

	-- Set header
	dashboard.section.header.val = {
		"                                                     ",
		"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
		"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
		"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
		"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
		"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
		"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
		"                                                     ",
	}

	-- Set menu
	dashboard.section.buttons.val = {
		dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
		dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
		dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
		dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
		dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
		dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
	}

	-- Set footer with startup time
	local startup_time = vim.fn.reltimestr(vim.fn.reltime(vim.g.start_time or vim.fn.reltime()))
	startup_time = string.format("%.0f", tonumber(startup_time) * 1000) -- Convert to ms
	dashboard.section.footer.val = {
		"Have a great day!",
		"",
		"⚡ Neovim took " .. startup_time .. " ms to start"
	}

	-- Send config to alpha
	alpha.setup(dashboard.opts)

	-- Disable folding and line numbers on alpha buffer
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "alpha",
		callback = function()
			vim.opt_local.foldenable = false
			vim.opt_local.number = false
			vim.opt_local.relativenumber = false
			vim.opt_local.cursorline = false
		end,
	})
	
	-- Also handle case where alpha opens before FileType is set
	vim.api.nvim_create_autocmd("BufEnter", {
		pattern = "*",
		callback = function()
			if vim.bo.filetype == "alpha" then
				vim.opt_local.foldenable = false
				vim.opt_local.number = false
				vim.opt_local.relativenumber = false
				vim.opt_local.cursorline = false
			end
		end,
	})
end

return M

