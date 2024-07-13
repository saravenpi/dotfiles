return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-emoji",
            "L3MON4D3/LuaSnip",
            "onsails/lspkind.nvim",
        },
        ---@param opts cmp.ConfigSchema
        opts = function(_, opts)
            local luasnip = require("luasnip")
            local cmp = require("cmp")
            local lspkind = require("lspkind")

            lspkind.init({
                symbol_map = {
                    Copilot = "",
                },
            })
            table.insert(opts.sources, {
                name = "emoji",
                name = "copilot",
            })
            vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#82aaff" })

            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api
                            .nvim_buf_get_lines(0, line - 1, line, true)[1]
                            :sub(col, col)
                            :match("%s")
                        == nil
            end

            opts.window = {
                completion = cmp.config.window.bordered(),
            }
            opts.mapping = vim.tbl_extend("force", opts.mapping, {
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            })
        end,
    },
}
