local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged')

-- COLORSCHEMES
Plug 'tanvirtin/monokai.nvim'
Plug ('catppuccin/nvim', { ['as'] = 'catppuccin' })
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})

-- BARS
-- Plug 'romgrk/barbar.nvim'
Plug 'nvim-lualine/lualine.nvim'

-- TREE
Plug 'kyazdani42/nvim-tree.lua'

-- LSP/CMP
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'RishabhRD/nvim-lsputils'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-emoji'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'tami5/lspsaga.nvim'
Plug 'folke/trouble.nvim'

-- SNIPPETS
Plug 'Heliferepo/VimTek'
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'RishabhRD/popfix'


-- GOTTA GO FAST
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'junegunn/fzf.vim'
Plug 'phaazon/hop.nvim'
Plug 'ggandor/leap.nvim'
Plug 'folke/which-key.nvim'

-- AUTOMATED EDITION TOOLS
Plug 'jiangmiao/auto-pairs'
Plug 'machakann/vim-sandwich'
Plug 'jose-elias-alvarez/null-ls.nvim'

-- ESTHETICS
Plug 'rcarriga/nvim-notify'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'kyazdani42/nvim-web-devicons'

Plug 'vimwiki/vimwiki'
Plug 'tpope/vim-fugitive'
Plug 'fatih/vim-go'
Plug 'chrisbra/Colorizer'
Plug 'othree/html5.vim'

-- LANGUAGES/FRAMEWORS SUPPORT
Plug 'pangloss/vim-javascript'
Plug ('evanleck/vim-svelte', {['branch'] = 'main'})
Plug 'vappolinario/cmp-clippy'

-- UTILS
Plug 'wakatime/vim-wakatime'

-- DEV TOOLS
Plug('sakhnik/nvim-gdb', { ['do'] = ':!./install.sh' })
Plug 'lewis6991/gitsigns.nvim'
Plug 'jackMort/ChatGPT.nvim'

-- OBSIDIAN
Plug 'epwalsh/obsidian.nvim'

Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

vim.call('plug#end')

require('config.theme')
require('config.bar')
require('config.bindings')
require('config.cmp')
require('config.indent')
require('config.lualine')
require('config.notify')
require('config.obsidian')
require('config.tree')
require('config.trouble')
require('config.vimwiki')
require('config.which-key')
require('config.gitsigns')
require('config.lsp')

vim.g.neovide_scale_factor = 0.7
vim.o.guifont = "SpaceMono NF:h12"
