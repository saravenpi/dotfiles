-- Vis Modern Statusline
-- Sleek, minimalist statusline inspired by Neovim lualine

local M = {}

local modes = {
	[vis.modes.NORMAL] = "NORMAL",
	[vis.modes.OPERATOR_PENDING] = "PENDING",
	[vis.modes.VISUAL] = "VISUAL",
	[vis.modes.VISUAL_LINE] = "V-LINE",
	[vis.modes.INSERT] = "INSERT",
	[vis.modes.REPLACE] = "REPLACE",
}

function M.setup()
	vis.events.subscribe(vis.events.WIN_STATUS, function(win)
		local left_parts = {}
		local right_parts = {}
		local file = win.file
		local sel = win.selection

		-- 1. Editor mode
		local mode = modes[vis.mode] or ""
		if vis.win == win and mode ~= "" then
			table.insert(left_parts, mode)
		end

		-- 2. File information
		local name = file.name or "[No Name]"
		local modified = file.modified and "[+]" or ""
		local recording = vis.recording and ("@" .. vis.recording) or ""

		local file_info = name
		if modified ~= "" then
			file_info = file_info .. " " .. modified
		end
		if recording ~= "" then
			file_info = file_info .. " " .. recording
		end
		table.insert(left_parts, file_info)

		-- 3. Right side: active keys / count
		local keys = vis.input_queue
		if keys and keys ~= "" then
			table.insert(right_parts, keys)
		elseif vis.count then
			table.insert(right_parts, tostring(vis.count))
		end

		-- 4. Multi-selection indicator
		if #win.selections > 1 then
			table.insert(right_parts, sel.number .. "/" .. #win.selections .. " sel")
		end

		-- 5. Syntax / Filetype
		local syntax = win.syntax or "text"
		table.insert(right_parts, syntax)

		-- 6. File progress percentage
		local size = file.size or 0
		local pos = sel.pos or 0
		local pct = "Top"
		if size > 0 then
			local percent = math.floor((pos / size) * 100)
			if percent >= 98 then
				pct = "Bot"
			elseif percent > 0 then
				pct = percent .. "%"
			end
		end
		table.insert(right_parts, pct)

		-- 7. Line & Column
		local line = sel.line or 1
		local col = sel.col or 1
		table.insert(right_parts, string.format("%d:%d", line, col))

		-- Render left and right sections
		local left = " " .. table.concat(left_parts, "  │  ") .. " "
		local right = " " .. table.concat(right_parts, "  │  ") .. " "
		win:status(left, right)

		return true
	end, 1)
end

return M
