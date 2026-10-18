-- Vis Autopairs Plugin
-- Automatic insertion and smart skipping of matching brackets and quotes in insert mode

local pairs_map = {
	["("] = ")",
	["["] = "]",
	["{"] = "}",
	['"'] = '"',
	["'"] = "'",
	["`"] = "`",
}

for open, close in pairs(pairs_map) do
	-- When typing opening delimiter, insert pair and place cursor between them
	vis:map(vis.modes.INSERT, open, function()
		local win = vis.win
		local file = win.file
		local pos = win.selection.pos or 0
		file:insert(pos, open .. close)
		win.selection.pos = pos + #open
	end)

	-- If open and close differ, handle smart skipping of closing delimiter
	if open ~= close then
		vis:map(vis.modes.INSERT, close, function()
			local win = vis.win
			local file = win.file
			local pos = win.selection.pos or 0
			if pos < file.size then
				local next_char = file:content(pos, #close)
				if next_char == close then
					win.selection.pos = pos + #close
					return
				end
			end
			file:insert(pos, close)
			win.selection.pos = pos + #close
		end)
	end
end
