return {
    "rcarriga/nvim-notify",
    enabled = false,
    config = function()
        require("notify").setup({
            background_colour = "#000000",
        })
    end,
}
