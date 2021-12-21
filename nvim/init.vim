set number
set encoding=UTF-8
filetype plugin on
set tabstop=4
set shiftwidth=4
set expandtab

" Insert Mode 
let &t_SI .=  "\<esc>[4 q"
" Normal Mode
let &t_EI .=  "\<esc>[2 q"

let &t_ti .= "\e[2 q"
let &t_te .= "\e[4 q"

call plug#begin("~/.config/nvim/plugged")
Plug 'dracula/vim', {'as':'dracula'}
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
Plug 'tpope/vim-commentary'
" Plug 'vimsence/vimsence'
call plug#end()

source ~/.config/nvim/theme.vim
source ~/.config/nvim/completion.vim
source ~/.config/nvim/telescope.vim
source ~/.config/nvim/tree.vim
source ~/.config/nvim/bar.vim
" Shortcut to exit terminal mode with <Esc>
tnoremap <Esc> <C-\><C-n>
