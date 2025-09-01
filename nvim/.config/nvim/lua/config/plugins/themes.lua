local M = {}

M.specs = {
	{ src = "https://github.com/sainnhe/gruvbox-material" },
	{ src = "https://github.com/mellow-theme/mellow.nvim" },
}

M.setup = function()
	vim.g.gruvbox_material_background = "hard"
	vim.g.gruvbox_material_better_performance = 1
	vim.g.gruvbox_material_transparent_background = 2
	vim.g.gruvbox_material_enable_italic = 1
	vim.g.gruvbox_material_diagnostic_text_highlight = "colored"
	vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
	vim.g.gruvbox_material_diagnostic_line_highlight = "colored"
	vim.g.gruvbox_material_diagnostic_sign_highlight = "colored"
	vim.g.gruvbox_material_palette = "mix"

	vim.g.mellow_italic_functions = true
	vim.g.mellow_bold_functions = true
	vim.g.mellow_transparent = true

	vim.cmd.colorscheme("gruvbox-material")
	-- vim.cmd.colorscheme("mellow")
end

return M
