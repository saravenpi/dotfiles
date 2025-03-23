return {
    {
        "AndreM222/copilot-lualine",
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function(_, opts)
            table.insert(opts.sections.lualine_x, "😄")
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function()
            local function gato()
                return "🐈"
            end

            return {
                options = {
                    icons_enabled = true,
                    theme = "auto",
                    component_separators = { left = "", right = "|" },
                    -- section_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = {
                        statusline = {},
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    globalstatus = false,
                    refresh = {
                        statusline = 1000,
                        tabline = 1000,
                        winbar = 1000,
                    },
                },
                sections = {
                    lualine_a = {
                        {
                            "mode",
                            -- separator = { left = "" },
                            -- right_padding = 2,
                        },
                    },
                    lualine_b = { "diagnostics", { gato }, "branch" },
                    lualine_c = { "filename" },
                    lualine_x = {
                        {
                            "copilot",
                            -- Default values
                            symbols = {
                                status = {
                                    icons = {
                                        enabled = " ",
                                        sleep = " ", -- auto-trigger disabled
                                        disabled = " ",
                                        warning = " ",
                                        unknown = " ",
                                    },
                                    hl = {
                                        enabled = "#50FA7B",
                                        sleep = "#AEB7D0",
                                        disabled = "#6272A4",
                                        warning = "#FFB86C",
                                        unknown = "#FF5555",
                                    },
                                },
                                spinners = "dots", -- has some premade spinners
                                spinner_color = "#6272A4",
                            },
                            show_colors = true,
                            show_loading = true,
                        },
                        "filetype",
                    },
                    lualine_y = { "searchcount", "selectioncount" },
                    lualine_z = {
                        "location",
                        "diff",
                        -- separator = { right = "" },
                        -- left_padding = 2,
                    },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {},
            }
        end,
    },
}
