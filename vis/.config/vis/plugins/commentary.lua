-- Vis Commentary Plugin
-- Fast line and block commenting (inspired by vim-commentary)
-- Mappings:
--   gcc     - Toggle comment on current line(s)
--   gc{mot} - Toggle comment on motion/range

local comment_map = {
	actionscript = "//",
	ada = "--",
	ansi_c = "/*|*/",
	antlr = "//",
	apdl = "!",
	apl = "#",
	applescript = "--",
	asp = "'",
	autoit = ";",
	awk = "#",
	bash = "#",
	batch = ":",
	bibtex = "%",
	boo = "#",
	c = "//",
	chuck = "//",
	cmake = "#",
	coffeescript = "#",
	context = "%",
	cpp = "//",
	crystal = "#",
	csharp = "//",
	css = "/*|*/",
	cuda = "//",
	dart = "//",
	desktop = "#",
	django = "{#|#}",
	dockerfile = "#",
	dot = "//",
	eiffel = "--",
	elixir = "#",
	elm = "--",
	erlang = "%",
	fennel = ";;",
	fish = "#",
	forth = "|\\",
	fortran = "!",
	fsharp = "//",
	gap = "#",
	gettext = "#",
	gherkin = "#",
	glsl = "//",
	gnuplot = "#",
	go = "//",
	groovy = "//",
	haskell = "--",
	html = "<!--|-->",
	ini = "#",
	java = "//",
	javascript = "//",
	json = "/*|*/",
	jsp = "//",
	julia = "#",
	latex = "%",
	ledger = "#",
	less = "//",
	lilypond = "%",
	lisp = ";",
	lua = "--",
	makefile = "#",
	markdown = "<!--|-->",
	matlab = "%",
	meson = "#",
	moonscript = "--",
	nim = "#",
	nix = "#",
	pascal = "//",
	perl = "#",
	php = "//",
	powershell = "#",
	prolog = "%",
	protobuf = "//",
	python = "#",
	r = "#",
	ruby = "#",
	rust = "//",
	sass = "//",
	scala = "//",
	scheme = ";",
	sh = "#",
	sql = "--",
	svelte = "<!--|-->",
	systemd = "#",
	tcl = "#",
	tex = "%",
	toml = "#",
	typescript = "//",
	typst = "//",
	v = "//",
	verilog = "//",
	vhdl = "--",
	vim = '"',
	vue = "<!--|-->",
	xml = "<!--|-->",
	yaml = "#",
	zig = "//",
	zsh = "#",
}

local function esc(str)
	if not str then
		return ""
	end
	return (str:gsub("[[.+*?$^()%%%]-]", "%%%0"))
end

local function pesc(str)
	if not str then
		return ""
	end
	return str:gsub("%%", "%%%%")
end

local function rtrim(s)
	local n = #s
	while n > 0 and s:find("^%s", n) do
		n = n - 1
	end
	return s:sub(1, n)
end

local function comment_line(lines, lnum, prefix, suffix)
	if suffix ~= "" then
		suffix = " " .. suffix
	end
	lines[lnum] = string.gsub(lines[lnum], "(%s*)(.*)", "%1" .. pesc(prefix) .. " %2" .. pesc(suffix))
end

local function uncomment_line(lines, lnum, prefix, suffix)
	local match_str = "^(%s*)" .. esc(prefix) .. "%s?(.*)" .. esc(suffix)
	local m = table.pack(lines[lnum]:match(match_str))
	if m and m[1] and m[2] then
		lines[lnum] = m[1] .. rtrim(m[2])
	end
end

local function is_comment(line, prefix)
	local trimmed = line:match("^%s*(.+)")
	return trimmed and trimmed:sub(1, #prefix) == prefix
end

local function toggle_line_comment(lines, lnum, prefix, suffix)
	if not lines or not lines[lnum] then
		return
	end
	if not lines[lnum]:match("^%s*(.+)") then
		return
	end
	if is_comment(lines[lnum], prefix) then
		uncomment_line(lines, lnum, prefix, suffix)
	else
		comment_line(lines, lnum, prefix, suffix)
	end
end

local function block_comment(lines, a, b, prefix, suffix)
	local uncomment = true
	for i = a, b do
		if lines[i] and lines[i]:match("^%s*(.+)") and not is_comment(lines[i], prefix) then
			uncomment = false
			break
		end
	end

	for i = a, b do
		if lines[i] and lines[i]:match("^%s*(.+)") then
			if uncomment then
				uncomment_line(lines, i, prefix, suffix)
			else
				comment_line(lines, i, prefix, suffix)
			end
		end
	end
end

local function get_comment_delimiters(syntax)
	local comment = comment_map[syntax] or "#"
	local prefix, suffix = comment:match("^([^|]+)|?([^|]*)$")
	return prefix or "#", suffix or ""
end

-- Operator mapping: gc{motion} or in visual mode: gc
vis:operator_new("gc", function(file, range, pos)
	local prefix, suffix = get_comment_delimiters(vis.win.syntax)
	local c = 0
	local i = 1
	local a = -1
	local b = -1

	for line in file:lines_iterator() do
		local line_start = c
		local line_finish = c + #line + 1
		if line_start < range.finish and line_finish > range.start then
			if a == -1 then
				a = i
			end
			b = i
		end
		c = line_finish
		if c > range.finish then
			break
		end
		i = i + 1
	end

	if a ~= -1 and b ~= -1 then
		block_comment(file.lines, a, b, prefix, suffix)
	end

	return range.start
end, "Toggle comment on lines in range")

-- Normal mode: gcc (current line)
vis:map(vis.modes.NORMAL, "gcc", function()
	local win = vis.win
	local lines = win.file.lines
	local prefix, suffix = get_comment_delimiters(win.syntax)

	for sel in win:selections_iterator() do
		local lnum = sel.line
		local col = sel.col
		toggle_line_comment(lines, lnum, prefix, suffix)
		sel:to(lnum, col)
	end

	win:draw()
end, "Toggle comment on current line")
