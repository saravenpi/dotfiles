return {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
        "giuxtaposition/blink-cmp-copilot",
        "Kaiser-Yang/blink-cmp-avante",
        {
            "L3MON4D3/LuaSnip",
            version = "v2.*",
        },
        "moyiz/blink-emoji.nvim",
        "bydlw98/blink-cmp-env",
    },
    opts = {
        sources = {
            default = {
                "copilot",
                "avante",
                "lsp",
                "path",
                "snippets",
                "buffer",
            },
            providers = {
                copilot = {
                    name = "copilot",
                    module = "blink-cmp-copilot",
                    kind = "Copilot",
                    score_offset = 100,
                    async = true,
                },
                avante = {
                    module = "blink-cmp-avante",
                    name = "Avante",
                    opts = {
                        -- options for blink-cmp-avante
                    },
                },
                emoji = {
                    module = "blink-emoji",
                    name = "Emoji",
                    score_offset = 15,
                    opts = { insert = true },
                },
                env = {
                    name = "Env",
                    module = "blink-cmp-env",
                    opts = {
                        item_kind = require("blink.cmp.types").CompletionItemKind.Variable,
                        show_braces = false,
                        show_documentation_window = true,
                    },
                },
            },
        },
        snippets = { preset = "luasnip" },
    },
}
