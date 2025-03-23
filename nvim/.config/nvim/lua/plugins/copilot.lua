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
        opts = {

            panel = {
                enabled = true,
                auto_refresh = true,
            },
            suggestions = {
                auto_trigger = true,
            },
        },
    },
}
