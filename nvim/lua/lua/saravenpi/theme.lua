vim.opt.number = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.timeoutlen = 500

vim.cmd[[
    let &t_SI .=  "\<esc>[4 q"
    let &t_EI .=  "\<esc>[2 q"
    let &t_ti .= "\e[2 q"
    let &t_te .= "\e[4 q"
    let g:mapleader = "\<Space>"
    let g:maplocalleader = ','
    " nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
    " nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
    :set colorcolumn=80
    colorscheme pop-punk
]]
