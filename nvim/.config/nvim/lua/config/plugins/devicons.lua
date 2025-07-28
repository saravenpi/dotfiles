local M = {}

M.specs = {
	{ src = "https://github.com/rachartier/tiny-devicons-auto-colors.nvim" },
}

M.setup = function()
	require("tiny-devicons-auto-colors").setup({})
	require("nvim-web-devicons").setup({ color_icons = true, default = true })

	local devicons = require("nvim-web-devicons")

	devicons.set_icon({
		["egg.yml"] = {
			icon = "🥚",
			color = "#ffaa00",
			name = "EggYml",
		},
	})

	devicons.set_icon({
		[".egg.yml"] = {
			icon = "🥚",
			color = "#ffaa00",
			name = "EggYml",
		},
	})

	devicons.set_icon({
		["glint.yml"] = {
			icon = "📰",
			color = "#6d8086",
			name = "Glint",
		},
	})

	devicons.set_icon({
		[".glint.yml"] = {
			icon = "📰",
			color = "#6d8086",
			name = "Glint",
		},
	})

	devicons.set_icon({
		["purse.yml"] = {
			icon = "💰",
			color = "#6d8086",
			name = "Purse",
		},
	})

	devicons.set_icon({
		[".purse.yml"] = {
			icon = "💰",
			color = "#6d8086",
			name = "Purse",
		},
	})

	devicons.set_icon({
		yml = {
			icon = "📄",
			color = "#6d8086",
			name = "Yaml",
		},
	})
end

return M
