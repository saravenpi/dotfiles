return {
    "vimwiki/vimwiki",
	enabled = true,
    config = function()
        vim.cmd([[
			let g:vimwiki_list = [{'path': '~/vimwiki/',
			\ 'syntax': 'markdown', 'ext': 'md'}]
		]])
		-- vim.api.nvim_set_keymap('n', '<C-t>', ':VimwikiToggleListItem<CR>', {noremap = true, silent = true})
		vim.api.nvim_set_keymap('n', '<leader>wt', ':VimwikiToggleListItem<CR>', {noremap = true, silent = true})
    end,
}
