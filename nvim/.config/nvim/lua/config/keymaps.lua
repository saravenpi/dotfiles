vim.keymap.set("n", "<leader>w", ":write<CR>")
vim.keymap.set("n", "<leader>qq", ":quit<CR>")

vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v", "x" }, "<leader>d", '"+d')

vim.keymap.set("n", "<leader>f", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader><leader>", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>/", ":Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>h", ":Pick help<CR>")
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>")

-- Formatting (Conform)
vim.keymap.set("n", "<leader>cf", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })

-- Git UI (Neogit)
vim.keymap.set("n", "<leader>gn", function()
	require("neogit").open({ kind = "tab" })
end, { desc = "Open Neogit" })

-- Trouble (diagnostics list)
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Trouble Diagnostics" })
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", { desc = "Trouble Quickfix" })

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
