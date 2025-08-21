vim.keymap.set("n", "<leader>w", ":write<CR>")
vim.keymap.set("n", "<leader>qq", ":quit<CR>")

vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v", "x" }, "<leader>d", '"+d')

vim.api.nvim_set_keymap("n", "<leader>pu", ":lua vim.pack.update()<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>f", "<cmd>Telescope find_files<CR>")
vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope find_files<CR>")
vim.keymap.set("n", "<leader>/", "<cmd>Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>h", "<cmd>Telescope help_tags<CR>")
vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<CR>")
vim.keymap.set("n", "<leader>r", "<cmd>Telescope oldfiles<CR>")
vim.keymap.set("n", "<leader>e", ":Neotree toggle reveal<CR>", { desc = "Toggle Neotree and focus current file" })

-- Formatting (Conform)
vim.keymap.set("n", "<leader>cf", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })

-- LSP (Language Server Protocol) keymaps
vim.keymap.set("n", "<leader>cr", function()
	return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true })
vim.keymap.set({ "n", "x" }, "<leader>ca", function()
	require("tiny-code-action").code_action()
end, { noremap = true, silent = true })

-- Git UI (Neogit)
vim.keymap.set("n", "<leader>gn", function()
	require("neogit").open({ kind = "tab" })
end, { desc = "Open Neogit" })

-- Trouble (diagnostics list)
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Trouble Diagnostics" })
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", { desc = "Trouble Quickfix" })
-- Custom function to toggle diagnostic float focus
local function toggle_diagnostic_float()
	local float_wins = {}
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local config = vim.api.nvim_win_get_config(win)
		if config.relative ~= "" then
			table.insert(float_wins, win)
		end
	end

	-- If there are floating windows, try to focus the first one
	if #float_wins > 0 then
		vim.api.nvim_set_current_win(float_wins[1])
	else
		-- No floating window exists, open diagnostic float
		vim.diagnostic.open_float()
	end
end

vim.keymap.set("n", "<leader>cd", toggle_diagnostic_float, { desc = "Show/focus diagnostic details" })

-- Diagnostic navigation and display
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "<leader>cl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
vim.keymap.set("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

-- TODO comments list
vim.keymap.set("n", "<leader>xt", "<cmd>TodoTrouble<CR>", { desc = "Todo list (Trouble)" })

-- Overseer (task runner)
vim.keymap.set("n", "<leader>ot", "<cmd>OverseerToggle<CR>", { desc = "Toggle task list" })
vim.keymap.set("n", "<leader>or", "<cmd>OverseerRun<CR>", { desc = "Run task" })
vim.keymap.set("n", "<leader>oq", "<cmd>OverseerQuickAction<CR>", { desc = "Close Overseer" })

-- Navbuddy (LSP symbol navigator)
vim.keymap.set("n", "<leader>cn", function()
	require("nvim-navbuddy").open()
end, { desc = "Open Navbuddy" })

-- Flash (jump/search)
vim.keymap.set({ "n", "x", "o" }, "s", function()
	require("flash").jump()
end, { desc = "Flash jump" })
vim.keymap.set({ "n", "o", "x" }, "S", function()
	require("flash").treesitter()
end, { desc = "Flash TS" })

-- Noice (notifications)
vim.keymap.set("n", "<leader>n", "<cmd>Noice<CR>", { desc = "Open Noice" })

-- Bufferline (tabs)
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous tab" })
vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineTogglePin<CR>", { desc = "Pin tab" })
vim.keymap.set("n", "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Delete non-pinned tabs" })
vim.keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { desc = "Delete other tabs" })
vim.keymap.set("n", "<leader>br", "<cmd>BufferLineCloseRight<CR>", { desc = "Delete tabs to the right" })
vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineCloseLeft<CR>", { desc = "Delete tabs to the left" })
vim.keymap.set("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close current tab" })
vim.keymap.set("n", "]b", "<cmd>BufferLineCycleNext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "[b", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous tab" })
vim.keymap.set("n", "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>", { desc = "Go to tab 1" })
vim.keymap.set("n", "<leader>2", "<cmd>BufferLineGoToBuffer 2<CR>", { desc = "Go to tab 2" })
vim.keymap.set("n", "<leader>3", "<cmd>BufferLineGoToBuffer 3<CR>", { desc = "Go to tab 3" })
vim.keymap.set("n", "<leader>4", "<cmd>BufferLineGoToBuffer 4<CR>", { desc = "Go to tab 4" })
vim.keymap.set("n", "<leader>5", "<cmd>BufferLineGoToBuffer 5<CR>", { desc = "Go to tab 5" })
vim.keymap.set("n", "<leader>6", "<cmd>BufferLineGoToBuffer 6<CR>", { desc = "Go to tab 6" })
vim.keymap.set("n", "<leader>7", "<cmd>BufferLineGoToBuffer 7<CR>", { desc = "Go to tab 7" })
vim.keymap.set("n", "<leader>8", "<cmd>BufferLineGoToBuffer 8<CR>", { desc = "Go to tab 8" })
vim.keymap.set("n", "<leader>9", "<cmd>BufferLineGoToBuffer 9<CR>", { desc = "Go to tab 9" })
vim.keymap.set("n", "<leader>$", "<cmd>BufferLineGoToBuffer -1<CR>", { desc = "Go to last tab" })

-- Avante AI
vim.keymap.set("n", "<leader>aa", function()
	require("avante.api").ask()
end, { desc = "Avante: Ask" })
vim.keymap.set("v", "<leader>aa", function()
	require("avante.api").ask()
end, { desc = "Avante: Ask" })
vim.keymap.set("n", "<leader>ar", function()
	require("avante.api").refresh()
end, { desc = "Avante: Refresh" })
vim.keymap.set("n", "<leader>ae", function()
	require("avante.api").edit()
end, { desc = "Avante: Edit" })
vim.keymap.set("v", "<leader>ae", function()
	require("avante.api").edit()
end, { desc = "Avante: Edit" })
vim.keymap.set("n", "<leader>at", "<cmd>AvanteToggle<CR>", { desc = "Avante: Toggle" })
vim.keymap.set("n", "<leader>af", "<cmd>AvanteFocus<CR>", { desc = "Avante: Focus" })
vim.keymap.set("n", "<leader>ac", "<cmd>AvanteChat<CR>", { desc = "Avante: Chat" })
vim.keymap.set("n", "<leader>as", "<cmd>AvanteSwitchProvider<CR>", { desc = "Avante: Switch Provider" })
