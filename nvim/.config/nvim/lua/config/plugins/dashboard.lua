return {
	{ url = "https://github.com/goolord/alpha-nvim", config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

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

		dashboard.section.buttons.val = {
			dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
			dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("g", "  Find text", ":Telescope live_grep <CR>"),
			dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
		}

		local startup_time = vim.fn.reltimestr(vim.fn.reltime(vim.g.start_time or vim.fn.reltime()))
		startup_time = string.format("%.0f", tonumber(startup_time) * 1000)
		dashboard.section.footer.val = {
			"Have a great day!",
			"",
			"⚡ Neovim took " .. startup_time .. " ms to start",
		}

		alpha.setup(dashboard.opts)

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "alpha",
			callback = function()
				vim.opt_local.foldenable = false
				vim.opt_local.number = false
				vim.opt_local.relativenumber = false
				vim.opt_local.cursorline = false
			end,
		})

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
	end },
}