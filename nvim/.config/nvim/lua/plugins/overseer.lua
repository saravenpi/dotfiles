return {
    "stevearc/overseer.nvim",
    opts = {},
    keys = {
        {
            "<leader>ot",
            ":OverseerToggle<CR>",
            mode = { "n" },
            desc = "overseer toggle",
        },
        {
            "<leader>or",
            ':OverseerRun<CR>',
            mode = { "n" },
            desc = "overseer run",
        },
        {
            "<leader>oc",
            ':OverseerRunCmd<CR>',
            mode = { "n" },
            desc = "overseer run cmd",
        },
        {
            "<leader>oq",
            ':OverseerQuickAction<CR>',
            mode = { "n" },
            desc = "overseer quick action",
        },
        {
            "<leader>os",
            ':OverseerSaveBundle<CR>',
            mode = { "n" },
            desc = "overseer save bundle",
        },
        {
            "<leader>ol",
            ':OverseerLoadBundle<CR>',
            mode = { "n" },
            desc = "overseer load bundle",
        },
    },
}
