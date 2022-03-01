call plug#begin("~/.config/nvim/plugged")
Plug 'catppuccin/nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'romgrk/barbar.nvim'
Plug 'itchyny/lightline.vim'
Plug 'hrsh7th/nvim-compe' 
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-commentary'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ryanoasis/vim-devicons'
Plug 'jiangmiao/auto-pairs'
Plug 'machakann/vim-sandwich'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'vimwiki/vimwiki'
Plug 'mattn/calendar-vim'
call plug#end()

source ~/.config/nvim/theme.vim
source ~/.config/nvim/completion.vim
source ~/.config/nvim/telescope.vim
source ~/.config/nvim/tree.vim
source ~/.config/nvim/bar.vim
source ~/.config/nvim/vimwiki.vim
source ~/.config/nvim/other_shortcuts.vim
