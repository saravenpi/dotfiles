local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged')

  Plug 'thedenisnikulin/vim-cyberpunk'
  Plug 'bignimbus/pop-punk.vim'
  Plug('catppuccin/nvim', { ['as']= 'catppuccin' })

  Plug 'romgrk/barbar.nvim'
  Plug 'nvim-lualine/lualine.nvim'

  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'

  Plug 'L3MON4D3/LuaSnip'
  Plug 'saadparwaiz1/cmp_luasnip'
  Plug 'rafamadriz/friendly-snippets'
  Plug 'tami5/lspsaga.nvim'
  Plug 'RishabhRD/popfix'
  Plug 'RishabhRD/nvim-lsputils'

  Plug 'hrsh7th/cmp-emoji'
  Plug 'hrsh7th/cmp-nvim-lua'

  Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
  Plug 'folke/trouble.nvim'

  Plug 'tpope/vim-commentary'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'junegunn/fzf.vim'
  Plug 'folke/which-key.nvim'


  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'kyazdani42/nvim-tree.lua'

  Plug 'jiangmiao/auto-pairs'
  Plug 'machakann/vim-sandwich'
  Plug 'neovim/nvim-lspconfig'
  Plug 'jose-elias-alvarez/null-ls.nvim'
  Plug 'MunifTanjim/prettier.nvim'

  Plug 'vimwiki/vimwiki'
  Plug 'tpope/vim-fugitive'
  Plug 'fatih/vim-go'
  Plug 'chrisbra/Colorizer'
  Plug 'rcarriga/nvim-notify'
  Plug 'othree/html5.vim'
  Plug 'pangloss/vim-javascript'
  Plug ('evanleck/vim-svelte', {['branch'] = 'main'})
  Plug 'nvim-treesitter/nvim-treesitter'
  Plug 'wakatime/vim-wakatime'
  Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'phaazon/hop.nvim'
  Plug 'ggandor/leap.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'vappolinario/cmp-clippy'
vim.call('plug#end')

require('saravenpi.theme')
require('saravenpi.lsp')
require('saravenpi.cmp')
require('saravenpi.tree')
require('saravenpi.telescope')
require('saravenpi.bar')
require('saravenpi.notify')
require('saravenpi.lspsaga')
require('saravenpi.trouble')
require('saravenpi.which-key')
require('saravenpi.prettier')
require('saravenpi.bindings')
require('saravenpi.vimwiki')
require('saravenpi.indent')
require('saravenpi.lualine')
