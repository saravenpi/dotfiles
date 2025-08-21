local M = {}

M.specs = {
	{ src = "https://github.com/echasnovski/mini.icons" },
}

M.setup = function()
	local icons = require("mini.icons")
	icons.setup({
		style = "glyph",
		file = {
			["knot.yml"] = { glyph = "🪢", hl = "MiniIconsGreen" },
			["app.yml"] = { glyph = "🚀", hl = "MiniIconsGreen" },
			["package.yml"] = { glyph = "📦", hl = "MiniIconsGreen" },
			["kettle.json"] = { glyph = "🫖", hl = "MiniIconsGreen" },
			["tsconfig.json"] = { glyph = "⚙️", hl = "MiniIconsGreen" },
			["package.json"] = { glyph = "📦", hl = "MiniIconsGreen" },
			["package-lock.json"] = { glyph = "🔒", hl = "MiniIconsGreen" },
			["bun.lock"] = { glyph = "🔒", hl = "MiniIconsGreen" },
			["bun.lockb"] = { glyph = "🔒", hl = "MiniIconsGreen" },
			["egg.yml"] = { glyph = "🥚", hl = "MiniIconsOrange" },
			[".egg.yml"] = { glyph = "🥚", hl = "MiniIconsOrange" },
			["glint.yml"] = { glyph = "📰", hl = "MiniIconsGrey" },
			[".glint.yml"] = { glyph = "📰", hl = "MiniIconsGrey" },
			["purse.yml"] = { glyph = "💰", hl = "MiniIconsGrey" },
			[".purse.yml"] = { glyph = "💰", hl = "MiniIconsGrey" },
		},
		extension = {
			["yml"] = { glyph = "📄", hl = "MiniIconsGrey" },
			["yaml"] = { glyph = "📄", hl = "MiniIconsGrey" },
		},
	})

	icons.tweak_lsp_kind("replace", {
		Array = { hl = "MiniIconsOrange" },
		Boolean = { hl = "MiniIconsOrange" },
		Class = { hl = "MiniIconsYellow" },
		Color = { hl = "MiniIconsGreen" },
		Constant = { hl = "MiniIconsOrange" },
		Constructor = { hl = "MiniIconsBlue" },
		Enum = { hl = "MiniIconsYellow" },
		EnumMember = { hl = "MiniIconsGreen" },
		Event = { hl = "MiniIconsRed" },
		Field = { hl = "MiniIconsGreen" },
		File = { hl = "MiniIconsBlue" },
		Folder = { hl = "MiniIconsBlue" },
		Function = { hl = "MiniIconsBlue" },
		Interface = { hl = "MiniIconsYellow" },
		Key = { hl = "MiniIconsPurple" },
		Keyword = { hl = "MiniIconsPurple" },
		Method = { hl = "MiniIconsBlue" },
		Module = { hl = "MiniIconsYellow" },
		Namespace = { hl = "MiniIconsYellow" },
		Null = { hl = "MiniIconsGrey" },
		Number = { hl = "MiniIconsOrange" },
		Object = { hl = "MiniIconsYellow" },
		Operator = { hl = "MiniIconsPurple" },
		Package = { hl = "MiniIconsYellow" },
		Property = { hl = "MiniIconsGreen" },
		Reference = { hl = "MiniIconsRed" },
		Snippet = { hl = "MiniIconsGreen" },
		String = { hl = "MiniIconsGreen" },
		Struct = { hl = "MiniIconsYellow" },
		Text = { hl = "MiniIconsGrey" },
		TypeParameter = { hl = "MiniIconsYellow" },
		Unit = { hl = "MiniIconsOrange" },
		Value = { hl = "MiniIconsOrange" },
		Variable = { hl = "MiniIconsRed" },
	})

	-- Mock nvim-web-devicons for neo-tree compatibility
	icons.mock_nvim_web_devicons()
end

return M
