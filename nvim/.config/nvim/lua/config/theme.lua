vim.opt.number = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.timeoutlen = 500
vim.opt.colorcolumn = "80"
vim.g.mapleader = " "
vim.cmd[[
    set termguicolors
    let &t_SI .=  "\<esc>[4 q"
    let &t_EI .=  "\<esc>[2 q"
    let &t_ti .= "\e[2 q"
    let &t_te .= "\e[4 q"
]]
vim.opt.termguicolors = true
vim.cmd.colorscheme "monokai"
