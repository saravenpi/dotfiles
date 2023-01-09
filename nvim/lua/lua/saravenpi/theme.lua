vim.opt.number = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.timeoutlen = 500
vim.opt.colorcolumn = "80"
vim.g.mapleader = " "
vim.cmd[[
    let &t_SI .=  "\<esc>[4 q"
    let &t_EI .=  "\<esc>[2 q"
    let &t_ti .= "\e[2 q"
    let &t_te .= "\e[4 q"
]]

require("catppuccin").setup({
        flavour = "latte",
        background = { 
            light = "latte",
            dark  = "mocha",
        },
        transparent_background = false,
        term_colors = false,
        dim_inactive = {
            enabled = false,
            shade = "dark",
            percentage = 0.15,
        },
        no_italic = false,
        no_bold = false,
        styles = {
            comments = { "italic" },
            conditionals = { "italic" },
            loops = {},
            functions = {},
            keywords = {},
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
            operators = {},
        },
        color_overrides = {},
        custom_highlights = {},
        integrations = {
            cmp = true,
            gitsigns = true,
            nvimtree = true,
            telescope = true,
            notify = true,
            mini = true,
            barbar = true,
            hop = true,
            leap = true,
        }
})
vim.cmd.colorscheme "catppuccin"
