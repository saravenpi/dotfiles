return {
    "michaelb/sniprun",
    branch = "master",

    build = "sh install.sh",

    config = function()
        require("sniprun").setup({
            interpreter_options = {
                C_original = {
                    compiler = "clang",
                },
            },
            display = {
                "Classic",
                "VirtualTextOk",
            },
        })
    end,
    keys = {
        {
            "<leader>osr",
            ":'<,'>SnipRun<CR>",
            mode = { "v" },
            desc = "sniprun",
        },
        {
            "<leader>osr",
            ":SnipRun<CR>",
            mode = { "n" },
            desc = "sniprun",
        },
        {
            "<leader>osc",
            ":SnipClose<CR>",
            mode = { "n" },
            desc = "sniprun",
        },
    },
}
