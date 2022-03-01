set number
set encoding=UTF-8
set tabstop=4
set shiftwidth=4
set expandtab
if (has("termguicolor"))
 set termguicolors
endif

lua << EOF
local catppuccin = require("catppuccin")

-- configure it
catppuccin.setup(
    {
		transparent_background = true,
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
				},
			},
			lsp_trouble = false,
			lsp_saga = false,
			gitgutter = false,
			gitsigns = false,
			telescope = true,
			nvimtree = {
				enabled = false,
				show_root = false,
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
			markdown = true,
			lightspeed = false,
			ts_rainbow = false,
			hop = false,
		},
	}
)
EOF

colorscheme catppuccin
let g:lightline = {'colorscheme': 'catppuccin'}


lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", 
  highlight = {
    enable = true,              
    additional_vim_regex_highlighting = false,
  },
}
EOF

" Insert Mode 
let &t_SI .=  "\<esc>[4 q"
" Normal Mode
let &t_EI .=  "\<esc>[2 q"

let &t_ti .= "\e[2 q"
let &t_te .= "\e[4 q"

