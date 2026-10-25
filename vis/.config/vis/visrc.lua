require("vis")

require("plugins/commentary")
require("plugins/surround")
require("plugins/autopairs")
require("plugins/cursors")
require("plugins/goto-file")
require("plugins/inotify")
require("plugins/editorconfig")
require("plugins/vis-lspc")

local palette = require("plugins/palette")
palette.apply()

vis.events.subscribe(vis.events.INIT, function()
	vis:command("set autoindent on")
	vis:command("set ignorecase on")
	vis:command("set theme palette")
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	win.options.numbers = true
	win.options.relativenumbers = true
	win.options.tabwidth = 4
	win.options.expandtab = true
	win.options.colorcolumn = 80
end)

local c = palette.get_palette()
local MODE_STYLE = 60

local mode_names = {
	[vis.modes.NORMAL] = " NORMAL ",
	[vis.modes.INSERT] = " INSERT ",
	[vis.modes.VISUAL] = " VISUAL ",
	[vis.modes.VISUAL_LINE] = " V-LINE ",
	[vis.modes.REPLACE] = " REPLACE ",
	[vis.modes.OPERATOR_PENDING] = " PENDING ",
}

local mode_colors = {
	[vis.modes.NORMAL] = "fore:" .. c.bg .. ",back:" .. c.blue .. ",bold",
	[vis.modes.INSERT] = "fore:" .. c.bg .. ",back:" .. c.green .. ",bold",
	[vis.modes.VISUAL] = "fore:" .. c.bg .. ",back:" .. c.magenta .. ",bold",
	[vis.modes.VISUAL_LINE] = "fore:" .. c.bg .. ",back:" .. c.magenta .. ",bold",
	[vis.modes.REPLACE] = "fore:" .. c.bg .. ",back:" .. c.red .. ",bold",
	[vis.modes.OPERATOR_PENDING] = "fore:" .. c.bg .. ",back:" .. c.yellow .. ",bold",
}

vis.events.subscribe(vis.events.WIN_STATUS, function(win)
	local name = win.file.name or "[No Name]"
	local mod = win.file.modified and " [+]" or ""
	local right = string.format("%s  │  %d:%d", win.syntax or "text", win.selection.line, win.selection.col)

	if win == vis.win then
		local mode = mode_names[vis.mode] or " NORMAL "
		local left = mode .. " " .. name .. mod
		win:status(left, right)
		local st = mode_colors[vis.mode] or ("fore:" .. c.bg .. ",back:" .. c.blue .. ",bold")
		win:style_define(MODE_STYLE, st)
		for x = 0, #mode - 1 do
			win:style_pos(MODE_STYLE, x, win.height - 1)
		end
	else
		win:status(" " .. name .. mod, right)
	end
	return true
end)

local function has_cmd(cmd)
	local res = os.execute("command -v " .. cmd .. " >/dev/null 2>&1")
	return res == true or res == 0
end

local function fzf_run(pipeline)
	local tmp = os.tmpname()
	vis:command(string.format("! %s > %q", pipeline, tmp))
	vis:feedkeys("<C-l>")
	local f = io.open(tmp, "r")
	if not f then
		return nil
	end
	local res = f:read("*l")
	f:close()
	os.remove(tmp)
	return res
end

local function fzf_files()
	local file_cmd = has_cmd("fd") and "fd --type f --hidden --exclude .git 2>/dev/null"
		or "find . -type f \\( -name .git -prune -o -print \\) 2>/dev/null"
	local selected = fzf_run(string.format("%s | fzf --prompt='Files> ' --height=40%% --reverse", file_cmd))
	if selected and selected ~= "" then
		vis:command(string.format("e %q", selected))
	end
end

local function fzf_grep()
	local cmd = "rg --column --line-number --no-heading --smart-case"
	local selected = fzf_run(string.format("fzf --disabled --prompt='Grep> ' --height=40%% --reverse --bind 'start:reload:%s \"\"' --bind 'change:reload:%s {q} || true'", cmd, cmd))
	if selected and selected ~= "" then
		local file, line = selected:match("^([^:]+):(%d+)")
		if file and line then
			vis:command(string.format("e %q", file))
			vis:command(line)
		end
	end
end

local function fzf_buffers()
	local tmp_in = os.tmpname()
	local fin = io.open(tmp_in, "w")
	if not fin then
		return
	end
	local names = {}
	local count = 0
	for win in vis:windows() do
		local n = win.file and win.file.name or "[No Name]"
		local m = (win.file and win.file.modified) and " [+]" or ""
		count = count + 1
		local entry = string.format("[%d] %s%s", count, n, m)
		fin:write(entry .. "\n")
		names[entry] = win.file and win.file.name
	end
	fin:close()
	local selected = fzf_run(string.format("cat %q | fzf --prompt='Buffers> ' --height=30%% --reverse", tmp_in))
	os.remove(tmp_in)
	if selected and names[selected] and names[selected] ~= "[No Name]" then
		vis:command(string.format("e %q", names[selected]))
	end
end

local function open_yazi()
	local target = "."
	if vis.win and vis.win.file and vis.win.file.name and vis.win.file.name ~= "" and not vis.win.file.internal then
		target = vis.win.file.name
	end
	local tmp = os.tmpname()
	vis:command(string.format("! yazi %q --chooser-file=%q", target, tmp))
	vis:feedkeys("<C-l>")
	local f = io.open(tmp, "r")
	if f then
		local chosen = f:read("*l")
		f:close()
		os.remove(tmp)
		if chosen and chosen ~= "" then
			vis:command(string.format("e %q", chosen))
		end
	end
end

local function open_explorer()
	if os.getenv("TMUX") then
		local path = "."
		if vis.win and vis.win.file and vis.win.file.name and vis.win.file.name ~= "" and not vis.win.file.internal then
			path = vis.win.file.name
		end
		os.execute(string.format("~/.config/tmux/scripts/toggle-yazi.sh %q", path))
	else
		open_yazi()
	end
end

local function open_git()
	vis:command("! gitu")
	vis:feedkeys("<C-l>")
end

vis:map(vis.modes.NORMAL, " y", '"+y')
vis:map(vis.modes.VISUAL, " y", '"+y')
vis:map(vis.modes.NORMAL, " p", '"+p')
vis:map(vis.modes.NORMAL, " P", '"+P')
vis:map(vis.modes.NORMAL, "<Space>y", '"+y')
vis:map(vis.modes.VISUAL, "<Space>y", '"+y')
vis:map(vis.modes.NORMAL, "<Space>p", '"+p')
vis:map(vis.modes.NORMAL, "<Space>P", '"+P')

vis:map(vis.modes.NORMAL, "<C-h>", "<C-w>h")
vis:map(vis.modes.NORMAL, "<C-j>", "<C-w>j")
vis:map(vis.modes.NORMAL, "<C-k>", "<C-w>k")
vis:map(vis.modes.NORMAL, "<C-l>", "<C-w>l")

vis:map(vis.modes.NORMAL, " f", fzf_files)
vis:map(vis.modes.NORMAL, "<Space>f", fzf_files)
vis:map(vis.modes.NORMAL, " /", fzf_grep)
vis:map(vis.modes.NORMAL, "<Space>/", fzf_grep)
vis:map(vis.modes.NORMAL, " b", fzf_buffers)
vis:map(vis.modes.NORMAL, "<Space>b", fzf_buffers)
vis:map(vis.modes.NORMAL, " e", open_explorer)
vis:map(vis.modes.NORMAL, "<Space>e", open_explorer)
vis:map(vis.modes.NORMAL, " g", open_git)
vis:map(vis.modes.NORMAL, "<Space>g", open_git)

vis:command_register("fzf", fzf_files, "Fuzzy find files")
vis:command_register("grep", fzf_grep, "Live grep project")
vis:command_register("buffers", fzf_buffers, "Switch buffers")
vis:command_register("explorer", open_explorer, "Open Yazi file explorer")
vis:command_register("git", open_git, "Open Gitu (Magit-style Git TUI)")
