return {
	{ url = "https://github.com/mason-org/mason.nvim", config = function()
		require("mason").setup()
	end },
	{ url = "https://github.com/mason-org/mason-lspconfig.nvim", dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" }, config = function()
		local mason_servers = { "lua_ls", "ts_ls", "svelte", "html", "cssls", "jsonls", "bashls" }

		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		local server_settings = {
			lua_ls = {
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
					},
				},
			},
		}

		for _, server in ipairs(mason_servers) do
			vim.lsp.config(server, vim.tbl_deep_extend("force", {
				capabilities = capabilities,
			}, server_settings[server] or {}))
		end

		require("mason-lspconfig").setup({
			ensure_installed = mason_servers,
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(ev)
				local buf = ev.buf
				local map = function(mode, lhs, rhs)
					vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true })
				end
				map("n", "gd", vim.lsp.buf.definition)
				map("n", "K", vim.lsp.buf.hover)
				map("n", "<leader>rn", vim.lsp.buf.rename)
			end,
		})
	end },
	{ url = "https://github.com/neovim/nvim-lspconfig" },
	{ url = "https://github.com/hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-path", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" }, config = function()
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
						nvim_lsp = "🔧",
						luasnip = "📝",
						buffer = "📄",
						path = "📁",
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
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "pebble", priority = 100 },
				{ name = "buffer" },
				{ name = "path" },
			}),
		})
	end },
	{ url = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ url = "https://github.com/hrsh7th/cmp-path" },
	{ url = "https://github.com/L3MON4D3/LuaSnip" },
	{ url = "https://github.com/saadparwaiz1/cmp_luasnip" },
	{ url = "https://github.com/stevearc/conform.nvim", config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				sh = { "shfmt" },
				svelte = { "prettier" },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				json = { "prettierd" },
			},
			formatters = {
				prettier = {
					command = function()
						local local_bin = vim.fs.joinpath(vim.uv.cwd(), "node_modules", ".bin", "prettier")
						return vim.uv.fs_stat(local_bin) and local_bin or "prettier"
					end,
					args = { "--stdin-filepath", "$FILENAME" },
				},
			},
		})
	end },
}