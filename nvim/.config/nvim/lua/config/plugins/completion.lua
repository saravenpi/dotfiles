local M = {}

M.specs = {
	-- LSP
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/williamboman/mason.nvim" },
	{ src = "https://github.com/williamboman/mason-lspconfig.nvim" },

	-- Completion
	{ src = "https://github.com/hrsh7th/nvim-cmp" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/saadparwaiz1/cmp_luasnip" },

	-- AI assistance
	{ src = "https://github.com/zbirenbaum/copilot.lua" },
	{ src = "https://github.com/zbirenbaum/copilot-cmp" },

	-- Formatting
	{ src = "https://github.com/stevearc/conform.nvim" },
}

M.setup = function()
	-- Disable LSP logging to prevent startup warnings
	vim.lsp.set_log_level("off")
	
	require("copilot").setup({ suggestion = { enabled = false }, panel = { enabled = false } })
	require("copilot_cmp").setup()

	local cmp = require("cmp")
	local luasnip = require("luasnip")

	cmp.setup({
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		formatting = {
			format = function(entry, vim_item)
				local icons = {
					copilot = "🤖",
					nvim_lsp = "🔧",
					luasnip = "📝",
					buffer = "📄",
					path = "📁",
					pebble_wiki_links = "🔗",
					pebble_markdown_links = "📎",
					pebble_tags = "🏷️",
					pebble = "🪨",
				}
				vim_item.kind = string.format("%s %s", icons[entry.source.name] or "•", vim_item.kind)
				vim_item.menu = string.format("[%s]", entry.source.name)
				return vim_item
			end,
		},
		mapping = cmp.mapping.preset.insert({
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end, { "i", "s" }),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
		}),
		sources = cmp.config.sources({
			{ name = "copilot" },
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
			{ name = "pebble", priority = 100 },
			{ name = "buffer" },
			{ name = "path" },
		})
	})

	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	require("mason").setup()

	local mason_servers = {
		"lua_ls",
		"tinymist",
		"emmet_language_server",
		"svelte",
		"elixirls",
		"html",
		"cssls",
		"jsonls",
		"yamlls",
		"sqls",
		"bashls",
	}

	local ts_entry = require("lspconfig").ts_ls and "ts_ls" or "tsserver"
	table.insert(mason_servers, ts_entry)

	require("mason-lspconfig").setup({
		ensure_installed = mason_servers,
		automatic_installation = false, -- Prevent auto-install delays
	})

	-- Lazy load LSP servers only for relevant filetypes
	local lspconfig = require("lspconfig")
	local server_filetypes = {
		lua_ls = { "lua" },
		ts_ls = { "javascript", "typescript", "tsx", "jsx" },
		tsserver = { "javascript", "typescript", "tsx", "jsx" },
		tinymist = { "typst" },
		emmet_language_server = { "html", "css", "scss", "sass" },
		svelte = { "svelte" },
		elixirls = { "elixir", "eex", "heex" },
		html = { "html" },
		cssls = { "css", "scss", "sass" },
		jsonls = { "json", "jsonc" },
		yamlls = { "yaml", "yml" },
		sqls = { "sql" },
		bashls = { "sh", "bash", "zsh" },
	}

	for _, server in ipairs(mason_servers) do
		local filetypes = server_filetypes[server]
		if filetypes then
			vim.api.nvim_create_autocmd("FileType", {
				pattern = filetypes,
				callback = function()
					lspconfig[server].setup({
						capabilities = capabilities,
						root_dir = lspconfig.util.find_git_ancestor
							or lspconfig.util.root_pattern("package.json", ".git"),
					})
				end,
				once = true,
			})
		else
			lspconfig[server].setup({ capabilities = capabilities })
		end
	end

	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(ev)
			local buf = ev.buf
			local map = function(mode, lhs, rhs)
				vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true })
			end
			map("n", "gd", vim.lsp.buf.definition)
			map("n", "gr", vim.lsp.buf.references)
			map("n", "gi", vim.lsp.buf.implementation)
			map("n", "K", vim.lsp.buf.hover)
			map("n", "<leader>rn", vim.lsp.buf.rename)
		end,
	})

	vim.lsp.handlers["textDocument/codeAction"] = vim.lsp.with(function(err, actions, context)
		if not actions or #actions == 0 then
			vim.notify("No code actions available", vim.log.levels.INFO)
			return
		end

		local items = {}
		for i, action in ipairs(actions) do
			items[i] = string.format("%d: %s", i, action.title)
		end

		local lines = vim.api.nvim_get_option("lines")
		local columns = vim.api.nvim_get_option("columns")
		local height = math.min(#items + 2, math.floor(lines * 0.8))
		local width = math.min(60, math.floor(columns * 0.8))
		local row = math.floor((lines - height) / 2)
		local col = math.floor((columns - width) / 2)

		local buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, items)

		local win = vim.api.nvim_open_win(buf, true, {
			relative = "editor",
			width = width,
			height = height,
			row = row,
			col = col,
			style = "minimal",
			border = "rounded",
			title = " Code Actions ",
			title_pos = "center",
		})

		vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", "", {
			callback = function()
				local line = vim.api.nvim_win_get_cursor(win)[1]
				local action = actions[line]
				if action then
					if action.edit then
						vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
					elseif action.command then
						vim.lsp.buf.execute_command(action.command)
					end
				end
				vim.api.nvim_win_close(win, true)
			end,
			noremap = true,
			silent = true,
		})

		vim.api.nvim_buf_set_keymap(buf, "n", "q", "", {
			callback = function()
				vim.api.nvim_win_close(win, true)
			end,
			noremap = true,
			silent = true,
		})

		vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "", {
			callback = function()
				vim.api.nvim_win_close(win, true)
			end,
			noremap = true,
			silent = true,
		})

		for i = 1, #actions do
			vim.api.nvim_buf_set_keymap(buf, "n", tostring(i), "", {
				callback = function()
					local action = actions[i]
					if action then
						if action.edit then
							vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
						elseif action.command then
							vim.lsp.buf.execute_command(action.command)
						end
					end
					vim.api.nvim_win_close(win, true)
				end,
				noremap = true,
				silent = true,
			})
		end
	end, {})

	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			typescript = { "prettierd", "prettier" },
			javascript = { "prettierd", "prettier" },
			json = { "prettierd", "prettier" },
			jsonc = { "prettierd", "prettier" },
			yaml = { "prettierd", "prettier" },
			svelte = { "prettierd", "prettier" },
			elixir = { "mix" },
			sql = { "pg_format", "sql-formatter" },
			["*"] = { "trim_whitespace" },
		},
		format_on_save = {
			timeout_ms = 800,
			lsp_format = "fallback",
		},
	})
end

return M
