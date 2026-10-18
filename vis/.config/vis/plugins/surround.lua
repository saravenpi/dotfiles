-- Vis Surround Plugin
-- Surround manipulation (inspired by vim-surround)
-- Mappings:
--   cs<old><new> - Change surrounding pair
--   ds<old>      - Delete surrounding pair
--   S<char>      - (Visual mode) Surround selection

local surroundings = {
	{ "{", "}" },
	{ "[", "]" },
	{ "(", ")" },
	{ "<", ">" },
	'"',
	"'",
	"`",
}

local function left(a)
	for _, i in pairs(surroundings) do
		if type(i) == "table" then
			if i[1] == a then
				return a
			elseif i[2] == a then
				return i[1]
			end
		else
			if i == a then
				return a
			end
		end
	end
	return a
end

local function right(a)
	for _, i in pairs(surroundings) do
		if type(i) == "table" then
			if i[1] == a then
				return i[2]
			elseif i[2] == a then
				return a
			end
		else
			if i == a then
				return a
			end
		end
	end
	return a
end

local function esc(str)
	if not str then
		return ""
	end
	return (
		str:gsub("%%", "%%%%")
			:gsub("^%^", "%%^")
			:gsub("%$$", "%%$")
			:gsub("%(", "%%(")
			:gsub("%)", "%%)")
			:gsub("%.", "%%.")
			:gsub("%[", "%%[")
			:gsub("%]", "%%]")
			:gsub("%*", "%%*")
			:gsub("%+", "%%+")
			:gsub("%-", "%%-")
			:gsub("%?", "%%?")
	)
end

local function find_surrounding(file, pos, l_char, r_char)
	local left_data = file:content(0, pos)
	local right_data = file:content(pos + 1, file.size)
	local left_idx = left_data:match("^.*()" .. esc(l_char))
	local right_idx = right_data:match("^[^" .. esc(r_char) .. "]*()")
	if left_idx and right_idx then
		return (left_idx - 1), (pos + right_idx)
	else
		return nil
	end
end

-- Normal mode: cs<old><new>
vis:map(vis.modes.NORMAL, "cs", function(keys)
	if #keys < 2 then
		return -1
	end
	local k1, k2 = keys:sub(1, 1), keys:sub(2, 2)
	local left_old, right_old = left(k1), right(k1)
	local left_new, right_new = left(k2), right(k2)
	if not (left_old and right_old and left_new and right_new) then
		return 2
	end

	local win = vis.win
	local file = win.file
	local pos = win.selection.pos
	local l, r = find_surrounding(file, pos, left_old, right_old)
	if not l or not r then
		return 2
	end

	file:delete(l, 1)
	file:insert(l, left_new)
	file:delete(r, 1)
	file:insert(r, right_new)
	win.selection.pos = pos
	return 2
end, "Change surroundings (cs<old><new>)")

-- Normal mode: ds<old>
vis:map(vis.modes.NORMAL, "ds", function(keys)
	if #keys < 1 then
		return -1
	end
	local k = keys:sub(1, 1)
	local l_char = left(k)
	local r_char = right(k)
	if not (l_char and r_char) then
		return 1
	end

	local win = vis.win
	local file = win.file
	local pos = win.selection.pos
	local l, r = find_surrounding(file, pos, l_char, r_char)
	if not l or not r then
		return 1
	end

	file:delete(l, 1)
	file:delete(r - 1, 1)
	win.selection.pos = pos > 0 and pos - 1 or 0
	return 1
end, "Delete surroundings (ds<char>)")

-- Visual mode: S<char>
vis:map(vis.modes.VISUAL, "S", function(keys)
	if #keys < 1 then
		return -1
	end
	local ch = keys:sub(1, 1)
	local l_char = left(ch)
	local r_char = right(ch)

	local win = vis.win
	local file = win.file
	for sel in win:selections_iterator() do
		local range = sel.range
		if range then
			file:insert(range.finish, r_char)
			file:insert(range.start, l_char)
		end
	end

	vis.mode = vis.modes.NORMAL
	return 1
end, "Surround visual selection (S<char>)")
