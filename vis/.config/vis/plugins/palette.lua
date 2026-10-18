-- Vis Palette Adapter Plugin
-- Dynamically loads terminal & editor colors from ~/.config/palette/config.yml
-- and maps them to Vis syntax & UI styles matching Neovim's nvim/lua/palette.lua

local M = {}

-- Load 16-color ANSI palette + bg/fg/cursor from YAML or fallback
function M.get_palette()
	local home = os.getenv("HOME") or "/home/sara"
	local config_paths = {
		home .. "/.config/palette/config.yml",
		home .. "/.dotfiles/palette/.config/palette/config.yml",
		home .. "/.palette.yml",
	}

	for _, path in ipairs(config_paths) do
		local f = io.open(path, "r")
		if f then
			local content = f:read("*a")
			f:close()
			local colors = {}
			local list = {}

			for line in content:gmatch("[^\r\n]+") do
				local key, val = line:match("^%s*([%w_-]+)%s*:%s*['\"]?(#[0-9a-fA-F]+)['\"]?")
				if key and val then
					colors[key] = val
				else
					local item = line:match("^%s*-%s*['\"]?(#[0-9a-fA-F]+)['\"]?")
					if item then
						table.insert(list, item)
					end
				end
			end

			if #list >= 16 then
				colors.black = list[1]
				colors.red = list[2]
				colors.green = list[3]
				colors.yellow = list[4]
				colors.blue = list[5]
				colors.magenta = list[6]
				colors.cyan = list[7]
				colors.white = list[8]
				colors.bright_black = list[9]
				colors.bright_red = list[10]
				colors.bright_green = list[11]
				colors.bright_yellow = list[12]
				colors.bright_blue = list[13]
				colors.bright_magenta = list[14]
				colors.bright_cyan = list[15]
				colors.bright_white = list[16]
			end

			colors.bg = colors.background or colors.bg or "#111318"
			colors.fg = colors.foreground or colors.fg or "#e4e2e3"
			colors.cursor = colors.cursor or "#b4ccff"

			return colors
		end
	end

	-- Fallback to Neovim palette file if available
	local nvim_palette = home .. "/.config/nvim/lua/palette.lua"
	local nf = io.open(nvim_palette, "r")
	if nf then
		local content = nf:read("*a")
		nf:close()
		local colors = {}
		for k, v in content:gmatch('([%w_]+)%s*=%s*"([#%w]+)"') do
			colors[k] = v
		end
		if colors.bg and colors.fg then
			return colors
		end
	end

	-- Hardcoded fallback (matching default palette)
	return {
		bg = "#111318",
		fg = "#e4e2e3",
		cursor = "#b4ccff",
		black = "#1d2025",
		red = "#da98b5",
		green = "#9db374",
		yellow = "#c2a95f",
		blue = "#82b1d4",
		magenta = "#c49ed1",
		cyan = "#72b6c0",
		white = "#c8c6c7",
		bright_black = "#6b6d74",
		bright_red = "#ffc8de",
		bright_green = "#c9e09d",
		bright_yellow = "#f1d586",
		bright_blue = "#b1dcff",
		bright_magenta = "#f2cafe",
		bright_cyan = "#9ee2ed",
		bright_white = "#f9f6f5",
	}
end

-- Apply palette colors to vis.lexers
function M.apply()
	local c = M.get_palette()
	local lexers = vis.lexers

	lexers.colors = c

	-- Core UI Elements
	lexers.STYLE_DEFAULT = "fore:" .. c.fg .. ",back:" .. c.bg
	lexers.STYLE_NOTHING = "back:" .. c.bg
	lexers.STYLE_LINENUMBER = "fore:" .. c.bright_black .. ",back:" .. c.bg
	lexers.STYLE_LINENUMBER_CURSOR = "fore:" .. c.cursor .. ",back:" .. c.bg .. ",bold"
	lexers.STYLE_CURSOR = "fore:" .. c.bg .. ",back:" .. c.cursor
	lexers.STYLE_CURSOR_PRIMARY = "fore:" .. c.bg .. ",back:" .. c.cursor .. ",bold"
	lexers.STYLE_CURSOR_LINE = "back:" .. c.black
	lexers.STYLE_COLOR_COLUMN = "back:" .. c.black
	lexers.STYLE_SELECTION = "back:" .. c.bright_black
	lexers.STYLE_STATUS = "fore:" .. c.fg .. ",back:" .. c.black
	lexers.STYLE_STATUS_FOCUSED = "fore:" .. c.fg .. ",back:" .. c.black .. ",bold"
	lexers.STYLE_SEPARATOR = "fore:" .. c.black .. ",back:" .. c.bg
	lexers.STYLE_INFO = "fore:" .. c.blue .. ",bold"
	lexers.STYLE_EOF = "fore:" .. c.bright_black
	lexers.STYLE_WHITESPACE = "fore:" .. c.black

	-- Syntax Highlighting (1:1 with nvim/lua/palette.lua)
	lexers.STYLE_CLASS = "fore:" .. c.yellow
	lexers.STYLE_COMMENT = "fore:" .. c.bright_black .. ",italics"
	lexers.STYLE_CONSTANT = "fore:" .. c.yellow
	lexers.STYLE_DEFINITION = "fore:" .. c.blue .. ",bold"
	lexers.STYLE_ERROR = "fore:" .. c.red .. ",italics"
	lexers.STYLE_FUNCTION = "fore:" .. c.blue .. ",bold"
	lexers.STYLE_KEYWORD = "fore:" .. c.magenta .. ",bold"
	lexers.STYLE_LABEL = "fore:" .. c.magenta
	lexers.STYLE_NUMBER = "fore:" .. c.yellow
	lexers.STYLE_OPERATOR = "fore:" .. c.cyan
	lexers.STYLE_REGEX = "fore:" .. c.green
	lexers.STYLE_STRING = "fore:" .. c.green
	lexers.STYLE_PREPROCESSOR = "fore:" .. c.cyan
	lexers.STYLE_TAG = "fore:" .. c.magenta
	lexers.STYLE_TYPE = "fore:" .. c.yellow
	lexers.STYLE_VARIABLE = "fore:" .. c.fg
	lexers.STYLE_EMBEDDED = "fore:" .. c.cyan
	lexers.STYLE_IDENTIFIER = "fore:" .. c.fg

	-- Diff Highlighting
	lexers.STYLE_ADDITION = "fore:" .. c.green
	lexers.STYLE_DELETION = "fore:" .. c.red
	lexers.STYLE_CHANGE = "fore:" .. c.yellow

	-- Markdown & Document markup
	lexers.STYLE_HEADING = "fore:" .. c.magenta .. ",bold"
	local headings = { c.red, c.magenta, c.yellow, c.green, c.blue, c.cyan }
	for i = 1, 6 do
		lexers["STYLE_HEADING_H" .. i] = "fore:" .. headings[i] .. ",bold"
	end
	lexers.STYLE_BOLD = "bold"
	lexers.STYLE_ITALIC = "italics"
	lexers.STYLE_LINK = "fore:" .. c.cyan .. ",underlined"
	lexers.STYLE_CODE_BLOCK = "fore:" .. c.green .. ",back:" .. c.black
	lexers.STYLE_LIST = "fore:" .. c.magenta

	-- Refresh syntax in all open windows
	for win in vis:windows() do
		win:set_syntax(win.syntax)
	end

	return true
end

-- Reload helper
function M.reload()
	M.apply()
	vis:info("🎨 Palette reloaded from ~/.config/palette/config.yml")
end

-- Register :palette command in Vis
vis:command_register("palette", function(argv)
	local subcmd = argv[1]
	if not subcmd or subcmd == "reload" or subcmd == "sync" then
		M.reload()
	elseif subcmd == "show" then
		local c = M.get_palette()
		vis:info(string.format("Palette: bg=%s fg=%s cursor=%s", c.bg, c.fg, c.cursor))
	else
		vis:info("Usage: :palette [reload|show]")
	end
end, "Palette adapter: reload or show current theme colors")

return M
