-- SPDX-License-Identifier: GPL-3.0-or-later
-- © 2020 Georgi Kirilov

require("vis")
require("lpeg")

local vis = vis
local lfs = pcall(require, "lfs") and require("lfs") or {
	attributes = function(path, attr)
		local f = io.open(path, "r")
		if f then
			f:close()
			return "file"
		end
		if os.execute("test -d " .. string.format("%q", path) .. " 2>/dev/null") == 0 then
			return "directory"
		end
		return nil
	end
}
local lpeg = lpeg
local P,      S,      R,      C,      V,      Cp,      Cmt,      Carg,      Cs =
 lpeg.P, lpeg.S, lpeg.R, lpeg.C, lpeg.V, lpeg.Cp, lpeg.Cmt, lpeg.Carg, lpeg.Cs

local progname = ...

local function at_pos(_, position, start, pos, ...) return (pos >= start and pos < position), ... end
local function if_pos(start, mod, finish, pos) if pos >= start and pos < finish then return mod end end
local function replace() return "/" end
local function mkpath(mod, sep) return Cs(mod * (("/" + C(sep) / replace) * mod)^0) end
local function anywhere(patt) return P{Cmt(Cp() * Carg(1) * patt, at_pos) + 1 * V(1)} end
local function spot(patt) return (Cp() * patt * Cp() * Carg(1) / if_pos) end
local function join(from, mod)
	if from and mod then
		return from .. "/" .. mod
	else
		return mod or from
	end
end

local sp = S" \t"
local snake_kebab = (R"az" + R"AZ" + R"09" + S"_-")^1
local snake       = (R"az" + R"AZ" + R"09" + S"_")^1
local c_name = (1 - S'">')^1
local py_pkg = mkpath(snake, P".")
local py_renamer = sp^1 * "as" * sp^1 * snake
local py_mod = py_pkg * py_renamer^-1
local py_import = spot(sp^0 * "import" * sp^1 * py_mod) * (spot(sp^0 * "," * sp^0 * py_mod))^0
local lua_require = anywhere("require" * sp^0 * P"("^-1 * sp^0 * S'"\'' * mkpath(snake_kebab, "."))

local M = {
	path = {},
	includeexpr = {
		ansi_c = P{sp^0 * "#" * sp^0 * "include" * sp^0 * S'<"' * C(c_name)},
		cpp    = P{sp^0 * "#" * sp^0 * "include" * sp^0 * S'<"' * C(c_name)},
		tcl    = anywhere("package" * sp^1 * "require" * (sp^1 * "-exact")^-1 * sp^1 * mkpath(snake, "::")),
		perl   = anywhere((P"use" + "require") * sp^1 * mkpath(snake, "::")),
		lua    = lua_require,
		moonscript = lua_require,
		python = ((sp^0 * "from" * sp^1 * py_pkg)^-1 * py_import) / join
	}
}

local pkg_init = {
	lua    = "init",
	fennel = "init",
	python = "__init__",
	scheme = "main",  -- Racket-specific
	tcl = true,  -- arbitrary way to flag that a package dir contains a namesake file inside
}

local suffixesadd = {}
local extensions = {}
local external_match = {}

local locations = {}
local last_syntax

local function regex_escape(text)
	return text:gsub("[][)(}{|+?*.]", "\\%0")
	:gsub("%^", "\\^"):gsub("^/\\%^", "/^")
	:gsub("%$", "\\$"):gsub("\\%$/$", "$/")
end

local function lua_escape(text)
	return text:gsub("[][^$)(%.*+?-]", "%%%0")
end

local function extract_location(text, syntax, column, complete, strip_count)
		local fname, cmd
		if external_match[syntax] and not complete then
			fname = external_match[syntax](vis.win, vis.win.selection.pos)
		end
		if not fname then
			local patt
			local cmdpatt = P":" * C(R"09"^1 + "/" * (1 - P"/")^1 * "/") + P"#" * S"Ll" * C(R"09"^1)
			if complete then
				local fnamepatt = P(1 - S":#")^1
				patt = C(fnamepatt) * cmdpatt^-1
			else
				local fnamepatt = P(1 - S':# \t"\'`*][><}{)(')^1
				patt = P{Cmt(Cp() * Carg(1) * C(fnamepatt) * cmdpatt^-1, at_pos) + 1 * V(1)}
				if syntax and M.includeexpr[syntax] then
					patt = M.includeexpr[syntax] + patt
				end
			end
			fname, cmd = patt:match(text, 1, column)
			if cmd and cmd:find"^/" then
				cmd = regex_escape(cmd)
			end
		end
		return fname and fname:gsub("[^/]-/", "", strip_count or 0), cmd
end

local function try_suffixes(fpath, syntax)
	for _, ext in ipairs(suffixesadd[syntax]) do
		if lfs.attributes(fpath .. ext, "mode") == "file" then
			return fpath .. ext
		end
	end
end

local function try(fpath, fname, syntax)
	local found = try_suffixes(fpath, syntax)
	if not found then
		if lfs.attributes(fpath, "mode") == "directory" and pkg_init[syntax] then
			local initpath = fpath .. "/" .. (pkg_init[syntax] == true and fname or pkg_init[syntax])
			found = try_suffixes(initpath, syntax)
		end
	end
	return found
end

local function goto_location(text, win, split)
	local syntax = win.syntax
	local fname, cmd = extract_location(text or win.file.lines[win.selection.line],
					    syntax, win.selection.col, not not text, vis.count)
	vis.count = nil
	if not fname then return end
	local has_extension
	if extensions[syntax] then
		for _, ext in ipairs(extensions[syntax]) do
			if fname:match(ext) then
				has_extension = true
				break
			end
		end
	end
	local same = fname == win.file.path or (fname:sub(1, 1) ~= "/" and fname == win.file.name)
	if not same or split and same then
		local realname
		local mode, errmsg
		if fname:sub(1, 1) == "/" then
			mode, errmsg = lfs.attributes(fname, "mode")
			if mode == "file" then
				realname = fname
			end
		else
			for _, dir in ipairs(M.path[win]) do
				if dir:sub(1, 1) == "." and win.file.path then
					dir = win.file.path:match("(.+/)[^/]+$") .. dir
				end
				local fpath = #dir > 0 and (dir .. "/" .. fname) or fname
				mode, errmsg = lfs.attributes(fpath, "mode")
				if mode == "file" then
					realname = fpath
				elseif syntax and not has_extension then
					realname = try(fpath, fname, syntax)
					if not realname and fpath:find"/" then
						-- If the regular magic yielded nothing, assume that the last part
						-- of fpath is not a dir or file, but an identifier, and ignore it.
						local modpath = fpath:match("(.+)/[^/]+$")
						realname = try(modpath, fname, syntax)
					end
				end
				if realname then break end
			end
		end
		if realname then
			if realname:find("%s") then realname = string.format("%q", realname) end
			vis:command((split and "open " or "e ") .. realname)
		else
			vis:info(errmsg or fname .. ": File not found")
			return false
		end
	end
	if cmd and win ~= vis.win then
		if tonumber(cmd) then
			vis.win.selection:to(cmd, 1)
		else
			vis.win.selection:to(1, 1)
			vis:command(cmd)
			vis.win.selection.pos = vis.win.selection.range.start
			vis.mode = vis.modes.NORMAL
		end
	end
	return true
end

vis.events.subscribe(vis.events.WIN_STATUS, function(win)
	if win == vis.win and win.syntax ~= last_syntax then
		if win.syntax and win.syntax ~= "text" then
			suffixesadd[win.syntax] = {}
			extensions[win.syntax] = vis.ftdetect.filetypes[win.syntax].ext
			for _, patt in ipairs(extensions[win.syntax] or {}) do
				local ext = patt:gsub("^%%(.+)%$$", "%1")
				table.insert(suffixesadd[win.syntax], ext)
			end
		end
		last_syntax = win.syntax
	end
end)

-- Inverted and unrolled config table.
-- When a file from one of the search dirs of a workspace is opened,
-- (but is outside the workspace) this dir is added to the file's search path.
-- This allows one to keep exploring with gf without having to explicitly
-- include the dir in a workspace.
local lookup = {}

local function preprocess(tbl)
	for _, map in pairs(tbl) do
		for syntax, path in pairs(map) do
			lookup[syntax] = lookup[syntax] or {}
			for _, dir in ipairs(path) do
				lookup[syntax][dir] = true
			end
		end
	end
end

vis.events.subscribe(vis.events.INIT, function()
	if M.workspaces then
		preprocess(M.workspaces)
	end
end)

local ignoredups = {
	__newindex = function(t, k, v)
		for _, dir in ipairs(t) do
			if v == dir then return end
		end
		rawset(t, k, v)
	end
}

vis.events.subscribe(vis.events.WIN_OPEN, function(win)

	M.path[win] = setmetatable({"."}, ignoredups)

	if M.workspaces and win.file.path and win.syntax and win.syntax ~= "text" then
		local dirname = win.file.path:match("(.+/)[^/]+$")
		local sorted_workspaces = {}
		for wsdir in pairs(M.workspaces) do
			table.insert(sorted_workspaces, wsdir)
		end
		table.sort(sorted_workspaces, function(x, y) return x > y end)
		for _, wsdir in ipairs(sorted_workspaces) do
			local map = M.workspaces[wsdir]
			if dirname:match("^" .. lua_escape(wsdir)) then
				for _, syntax in ipairs({win.syntax, 1}) do
					if map[syntax] then
						for _, dir in ipairs(map[syntax]) do
							table.insert(M.path[win], dir)
						end
					end
				end
			end
		end
		for _, syntax in ipairs({win.syntax, 1}) do
			if lookup[syntax] then
				for dir in pairs(lookup[syntax]) do
					if dirname:match("^" .. dir) then
						table.insert(M.path[win], dir)
					end
				end
			end
		end
	end

	if #M.path[win] <= 1 then
		table.insert(M.path[win], "/usr/include")
	end
	table.insert(M.path[win], "")
end)

vis.events.subscribe(vis.events.WIN_CLOSE, function(win)
	M.path[win] = nil
end)

local function goto_file(file, win, split)
	local old
	if win.file.name then
		old = {
			path = win.file.path,
			line = win.selection.line,
			col  = win.selection.col,
		}
	end
	if goto_location(file, win, split) and not split then
		table.insert(locations, old)
	end
end

local function h(msg)
	return string.format("|@%s| %s", progname, msg)
end

vis:map(vis.modes.NORMAL, "gf", function()
	goto_file(nil, vis.win)
end, h"Edit the file whose name is under the cursor")

vis:map(vis.modes.NORMAL, "<C-w><C-f>", function()
	goto_file(nil, vis.win, true)
end, h"Edit the file whose name is under the cursor, in a new window")

vis:map(vis.modes.VISUAL, "gf", function()
	local win = vis.win
	local text = win.file:content(win.selection.range)
	goto_file(text, win)
end, h"Edit the file whose name is selected")

vis:map(vis.modes.VISUAL, "<C-w><C-f>", function()
	local win = vis.win
	local text = win.file:content(win.selection.range)
	goto_file(text, win, true)
end, h"Edit the file whose name is selected, in a new window")

vis:command_register("find", function(argv, _, win)
	if #argv ~= 1 then return end
	return goto_file(argv[1], win)
end, h"Same as :e, but search in 'path'")

vis:command_register("sfind", function(argv, _, win)
	if #argv ~= 1 then return end
	return goto_file(argv[1], win, true)
end, h"Same as :split, but search in 'path'")

vis:map(vis.modes.NORMAL, "<C-w>f", "<C-w><C-f>")
vis:map(vis.modes.VISUAL, "<C-w>f", "<C-w><C-f>")

vis:map(vis.modes.NORMAL, "<C-o>", function()
	if #locations < 1 then
		return
	end
	local last = locations[#locations]
	if last.path ~= vis.win.file.path then
		vis:command("e" .. last.path)
		if last.path ~= vis.win.file.path then
			return false
		end
	end
	vis.win.selection:to(last.line, last.col)
	table.remove(locations)
end, h"Go to older cursor position in jump list")

-- XXX: other plugins can check for this and register their own handlers.
-- Useful for multi-line includeexpr or mechanisms that require evaluating external code.
function vis_goto_file(syntax, handler)
	if syntax and handler then
		external_match[syntax] = handler
	end
end

return M
