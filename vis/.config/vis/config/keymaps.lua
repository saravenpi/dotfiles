-- Vis Keymaps Configuration
-- Replicates Neovim workflow & leader mappings for Vis

local M = {}

local function has_cmd(cmd)
	local res = os.execute("command -v " .. cmd .. " >/dev/null 2>&1")
	return res == true or res == 0
end

-- Auto-format current file using available formatters
local function format_buffer()
	local win = vis.win
	if not win or not win.file then
		return
	end
	local syntax = win.syntax or ""
	local fname = win.file.name or ""

	local formatter = nil
	if syntax == "lua" and has_cmd("stylua") then
		formatter = "stylua -"
	elseif
		(
			syntax == "javascript"
			or syntax == "typescript"
			or syntax == "json"
			or syntax == "yaml"
			or syntax == "markdown"
			or syntax == "html"
			or syntax == "css"
		) and has_cmd("prettier")
	then
		formatter = string.format("prettier --stdin-filepath %q", fname ~= "" and fname or ("file." .. syntax))
	elseif (syntax == "sh" or syntax == "bash") and has_cmd("shfmt") then
		formatter = "shfmt -i 4"
	elseif syntax == "rust" and has_cmd("rustfmt") then
		formatter = "rustfmt"
	elseif syntax == "python" then
		if has_cmd("ruff") then
			formatter = "ruff format -"
		elseif has_cmd("black") then
			formatter = "black -q -"
		end
	end

	if not formatter then
		vis:info("No suitable formatter found for syntax: " .. (syntax ~= "" and syntax or "plain text"))
		return
	end

	local status, out, err = vis:pipe(win.file, { start = 0, finish = win.file.size }, formatter)
	if status == 0 and out then
		win.file:delete(0, win.file.size)
		win.file:insert(0, out)
		vis:info("Formatted with " .. formatter:match("^%S+"))
	else
		vis:info("Formatting failed: " .. (err or "exit status " .. tostring(status)))
	end
end

-- Open Git status or Lazygit
local function open_git()
	if has_cmd("lazygit") then
		vis:command("! lazygit")
	else
		vis:command("! git status; printf '\\nPress Enter to return to vis... '; read -r _")
	end
end

-- Theme selector
local function select_theme()
	local themes = { "palette", "default-16", "default-256", "solarized", "zenburn", "base-16" }
	local tmp_in = os.tmpname()
	local tmp_out = os.tmpname()
	local fin = io.open(tmp_in, "w")
	if fin then
		fin:write(table.concat(themes, "\n") .. "\n")
		fin:close()
		local fzf_cmd = string.format(
			"! cat %q | fzf --prompt='Select Theme> ' --height=40%% --reverse > %q",
			tmp_in,
			tmp_out
		)
		vis:command(fzf_cmd)
		os.remove(tmp_in)
		local fout = io.open(tmp_out, "r")
		if fout then
			local sel = fout:read("*l")
			fout:close()
			os.remove(tmp_out)
			if sel and sel ~= "" then
				vis:command("set theme " .. sel)
				vis:info("Theme set to: " .. sel)
			end
		end
	end
end

function M.setup()
	local fzf = require("config/fzf")
	local palette = require("plugins/palette")

	-- Helper to register leader mappings for both literal space and symbolic <Space>
	local function map_leader(mode, key, handler, help)
		vis:map(mode, " " .. key, handler, help)
		vis:map(mode, "<Space>" .. key, handler, help)
	end

	-- 1. File & Exit Commands
	map_leader(vis.modes.NORMAL, "w", function()
		vis:command("w")
	end, "Save buffer")

	map_leader(vis.modes.NORMAL, "q", function()
		vis:command("q")
	end, "Close window")

	map_leader(vis.modes.NORMAL, "qq", function()
		vis:command("q")
	end, "Close window")

	map_leader(vis.modes.NORMAL, "Q", function()
		vis:command("q!")
	end, "Force close window")

	map_leader(vis.modes.NORMAL, "x", function()
		vis:command("q")
	end, "Close buffer / window")

	-- 2. System Clipboard Mappings (matches Neovim unnamedplus)
	map_leader(vis.modes.NORMAL, "y", '"+y')
	map_leader(vis.modes.VISUAL, "y", '"+y')
	map_leader(vis.modes.NORMAL, "d", '"+d')
	map_leader(vis.modes.VISUAL, "d", '"+d')
	map_leader(vis.modes.NORMAL, "p", '"+p')
	map_leader(vis.modes.NORMAL, "P", '"+P')

	-- 3. Fuzzy Navigation (Telescope mappings)
	map_leader(vis.modes.NORMAL, "f", function()
		fzf.find_files()
	end, "Find files (fzf)")

	map_leader(vis.modes.NORMAL, " ", function()
		fzf.find_files()
	end, "Find files (fzf)")

	map_leader(vis.modes.NORMAL, "/", function()
		fzf.live_grep()
	end, "Live grep project (ripgrep)")

	map_leader(vis.modes.NORMAL, "b", function()
		fzf.buffers()
	end, "Switch buffers / windows")

	map_leader(vis.modes.NORMAL, "r", function()
		fzf.recent_files()
	end, "Recently opened files")

	map_leader(vis.modes.NORMAL, "e", function()
		require("config/explorer").open()
	end, "Open file tree explorer (Neotree)")

	-- 4. Window Splits & Navigation
	map_leader(vis.modes.NORMAL, "ws", function()
		vis:command("split")
	end, "Horizontal split")

	map_leader(vis.modes.NORMAL, "wv", function()
		vis:command("vsplit")
	end, "Vertical split")

	map_leader(vis.modes.NORMAL, "wc", function()
		vis:command("q")
	end, "Close split")

	-- Window / Buffer cycling (matching Neovim <S-l>, <S-h>, ]b, [b)
	vis:map(vis.modes.NORMAL, "<S-l>", "<C-w>w")
	vis:map(vis.modes.NORMAL, "<S-h>", "<C-w>W")
	vis:map(vis.modes.NORMAL, "]b", "<C-w>w")
	vis:map(vis.modes.NORMAL, "[b", "<C-w>W")

	-- Directional window navigation
	vis:map(vis.modes.NORMAL, "<C-h>", "<C-w>h")
	vis:map(vis.modes.NORMAL, "<C-j>", "<C-w>j")
	vis:map(vis.modes.NORMAL, "<C-k>", "<C-w>k")
	vis:map(vis.modes.NORMAL, "<C-l>", "<C-w>l")

	-- 5. Code & Formatting
	map_leader(vis.modes.NORMAL, "cf", format_buffer, "Format buffer with language formatter")

	-- 6. Git UI (Neogit / lazygit)
	map_leader(vis.modes.NORMAL, "gn", open_git, "Open Git UI (lazygit / git status)")

	-- 7. Theme & UI
	map_leader(vis.modes.NORMAL, "ut", function()
		palette.reload()
	end, "Reload palette theme")

	map_leader(vis.modes.NORMAL, "uc", select_theme, "Select color theme")

	map_leader(vis.modes.NORMAL, "n", function()
		vis:command("set numbers!")
	end, "Toggle line numbers")

	map_leader(vis.modes.NORMAL, "h", function()
		vis:command("help")
	end, "Show Vis interactive help")
end

return M
