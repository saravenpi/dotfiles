return {
    "nvim-neorg/neorg",
    ft = "norg",
    build = ":Neorg sync-parsers",
    init = function()
        vim.o.conceallevel = 2
        vim.opt.concealcursor = "nc"
    end,
    opts = {
        load = {
            ["core.defaults"] = {},
            ["core.concealer"] = {
                config = {
                    folds = true,
                    icon_preset = "varied",
                    icons = {
                        delimiter = {
                            horizontal_line = {
                                highlight = "@neorg.delimiters.horizontal_line",
                            },
                        },
                        code_block = {
                            -- If true will only dim the content of the code block (without the
                            -- `@code` and `@end` lines), not the entirety of the code block itself.
                            content_only = true,

                            -- The width to use for code block backgrounds.
                            --
                            -- When set to `fullwidth` (the default), will create a background
                            -- that spans the width of the buffer.
                            --
                            -- When set to `content`, will only span as far as the longest line
                            -- within the code block.
                            width = "content",

                            -- Additional padding to apply to either the left or the right. Making
                            -- these values negative is considered undefined behaviour (it is
                            -- likely to work, but it's not officially supported).
                            padding = {
                                -- left = 20,
                                -- right = 20,
                            },

                            -- If `true` will conceal (hide) the `@code` and `@end` portion of the code
                            -- block.
                            conceal = true,

                            nodes = { "ranged_verbatim_tag" },
                            highlight = "CursorLine",
                            -- render = module.public.icon_renderers.render_code_block,
                            insert_enabled = true,
                        },
                    },
                },
            },
            ["core.integrations.nvim-cmp"] = {},
            ["core.integrations.treesitter"] = {},
            ["core.completion"] = {
                config = { engine = "nvim-cmp" },
            },
            -- ['core.export'] = {},
            ["core.highlights"] = {},
            -- ['core.autocommands'] = {},
            ["core.summary"] = {},
            ["core.dirman"] = {
                config = {
                    workspaces = {
                        notes = "~/notes",
                    },
                    index = "index.norg",
                },
            },
        },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
        {
            "<leader>nn",
            "<Plug>(neorg.dirman.new-note)",
            desc = "Create new neorg note",
        },
        {
            "<C-t>",
            "<Plug>(neorg.qol.todo-items.todo.task-cycle)",
            desc = "Toggles neorg todo item",
        },
        {
            "<C-t>",
            "<Plug>(neorg.qol.todo-items.todo.task-cycle)",
            desc = "Toggles neorg todo item",
        },
        {
            "<leader>njo",
            ":Neorg journal toc update<CR>:Neorg journal toc open<CR>",
            desc = "Opens neorg journal toc",
        },
        {
            "<leader>nju",
            ":Neorg journal toc update<CR>",
            desc = "Updates neorg journal toc",
        },
        {
            "<leader>njt",
            ":Neorg journal today<CR>",
            desc = "Opens today's neorg journal entry",
        },
        {
            "<leader>njy",
            ":Neorg journal yesterday<CR>",
            desc = "Opens yesterday's neorg journal entry",
        },
        {
            "<leader>ni",
            ":Neorg index<CR>",
            desc = "Opens neorg index",
        },
        {
            "<leader>nt",
            ":Neorg toc<CR>",
            desc = "Opens toc",
        },
    },
}
