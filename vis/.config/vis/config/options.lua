-- Vis Core Options
-- Minimal, clean port of Neovim options for Vis

local M = {}

function M.setup()
	-- Global editor options
	vis.events.subscribe(vis.events.INIT, function()
		vis:command("set autoindent on")
		vis:command("set ignorecase on")
		vis:command("set theme palette")
	end)

	-- Per-window options
	vis.events.subscribe(vis.events.WIN_OPEN, function(win)
		win.options.numbers = true
		win.options.relativenumbers = true
		win.options.tabwidth = 4
		win.options.expandtab = true
		win.options.colorcolumn = 80
	end)
end

return M
