vim.opt.number = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.termguicolors = true

local catppuccin = require("catppuccin")

catppuccin.setup({
  transparent_background = false,
  term_colors = true,
  styles = {
    comments = "italic",
    functions = "italic",
    keywords = "italic",
    strings = "NONE",
    variables = "italic",
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
    lsp_trouble = true,
    cmp = true,
    lsp_saga = true,
    gitgutter = false,
    gitsigns = true,
    telescope = true,
    nvimtree = {
      enabled = true,
      show_root = false,
      transparent_panel = false,
      },
    neotree = {
      enabled = false,
      show_root = false,
      transparent_panel = false,
      },
    which_key = true,
    indent_blankline = {
      enabled = true,
      colored_indent_levels = false,
      },
    dashboard = true,
    neogit = false,
    vim_sneak = false,
    fern = false,
    barbar = true,
    bufferline = true,
    markdown = true,
    lightspeed = false,
    ts_rainbow = false,
    hop = false,
    notify = true,
    telekasten = true,
  }
})

-- vim.cmd('colorscheme catppuccin')
-- vim.cmd('colorscheme paper')
-- vim.cmd('colorscheme gruvbox')
-- vim.o.background = "dark"
-- vim.cmd('colorscheme tokyonight')
vim.cmd('colorscheme dracula')

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'dracula',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}

require('nvim-treesitter.configs').setup {
  ensure_installed = "maintained", 
  highlight = {
    enable = true,              
    additional_vim_regex_highlighting = false,
  },
}

vim.opt.timeoutlen = 500

vim.api.nvim_set_keymap('t', '<Esc>','<C-\\><C-n>', { noremap = true })

vim.cmd[[
  let &t_SI .=  "\<esc>[4 q"
  let &t_EI .=  "\<esc>[2 q"
  let &t_ti .= "\e[2 q"
  let &t_te .= "\e[4 q"

  let g:mapleader = "\<Space>"
  let g:maplocalleader = ','
  " nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
  " nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
]]
