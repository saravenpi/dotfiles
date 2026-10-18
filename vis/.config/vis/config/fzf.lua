-- Vis FZF & Ripgrep Integration
-- Provides Telescope-like experience in Vis using fzf, rg, and fd

local M = {}

local recent_file_cache = (os.getenv("HOME") or "/home/sara") .. "/.cache/vis/recent"

local function has_cmd(cmd)
	local res = os.execute("command -v " .. cmd .. " >/dev/null 2>&1")
	return res == true or res == 0
end

-- Helper to run an interactive fzf pipeline using Vis native :! command
local function fzf_run(pipeline)
	local tmp = os.tmpname()
	local cmd = string.format("! %s > %q", pipeline, tmp)
	vis:command(cmd)
	local f = io.open(tmp, "r")
	if not f then
		return nil
	end
	local res = f:read("*l")
	f:close()
	os.remove(tmp)
	return res
end

-- Find files (Telescope find_files)
function M.find_files()
	local file_cmd
	if has_cmd("fd") then
		file_cmd = "fd --type f --hidden --exclude .git 2>/dev/null"
	else
		file_cmd = "find . -type f \\( -name .git -prune -o -print \\) 2>/dev/null"
	end

	local preview_cmd = "bat --style=numbers --color=always {} 2>/dev/null || cat {} 2>/dev/null"
	local fzf_cmd = string.format(
		"%s | fzf --prompt='Find Files> ' --height=50%% --reverse --preview='%s' --preview-window='right:60%%'",
		file_cmd,
		preview_cmd
	)

	local selected = fzf_run(fzf_cmd)
	if selected and selected ~= "" then
		vis:command(string.format("e %q", selected))
	end
end

-- Live Grep with Ripgrep (Telescope live_grep)
function M.live_grep()
	local rg_cmd = "rg --column --line-number --no-heading --color=always --smart-case"
	local preview_cmd =
		"bat --style=numbers --color=always --highlight-line {2} {1} 2>/dev/null || sed -n \"$(( {2} > 5 ? {2} - 5 : 1 )),$(( {2} + 5 ))p\" {1} 2>/dev/null"
	local fzf_cmd = string.format(
		"fzf --disabled --ansi --prompt='Live Grep> ' --height=50%% --reverse "
			.. "--bind 'start:reload:%s \"\"' "
			.. "--bind 'change:reload:%s {q} || true' "
			.. "--delimiter=: --preview='%s' --preview-window='right:60%%'",
		rg_cmd,
		rg_cmd,
		preview_cmd
	)

	local selected = fzf_run(fzf_cmd)
	if selected and selected ~= "" then
		local file, line = selected:match("^([^:]+):(%d+)")
		if file and line then
			vis:command(string.format("e %q", file))
			vis:command(line)
		end
	end
end

-- Buffer / Window Switcher (Telescope buffers)
function M.buffers()
	local tmp_in = os.tmpname()
	local fin = io.open(tmp_in, "w")
	if not fin then
		return
	end

	local names = {}
	local count = 0
	for win in vis:windows() do
		local name = win.file and win.file.name or "[No Name]"
		local mod = (win.file and win.file.modified) and " [+]" or ""
		count = count + 1
		local entry = string.format("[%d] %s%s", count, name, mod)
		fin:write(entry .. "\n")
		names[entry] = win.file and win.file.name
	end
	fin:close()

	local fzf_cmd = string.format("cat %q | fzf --prompt='Buffers> ' --height=40%% --reverse", tmp_in)
	local selected = fzf_run(fzf_cmd)
	os.remove(tmp_in)

	if selected and names[selected] and names[selected] ~= "[No Name]" then
		vis:command(string.format("e %q", names[selected]))
	end
end

-- Recent files picker (Telescope oldfiles)
function M.recent_files()
	local f = io.open(recent_file_cache, "r")
	if not f then
		vis:info("No recent files recorded yet")
		return
	end
	f:close()

	local preview_cmd = "bat --style=numbers --color=always {} 2>/dev/null || cat {} 2>/dev/null"
	local fzf_cmd = string.format(
		"cat %q | fzf --prompt='Recent Files> ' --height=50%% --reverse --preview='%s' --preview-window='right:60%%'",
		recent_file_cache,
		preview_cmd
	)

	local selected = fzf_run(fzf_cmd)
	if selected and selected ~= "" then
		vis:command(string.format("e %q", selected))
	end
end

-- Track opened files into recent cache
local function record_file(file)
	if not file or not file.name or file.name:match("^%s*$") or file.internal then
		return
	end
	local path = file.name
	local lines = {}
	local exists = false
	local rf = io.open(recent_file_cache, "r")
	if rf then
		for line in rf:lines() do
			if line == path then
				exists = true
			else
				table.insert(lines, line)
			end
		end
		rf:close()
	end
	table.insert(lines, 1, path)
	local wf = io.open(recent_file_cache, "w")
	if wf then
		for i = 1, math.min(#lines, 50) do
			wf:write(lines[i] .. "\n")
		end
		wf:close()
	end
end

function M.setup()
	vis.events.subscribe(vis.events.FILE_OPEN, function(file)
		record_file(file)
	end)

	vis:command_register("fzf", function()
		M.find_files()
	end, "Fuzzy find files in current directory")

	vis:command_register("grep", function()
		M.live_grep()
	end, "Live grep through project with ripgrep and fzf")

	vis:command_register("buffers", function()
		M.buffers()
	end, "Switch between open buffers / windows")

	vis:command_register("recent", function()
		M.recent_files()
	end, "Open recently accessed files")
end

return M
