return {
    {
        "folke/trouble.nvim",
        opts = { use_diagnostic_signs = true },
    },
    { "folke/trouble.nvim", enabled = true },
    {
        "simrat39/symbols-outline.nvim",
        cmd = "SymbolsOutline",
        keys = {
            {
                "<leader>cs",
                "<cmd>SymbolsOutline<cr>",
                desc = "Symbols Outline",
            },
        },
        config = true,
    },
}
