return {
    "stevearc/overseer.nvim",
    opts = {},
    init = function()
        require("overseer").setup()
    end,
    keys = {
        {
            "<leader>ot",
            ":lua vim.cmd('OverseerToggle')<CR>",
            mode = { "n" },
            desc = "overseer toggle",
        },
        {
            "<leader>or",
            '<CR>:lua vim.cmd("OverseerRun")<CR>',
            mode = { "n" },
            desc = "overseer run",
        },
        {
            "<leader>oc",
            '<CR>:lua vim.cmd("OverseerRunCmd")<CR>',
            mode = { "n" },
            desc = "overseer run cmd",
        },
        {
            "<leader>oq",
            '<CR>:lua vim.cmd("OverseerQuickAction")<CR>',
            mode = { "n" },
            desc = "overseer quick action",
        },
        {
            "<leader>os",
            '<CR>:lua vim.cmd("OverseerSaveBundle")<CR>',
            mode = { "n" },
            desc = "overseer save bundle",
        },
        {
            "<leader>ol",
            '<CR>:lua vim.cmd("OverseerLoadBundle")<CR>',
            mode = { "n" },
            desc = "overseer load bundle",
        },
    },
}
