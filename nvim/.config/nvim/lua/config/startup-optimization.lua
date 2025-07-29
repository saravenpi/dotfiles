-- Startup optimization settings
-- Load early to improve performance in large directories

-- Record startup time
vim.g.start_time = vim.fn.reltime()

-- Defer loading of expensive operations
vim.defer_fn(function()
	-- Only enable expensive features after startup, but not on dashboard
	if vim.bo.filetype ~= "alpha" then
		vim.opt.cursorline = true
		vim.opt.relativenumber = true
	end
end, 100)

-- Optimize file operations
vim.opt.updatetime = 300  -- Faster CursorHold events
vim.opt.timeoutlen = 500  -- Faster key sequence timeout
vim.opt.redrawtime = 1500 -- Limit syntax highlighting time

-- Disable expensive features for large files
vim.api.nvim_create_autocmd("BufReadPre", {
	callback = function()
		local file_size = vim.fn.getfsize(vim.fn.expand("%"))
		if file_size > 1024 * 1024 then -- 1MB
			vim.opt_local.syntax = "off"
			vim.opt_local.swapfile = false
			vim.opt_local.undofile = false
		end
	end
})

-- Skip certain directories entirely
local skip_dirs = {
	"node_modules",
	".git",
	"target",
	"build",
	"dist",
	".next",
	"vendor"
}

for _, dir in ipairs(skip_dirs) do
	vim.opt.wildignore:append("*/" .. dir .. "/*")
end