return {
    "stevearc/overseer.nvim",
    opts = {},
    init = function()
        require("overseer").setup()
    end,
    keys = {
        {
            "<leader>ot",
            ":OverseerToggle<CR>",
            mode = { "n" },
            desc = "overseer",
        },
{
            "<leader>or",
            ":OverseerRun<CR>",
            mode = { "n" },
            desc = "overseer",
        },
    },
}
