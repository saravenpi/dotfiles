return {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    disable = true,
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        workspaces = {
            {
                name = "brain",
                path = "~/brain",
            },
        },
    },
    keys = {
        { "<leader>of", ":ObsidianFollowLink<cr>", desc = "Obsidian follow link", mode = "n" },
    },
}
