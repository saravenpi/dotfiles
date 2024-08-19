-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local o = vim.o

o.expandtab = false
o.smartindent = true
o.tabstop = 4
o.shiftwidth = 4
vim.g.autoformat = false
vim.opt.colorcolumn = "80"
-- Function to toggle Sexplore window


function ToggleSexplore()
    local current_win = vim.api.nvim_get_current_win()
    -- Check for an existing netrw buffer
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local bufname = vim.api.nvim_buf_get_name(buf)
        -- Check if the buffer name starts with "netrw"
        if bufname:match("netrw") then
            vim.api.nvim_win_close(win, true)
            return
        end
    end

    -- If no netrw window is open, open it
    vim.cmd('Sexplore')

    -- Optionally, return focus to the original window
    vim.api.nvim_set_current_win(current_win)
end

-- Key mapping to toggle Sexplore window
vim.api.nvim_set_keymap('n', '<C-R>', '<cmd>lua ToggleSexplore()<CR>', { noremap = true, silent = true })
