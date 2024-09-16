return {
    {
        "zbirenbaum/copilot.lua",
        disable = false,
        config = function()
            require("copilot").setup({
                suggestion = { enabled = true },
                panel = { enabled = true },
            })
        end,
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "canary",
        opts = {
            show_help = "yes",
            debug = false,
            disable_extra_info = "no",
            language = "English",
        },
        build = function()
            vim.notify(
                "Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim."
            )
        end,
        event = "VeryLazy",
        keys = {
            {
                "<leader>aa",
                ":CopilotChat ",
                desc = "CopilotChat - Chat",
            },

            {
                "<leader>ab",
                ":CopilotChatBuffer ",
                desc = "CopilotChat - Chat with current buffer",
            },
            {
                "<leader>ae",
                "<cmd>CopilotChatExplain<cr>",
                desc = "CopilotChat - Explain code",
            },
            {
                "<leader>at",
                "<cmd>CopilotChatTests<cr>",
                desc = "CopilotChat - Generate tests",
            },
            {
                "<leader>at",
                "<cmd>CopilotChatVsplitToggle<cr>",
                desc = "CopilotChat - Toggle Vsplit", -- Toggle vertical split
            },
            {
                "<leader>av",
                ":CopilotChatVisual ",
                mode = "x",
                desc = "CopilotChat - Open in vertical split",
            },
            {
                "<leader>ax",
                ":CopilotChatInPlace<cr>",
                mode = "x",
                desc = "CopilotChat - Run in-place code",
            },
            {
                "<leader>af",
                "<cmd>CopilotChatFixDiagnostic<cr>", -- Get a fix for the diagnostic message under the cursor.
                desc = "CopilotChat - Fix diagnostic",
            },
            {
                "<leader>ar",
                "<cmd>CopilotChatReset<cr>", -- Reset chat history and clear buffer.
                desc = "CopilotChat - Reset chat history and clear buffer",
            },
        },
    },
    {
        disable = false,
        "zbirenbaum/copilot-cmp",
        config = function()
            require("copilot_cmp").setup()
        end,
    },
}
