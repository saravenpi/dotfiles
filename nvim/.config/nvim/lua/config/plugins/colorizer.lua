local M = {}

M.specs = {
    { src = "https://github.com/catgoose/nvim-colorizer.lua" },
}

M.setup = function()
    require("colorizer").setup({
        filetypes = { "*" },
        buftypes = {},
        user_commands = true,
        lazy_load = false,
        options = {
            parsers = {
                css = true,
                css_fn = true,
                names = {
                    enable = false,
                    lowercase = true,
                    camelcase = true,
                },
                hex = {
                    default = true,
                },
                rgb = { enable = true },
                hsl = { enable = true },
                oklch = { enable = false },
                tailwind = {
                    enable = true,
                    lsp = false,
                    update_names = false,
                },
                sass = {
                    enable = true,
                    parsers = { css = true },
                },
                xterm = { enable = true },
            },
            display = {
                mode = "background",
                background = {
                    bright_fg = "#000000",
                    dark_fg = "#ffffff",
                },
                virtualtext = {
                    char = "■",
                    position = "eol",
                    hl_mode = "foreground",
                },
                priority = {
                    default = 150,
                    lsp = 200,
                },
            },
            hooks = {
                should_highlight_line = false,
            },
            always_update = false,
        },
    })
end

return M

