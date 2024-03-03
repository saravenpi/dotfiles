require("config.lazy")
local cmp_nvim_lsp = require "cmp_nvim_lsp"
    require("lspconfig").clangd.setup {
      capabilities = cmp_nvim_lsp.default_capabilities(),
      cmd = {
        "clangd",
        "--offset-encoding=utf-16",
      },
    }
