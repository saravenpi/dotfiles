require("obsidian").setup({
  dir = "~/brain",
  completion = {
    nvim_cmp = true,
  },
  daily_notes = {
    folder = "dailies",
  }
})

require("nvim-treesitter.configs").setup({
  ensure_installed = { "markdown", "markdown_inline" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "markdown" },
  },
})

vim.keymap.set(
  "n",
  "gf",
  function()
    if require('obsidian').util.cursor_on_markdown_link() then
      return "<cmd>ObsidianFollowLink<CR>"
    else
      return "gf"
    end
  end,
  { noremap = false, expr = true}
)

vim.keymap.set(
  "n",
  "<CR>",
  function()
    if require('obsidian').util.cursor_on_markdown_link() then
      return "<cmd>ObsidianFollowLink<CR>"
    else
      return "gf"
    end
  end,
  { noremap = false, expr = true}
)
