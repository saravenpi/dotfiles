return {
    "lilyinstarlight/vim-sonic-pi",
    config = function()
        vim.g.sonic_pi_command = "sonic-pi-tool.py"
        vim.g.sonic_pi_check = "version"
        vim.g.sonic_pi_eval = "eval-stdin"
        vim.g.sonic_pi_stop = "stop"
    end,
    keys = {
        { "<leader>r", "<cmd>SonicPiEval<cr>", desc = "Evaluate selection", mode = "v" },
        { "<leader>spr", ":SonicPiEval<cr>", desc = "Evaluate file", mode = "n" },
        { "<leader>sps", ":SonicPiStop<cr>", desc = "Stop", mode = "n" },
        { "<leader>spc", ":SonicPiCheck<cr>", desc = "Check", mode = "n" },
        { "<leader>spl", ":SonicPiStartServer<cr>", desc = "Start server", mode = "n" },
    },
}
