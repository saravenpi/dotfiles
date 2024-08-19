require("config.lazy")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
require("lspconfig").clangd.setup({
    capabilities = cmp_nvim_lsp.default_capabilities(),
    cmd = {
        "clangd",
        "--offset-encoding=utf-16",
    },
})

if vim.g.neovide then
    vim.o.guifont = "FiraCode Nerd Font Mono:h14" -- text below applies for VimScript
    vim.g.neovide_transparency = 0.8
    vim.g.neovide_window_blurred = false
    vim.g.neovide_cursor_vfx_mode = "railgun"
end
