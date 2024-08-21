return {
    "echasnovski/mini.starter",
	enabled = false,
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "rcarriga/nvim-notify",
    },
    version = false,
    event = "VimEnter",
    opts = function()
        local logo = table.concat({
            [[✨ Let’s write something amazing !]],
            [[                __                ]],
            [[  ___   __  __ /\_\    ___ ___    ]],
            [[/' _ `\/\ \/\ \\/\ \ /' __` __`\  ]],
            [[/\ \/\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
            [[\ \_\ \_\ \___/  \ \_\ \_\ \_\ \_\]],
            [[ \/_/\/_/\/__/    \/_/\/_/\/_/\/_/]],
        }, "\n")
        local pad = string.rep(" ", 1)
        local new_section = function(name, action, section)
            return { name = name, action = action, section = pad .. section }
        end

        local starter = require("mini.starter")
        local config = {
            evaluate_single = true,
            header = logo,
            items = {
                new_section("Find file", LazyVim.pick(), "Telescope"),
                new_section(
                    "Recent files",
                    LazyVim.pick("oldfiles"),
                    "Telescope"
                ),
                new_section(
                    "Grep in project",
                    LazyVim.pick("live_grep"),
                    "Telescope"
                ),
                new_section("Config", LazyVim.pick.config_files(), "Config"),
                new_section("Quit", "qa", "Built-in"),
            },
            content_hooks = {
                starter.gen_hook.adding_bullet(pad .. "░ ", false),
                starter.gen_hook.aligning("center", "center"),
            },
        }
        return config
    end,
    config = function(_, config)
        if vim.o.filetype == "lazy" then
            vim.cmd.close()
            vim.api.nvim_create_autocmd("User", {
                pattern = "MiniStarterOpened",
                callback = function()
                    require("lazy").show()
                end,
            })
        end

        local starter = require("mini.starter")
        starter.setup(config)

        vim.api.nvim_create_autocmd("User", {
            pattern = "LazyVimStarted",
            callback = function(ev)
                local stats = require("lazy").stats()
                local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                local pad_footer = string.rep(" ", 8)
                starter.config.footer = pad_footer
                    .. "⚡ Neovim loaded "
                    .. stats.count
                    .. " plugins in "
                    .. ms
                    .. "ms"
                -- INFO: based on @echasnovski's recommendation (thanks a lot!!!)
                if vim.bo[ev.buf].filetype == "starter" then
                    pcall(starter.refresh)
                end
            end,
        })
    end,
}
