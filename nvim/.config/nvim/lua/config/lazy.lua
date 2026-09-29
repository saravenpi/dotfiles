-- Bootstrap lazy.nvim and configure the plugin manager.
-- This module is required first from init.lua so that lazy is available
-- before any plugin config runs.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Set the leader before loading lazy so that plugin keymaps are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
	spec = {
		{ import = "config.plugins" },
	},
	-- Don't notify on every startup that a plugin is up to date.
	checker = { enabled = true, notify = false },
	-- Don't prompt to update when a plugin has an update on startup.
	change_detection = { notify = false },
})