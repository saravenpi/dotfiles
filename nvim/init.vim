set number
set encoding=UTF-8
filetype plugin on

call plug#begin("~/.config/nvim/plugged")
Plug 'scrooloose/nerdtree'
Plug 'Pocco81/Catppuccino.nvim'
Plug 'tpope/vim-commentary'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ryanoasis/vim-devicons'
Plug 'christoomey/vim-tmux-navigator' 
Plug 'ap/vim-css-color'
Plug 'jiangmiao/auto-pairs'
Plug 'machakann/vim-sandwich'
Plug 'romgrk/barbar.nvim'
Plug 'itchyny/lightline.vim'
call plug#end()

if (has("termguicolor"))
 set termguicolors
endif

lua << EOF
local catppuccino = require("catppuccino")

-- configure it
catppuccino.setup(
    {
		colorscheme = "soft_manilo",
		transparency = true,
		term_colors = false,
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

syntax enable
colorscheme catppuccino
let g:lightline = {'colorscheme': 'catppuccino'}


let g:NERDTreeIgnore = ['^node_modules$']
let NERDTreeShowHidden=1
nnoremap <silent>    <C-n> :NERDTreeToggle<CR>

nnoremap <silent>    <A-,> :BufferPrevious<CR>
nnoremap <silent>    <A-.> :BufferNext<CR>
nnoremap <silent>    <A-<> :BufferMovePrevious<CR>
nnoremap <silent>    <A->> :BufferMoveNext<CR>
nnoremap <silent>    <A-1> :BufferGoto 1<CR>
nnoremap <silent>    <A-2> :BufferGoto 2<CR>
nnoremap <silent>    <A-3> :BufferGoto 3<CR>
nnoremap <silent>    <A-4> :BufferGoto 4<CR>
nnoremap <silent>    <A-5> :BufferGoto 5<CR>
nnoremap <silent>    <A-6> :BufferGoto 6<CR>
nnoremap <silent>    <A-7> :BufferGoto 7<CR>
nnoremap <silent>    <A-8> :BufferGoto 8<CR>
nnoremap <silent>    <A-9> :BufferLast<CR>
nnoremap <silent>    <A-p> :BufferPin<CR>
nnoremap <silent>    <A-c> :BufferClose<CR>

