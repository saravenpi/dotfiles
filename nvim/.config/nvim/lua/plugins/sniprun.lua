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
                "Terminal",
                "VirtualTextOk",
            },
        })
    end,
    keys = {
        {
            "<leader>oir",
            ":'<,'>SnipRun<CR>",
            mode = { "v" },
            desc = "sniprun run",
        },
        {
            "<leader>oir",
            ":SnipRun<CR>",
            mode = { "n" },
            desc = "sniprun run",
        },
        {
            "<leader>oic",
            ":SnipClose<CR>",
            mode = { "n" },
            desc = "sniprun close",
        },
    },
}
