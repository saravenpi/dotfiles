local M = {}

M.specs = {
	{ src = "https://github.com/williamboman/mason.nvim" },
	{ src = "https://github.com/williamboman/mason-lspconfig.nvim" },
	{ src = "https://github.com/hrsh7th/nvim-cmp" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/saadparwaiz1/cmp_luasnip" },
	{ src = "https://github.com/stevearc/conform.nvim" },
}

M.setup = function()
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
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
			{ name = "pebble", priority = 100 },
			{ name = "buffer" },
			{ name = "path" },
		}),
	})

	require("mason").setup()
	local mason_servers = { "lua_ls", "ts_ls", "svelte", "html", "cssls", "jsonls" }
	require("mason-lspconfig").setup({ ensure_installed = mason_servers })

	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	for _, server in ipairs(mason_servers) do
		vim.lsp.config[server] = {
			capabilities = capabilities,
			settings = (server == "lua_ls") and { Lua = { diagnostics = { globals = { "vim" } } } } or nil,
		}
		vim.lsp.enable(server)
	end

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

	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
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
end

return M
