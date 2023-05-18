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
      return "<cmd>ObsidianLinkNew<CR>"
  end,
  { noremap = false, expr = true}
)
