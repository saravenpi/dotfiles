local M = {}

M.specs = {
	{ src = "https://github.com/sainnhe/gruvbox-material" },
	{ src = "https://github.com/ellisonleao/gruvbox.nvim" },
}

M.setup = function()
	vim.g.gruvbox_material_background = "hard"
	vim.g.gruvbox_material_better_performance = 1
	vim.g.gruvbox_material_enable_italic = 1
	vim.g.gruvbox_material_diagnostic_text_highlight = "colored"
	vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
	vim.g.gruvbox_material_diagnostic_line_highlight = "colored"
	vim.g.gruvbox_material_diagnostic_sign_highlight = "colored"
	vim.g.gruvbox_material_palette = "mix"
	local ok_colorscheme = pcall(vim.cmd, "colorscheme gruvbox-material")
	if not ok_colorscheme then
		pcall(vim.cmd, "colorscheme gruvbox")
	end
	vim.cmd("hi StatusLine guibg=NONE")
end

return M
