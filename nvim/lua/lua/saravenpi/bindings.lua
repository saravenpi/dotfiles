local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap( 'n', '<leader>cdr', '<cmd>!dotnet run<CR>', opts)
vim.api.nvim_set_keymap( 'n', '<leader>cns', '<cmd>NpmRun start<CR>', opts)
vim.api.nvim_set_keymap( 'n', '<leader>cnd', '<cmd>NpmRun dev<CR>', opts)
