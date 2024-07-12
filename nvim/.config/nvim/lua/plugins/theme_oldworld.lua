return {
    "dgox16/oldworld.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        terminal_colors = true, -- enable terminal colors
        styles = { -- You can pass the style using the format: style = true
            comments = {}, -- style for comments
            keywords = {}, -- style for keywords
            identifiers = {}, -- style for identifiers
            functions = {}, -- style for functions
            variables = {}, -- style for variables
            booleans = {}, -- style for booleans
        },
        integrations = { -- You can disable/enable integrations
            alpha = true,
            cmp = true,
            flash = true,
            gitsigns = true,
            hop = false,
            indent_blankline = true,
            lazy = true,
            lsp = true,
            markdown = true,
            mason = true,
            navic = false,
            neo_tree = false,
            neorg = false,
            noice = true,
            notify = true,
            rainbow_delimiters = true,
            telescope = true,
            treesitter = true,
        },
    },
}
