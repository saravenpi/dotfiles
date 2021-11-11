set number
set encoding=UTF-8
filetype plugin on
set tabstop=4
set shiftwidth=4
set expandtab

let &t_SI = "\<esc>[5 q"  " blinking I-beam in insert mode
let &t_SR = "\<esc>[3 q"  " blinking underline in replace mode
let &t_EI = "\<esc>[ q"  " default cursor (usually blinking block) otherwise

call plug#begin("~/.config/nvim/plugged")
Plug 'Pocco81/Catppuccino.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'ryanoasis/vim-devicons'
Plug 'jiangmiao/auto-pairs'
Plug 'machakann/vim-sandwich'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'romgrk/barbar.nvim'
Plug 'itchyny/lightline.vim'
Plug 'hrsh7th/nvim-compe'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'christoomey/vim-tmux-navigator' 
Plug 'tpope/vim-commentary'
call plug#end()

source ~/.config/nvim/theme.vim
source ~/.config/nvim/completion.vim
source ~/.config/nvim/telescope.vim
source ~/.config/nvim/tree.vim
source ~/.config/nvim/bar.vim
" Shortcut to exit terminal mode with <Esc>
tnoremap <Esc> <C-\><C-n>
