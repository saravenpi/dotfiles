vim.api.nvim_set_keymap('n', '<A-,>', ':BufferPrevious<CR>', {noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-.>', ':BufferNext<CR>', {noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-<>', ':BufferMovePrevious<CR>', {noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A->>', ':BufferMoveNext<CR>', {noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-1>', ':BufferGoto 1<CR>', {noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-2>', ':BufferGoto 2<CR>', {noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-3>', ':BufferGoto 3<CR>', {noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-4>', ':BufferGoto 4<CR>', {noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-5>', ':BufferGoto 4<CR>', {noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-6>', ':BufferGoto 5<CR>', {noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-7>', ':BufferGoto 6<CR>', {noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-8>', ':BufferGoto 7<CR>', {noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-9>', ':BufferGoto 8<CR>', {noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-p>', ':BufferPin<CR>', {noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-c>', ':BufferClose<CR>', {noremap = true, silent = true })
