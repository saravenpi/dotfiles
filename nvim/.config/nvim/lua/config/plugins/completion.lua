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
				}
				vim_item.kind = string.format("%s %s", icons[entry.source.name] or "•", vim_item.kind)
				vim_item.menu = string.format("[%s]", entry.source.name)
				return vim_item
			end,
		},
		mapping = cmp.mapping.preset.insert({
			["<C-Space>"] = cmp.mapping.complete(),
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
			{ name = "buffer" },
			{ name = "path" },
		}),
	})

	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	require("mason").setup()

	local mason_servers = {
		"lua_ls",
		"biome",
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
		automatic_installation = false -- Prevent auto-install delays
	})

	-- Lazy load LSP servers only for relevant filetypes
	local lspconfig = require("lspconfig")
	local server_filetypes = {
		lua_ls = {"lua"},
		biome = {"javascript", "typescript", "json", "jsonc"},
		ts_ls = {"javascript", "typescript", "tsx", "jsx"},
		tsserver = {"javascript", "typescript", "tsx", "jsx"},
		tinymist = {"typst"},
		emmet_language_server = {"html", "css", "scss", "sass"},
		svelte = {"svelte"},
		elixirls = {"elixir", "eex", "heex"},
		html = {"html"},
		cssls = {"css", "scss", "sass"},
		jsonls = {"json", "jsonc"},
		yamlls = {"yaml", "yml"},
		sqls = {"sql"},
		bashls = {"sh", "bash", "zsh"}
	}
	
	for _, server in ipairs(mason_servers) do
		local filetypes = server_filetypes[server]
		if filetypes then
			vim.api.nvim_create_autocmd("FileType", {
				pattern = filetypes,
				callback = function()
					lspconfig[server].setup({ 
						capabilities = capabilities,
						root_dir = lspconfig.util.find_git_ancestor or lspconfig.util.root_pattern("package.json", ".git")
					})
				end,
				once = true
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
			map("n", "<leader>ca", vim.lsp.buf.code_action)
		end,
	})

	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			typescript = { "biome", "prettierd", "prettier" },
			javascript = { "biome", "prettierd", "prettier" },
			json = { "biome", "prettierd", "prettier" },
			jsonc = { "biome", "prettierd", "prettier" },
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
