local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged')

  Plug('catppuccin/nvim', {['as'] =  'catppuccin'})
  Plug 'tckmn/hotdog.vim'
  Plug ('pineapplegiant/spaceduck', { ['branch'] = 'main' })
  Plug 'thedenisnikulin/vim-cyberpunk'
  Plug 'bignimbus/pop-punk.vim'
  Plug 'tinted-theming/base16-vim'
  Plug 'sheerun/vim-polyglot'
  Plug 'fcpg/vim-farout'

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
  Plug 'nvim-lua/plenary.nvim'
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

  Plug('neoclide/npm.nvim', {['do'] = 'npm install'})

  Plug 'othree/html5.vim'
  Plug 'pangloss/vim-javascript'
  Plug ('evanleck/vim-svelte', {['branch'] = 'main'})

  Plug 'nvim-treesitter/nvim-treesitter'
  Plug 'rinx/nvim-minimap'
  Plug 'nvim-orgmode/orgmode'
  Plug 'wakatime/vim-wakatime'
  Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'phaazon/hop.nvim'
  Plug 'ggandor/leap.nvim'
  Plug 'glepnir/dashboard-nvim'
  Plug ('akinsho/toggleterm.nvim', {['tag'] = '*'})
  Plug 'folke/zen-mode.nvim'

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
require('saravenpi.dashboard')
require('saravenpi.prettier')
require('saravenpi.bindings')
require('saravenpi.vimwiki')
require('saravenpi.orgmode')
require('saravenpi.indent')
require('saravenpi.line')
require('saravenpi.toggleterm')
vim.cmd[[
    set guifont=Fira\ Code\ Nerd\ Font:h14
    let g:neovide_transparency = 0.8
    let g:neovide_floating_blur_amount_x = 100.0
    let g:neovide_floating_blur_amount_y = 100.0
    let g:neovide_configm_quit = v:true
    let g:neovide_cursor_vfx_mode = "pixiedust"
    let g:neovide_input_use_logo = v:true
    let g:neovide_cursor_vfx_particle_density = 15.0
    let g:neovide_particle_vfx_opacity = 300.0
    let g:neovide_profiler = v:false
]]
