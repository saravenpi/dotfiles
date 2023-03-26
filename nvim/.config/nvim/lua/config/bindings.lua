vim.cmd[[
let mapleader = "\<Space>"
]]
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('t', '<Esc>','<C-\\><C-n>', { noremap = true })
vim.api.nvim_set_keymap( 'n', '<leader>cdr', '<cmd>!dotnet run<CR>', opts)
vim.api.nvim_set_keymap( 'n', '<leader>cns', '<cmd>NpmRun start<CR>', opts)
vim.api.nvim_set_keymap( 'n', '<leader>cnd', '<cmd>NpmRun dev<CR>', opts)
vim.api.nvim_set_keymap( 'n', '<leader>tt', '<cmd>ToggleTerm<CR>', opts)
vim.api.nvim_set_keymap( 'n', ';', '<cmd>HopAnywhere<CR>', opts)
vim.api.nvim_set_keymap( 'n', '<leader>bb', '<cmd>set splitright | vsplit | :terminal abricot<CR>', opts)

local hop = require('hop')
local directions = require('hop.hint').HintDirection

vim.keymap.set('', 'f', function()
    hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, {remap=true})

vim.keymap.set('', 'F', function()
    hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, {remap=true})

vim.keymap.set('', 't', function()
    hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, {remap=true})

vim.keymap.set('', 'T', function()
    hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, {remap=true})

require'hop'.setup()
require('leap').add_default_mappings()


vim.api.nvim_set_keymap( 'n', ';', '<cmd>HopAnywhere<CR>', opts)

local hop = require('hop')
local directions = require('hop.hint').HintDirection

vim.keymap.set('', 'f', function()
    hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, {remap=true})

vim.keymap.set('', 'F', function()
    hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, {remap=true})

vim.keymap.set('', 't', function()
    hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, {remap=true})

vim.keymap.set('', 'T', function()
    hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, {remap=true})

require'hop'.setup()
require('leap').add_default_mappings()

vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>", {noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>", {noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>", {noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<cr>", {noremap = true })


