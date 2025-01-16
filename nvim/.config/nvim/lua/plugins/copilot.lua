return {

    {
        "zbirenbaum/copilot.lua",
        opts = function()
            LazyVim.cmp.actions.ai_accept = function()
                if require("copilot.suggestion").is_visible() then
                    LazyVim.create_undo()
                    require("copilot.suggestion").accept()
                    return true
                end
            end
        end,
    },
    {
        "saghen/blink.cmp",
        optional = true,
        dependencies = { "giuxtaposition/blink-cmp-copilot" },
        opts = {
            sources = {
                default = { "copilot" },
                providers = {
                    copilot = {
                        name = "copilot",
                        module = "blink-cmp-copilot",
                        kind = "Copilot",
                        score_offset = 100,
                        async = true,
                    },
                },
            },
        },
    },
    {
        "saghen/blink.cmp",
        dependencies = {
            {
                "giuxtaposition/blink-cmp-copilot",
            },
        },
        opts = {
            sources = {
                default = { "lsp", "path", "snippets", "buffer", "copilot" },
                providers = {
                    copilot = {
                        name = "copilot",
                        module = "blink-cmp-copilot",
                        score_offset = 100,
                        async = true,
                    },
                },
            },
        },
    },
    {
        "hrsh7th/nvim-cmp",
        optional = false,
        dependencies = { -- this will only be evaluated if nvim-cmp is enabled
            {
                "zbirenbaum/copilot-cmp",
                opts = {},
                config = function(_, opts)
                    local copilot_cmp = require("copilot_cmp")
                    copilot_cmp.setup(opts)
                    -- attach cmp source whenever copilot attaches
                    -- fixes lazy-loading issues with the copilot cmp source
                    LazyVim.lsp.on_attach(function()
                        copilot_cmp._on_insert_enter({})
                    end, "copilot")
                end,
                specs = {
                    {
                        "hrsh7th/nvim-cmp",
                        optional = true,
                        opts = function(_, opts)
                            table.insert(opts.sources, 1, {
                                name = "copilot",
                                group_index = 1,
                                priority = 100,
                            })
                        end,
                    },
                },
            },
        },
    },
}
