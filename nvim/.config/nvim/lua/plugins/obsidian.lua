return {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        workspaces = {
            {
                name = "brain",
                path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/brain",
            },
        },
        ui = {
            enable = true,
        },
        -- other fields ...

        templates = {
            folder = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/brain/Templates",
            date_format = "%Y-%m-%d-%a",
            time_format = "%H:%M",
        },
    },
}
