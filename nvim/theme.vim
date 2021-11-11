if (has("termguicolor"))
 set termguicolors
endif

lua << EOF
local catppuccino = require("catppuccino")

catppuccino.setup(
    {
		colorscheme = "soft_manilo",
		transparency = true,
		term_colors = true,
		styles = {
			comments = "italic",
			functions = "italic",
			keywords = "italic",
			strings = "NONE",
			variables = "NONE",
		},
		integrations = {
			treesitter = true,
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = "italic",
					hints = "italic",
					warnings = "italic",
					information = "italic",
				},
				underlines = {
					errors = "underline",
					hints = "underline",
					warnings = "underline",
					information = "underline",
				}
			},
			lsp_trouble = false,
			lsp_saga = false,
			gitgutter = false,
			gitsigns = false,
			telescope = false,
			nvimtree = {
				enabled = true,
				show_root = true,
			},
			which_key = false,
			indent_blankline = {
				enabled = false,
				colored_indent_levels = false,
			},
			dashboard = false,
			neogit = false,
			vim_sneak = false,
			fern = false,
			barbar = true,
			bufferline = false,
			markdown = false,
			lightspeed = false,
			ts_rainbow = false,
			hop = false,
		}
	}
)
EOF
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", 
  ignore_install = { "javascript" },
  highlight = {
    enable = true,              
    disable = { "c", "rust" }, 
    additional_vim_regex_highlighting = false,
  },
}
EOF

syntax enable
colorscheme catppuccino
let g:lightline = {'colorscheme': 'catppuccino'}


