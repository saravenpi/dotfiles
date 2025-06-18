-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local o = vim.o

o.expandtab = true --set to true to insert spaces when tab is pressed
o.smartindent = true
o.tabstop = 2
o.shiftwidth = 2
o.spell = false
o.colorcolumn = "80"
o.conceallevel = 1
o.laststatus = 3
vim.g.autoformat = true -- to format on save
