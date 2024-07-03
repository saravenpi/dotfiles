return {
    version = "v0.0.1",
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
        "nvim-telescope/telescope.nvim",
    },
    keys = {
        {
            "<leader>gn",
            ":Neogit<CR>",
            desc = "Neogit - Open",
        },
    },
    config = function()
        require("neogit").setup({})
    end,
}
