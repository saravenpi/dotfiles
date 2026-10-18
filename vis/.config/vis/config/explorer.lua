-- Vis File Explorer (Neotree equivalent)
-- Provides interactive file tree browsing with Yazi / FZF fallback

local M = {}

local function has_cmd(cmd)
	local res = os.execute("command -v " .. cmd .. " >/dev/null 2>&1")
	return res == true or res == 0
end

-- Open file explorer and reveal current file
function M.open()
	local win = vis.win
	local target = "."
	if win and win.file and win.file.name and win.file.name ~= "" and not win.file.internal then
		target = win.file.name
	end

	-- 1. Primary: Yazi (modern TUI file manager with tree view, icons, and previews)
	if has_cmd("yazi") then
		local tmp = os.tmpname()
		vis:command(string.format("! yazi %q --chooser-file=%q", target, tmp))
		local f = io.open(tmp, "r")
		if f then
			local chosen = f:read("*l")
			f:close()
			os.remove(tmp)
			if chosen and chosen ~= "" then
				vis:command(string.format("e %q", chosen))
			end
		end
		return
	end

	-- 2. Fallback: tree + fzf interactive explorer
	local tmp_out = os.tmpname()
	local file_cmd = has_cmd("fd") and "fd --type f --hidden --exclude .git 2>/dev/null"
		or "find . -type f \\( -name .git -prune -o -print \\) 2>/dev/null"
	local fzf_cmd = string.format(
		"! %s | fzf --prompt='Explorer> ' --height=60%% --reverse "
			.. "--preview='tree -C -L 2 $(dirname {}) 2>/dev/null || bat --style=numbers --color=always {} 2>/dev/null || cat {}' "
			.. "> %q",
		file_cmd,
		tmp_out
	)
	vis:command(fzf_cmd)
	local f = io.open(tmp_out, "r")
	if f then
		local chosen = f:read("*l")
		f:close()
		os.remove(tmp_out)
		if chosen and chosen ~= "" then
			vis:command(string.format("e %q", chosen))
		end
	end
end

function M.setup()
	-- Register :explorer command
	vis:command_register("explorer", function()
		M.open()
	end, "Open file tree explorer (Neotree alternative)")

	-- Map Space+e to toggle/reveal file tree explorer (both literal space and symbolic)
	vis:map(vis.modes.NORMAL, " e", function()
		M.open()
	end, "Open file tree explorer (reveal current file)")

	vis:map(vis.modes.NORMAL, "<Space>e", function()
		M.open()
	end, "Open file tree explorer (reveal current file)")
end

return M
