require("notify").setup({
  stages = "fade",
  on_open = nil,
  on_close = nil,
  render = "default",
  timeout = 2000,
  max_width = nil,
  max_height = nil,
  background_colour = "#000000",
  minimum_width = 50,
  icons = {
    ERROR = "",
    WARN = "",
    INFO = "",
    DEBUG = "",
    TRACE = "✎",
  },
})
