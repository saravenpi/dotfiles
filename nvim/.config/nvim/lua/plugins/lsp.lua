return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "jose-elias-alvarez/typescript.nvim",
            init = function()
                require("lazyvim.util").lsp.on_attach(function(_, buffer)
                    vim.keymap.set(
                        "n",
                        "<leader>co",
                        "TypescriptOrganizeImports",
                        {
                            buffer = buffer,
                            desc = "Organize Imports",
                        }
                    )
                    vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", {
                        desc = "Rename File",
                        buffer = buffer,
                    })
                end)
            end,
        },
        opts = {},
        keys = {
            {
                "<leader>gd",
                ":lua vim.lsp.buf.definition()<CR>",
                desc = "Go to definition",
            },
        },
    },
}
