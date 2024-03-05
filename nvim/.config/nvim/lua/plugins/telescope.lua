return {
    "telescope.nvim",
    dependencies = {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
            require("telescope").load_extension("fzf")
        end,
        keys = {
            {
                "<leader>fg",
                ":Telescope live_grep<cr>",
                desc = "Find in files",
            },
        },
    },
}
