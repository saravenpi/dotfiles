local M = {}

M.specs = {
	{ src = "https://github.com/catgoose/nvim-colorizer.lua" },
}

M.setup = function()
	require("colorizer").setup({
		filetypes = { "*" },
		user_default_options = {
			RGB = true,
			RRGGBB = true,
			names = false,
			RRGGBBAA = true,
			AARRGGBB = true,
			rgb_fn = true,
			hsl_fn = true,
			css = true,
			css_fn = true,
			tailwind = true,
			-- sass = { enable = true },
			mode = "background",
			virtualtext = "■",
		},
		buftypes = {},
	})
end

return M

