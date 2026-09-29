local M = {}

M.colors = {
  bg = "#17130b",
  fg = "#e7e1dd",
  cursor = "#6cb6c3",
  black = "#251f15",
  red = "#db97ba",
  green = "#6cb6c3",
  yellow = "#9eb370",
  blue = "#afaf63",
  magenta = "#8bb780",
  cyan = "#76b99b",
  white = "#cbc5c2",
  bright_black = "#756c5f",
  bright_red = "#ffc8e2",
  bright_green = "#99e3f0",
  bright_yellow = "#c9e098",
  bright_blue = "#dcdb8a",
  bright_magenta = "#b6e3aa",
  bright_cyan = "#a1e6c6",
  bright_white = "#fbf5f4",
}

function M.load()
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  vim.o.termguicolors = true
  vim.g.colors_name = "palette"
  local c = M.colors
  local hl = vim.api.nvim_set_hl

  hl(0, "Normal", { fg = c.fg, bg = c.bg })
  hl(0, "NormalFloat", { fg = c.fg, bg = c.bg })
  hl(0, "Cursor", { fg = c.bg, bg = c.cursor })
  hl(0, "CursorLine", { bg = c.black })
  hl(0, "CursorLineNr", { fg = c.cursor, bold = true })
  hl(0, "LineNr", { fg = c.bright_black })
  hl(0, "Visual", { fg = c.bg, bg = c.cursor })
  hl(0, "Search", { fg = c.bg, bg = c.yellow })
  hl(0, "IncSearch", { fg = c.bg, bg = c.cursor })
  hl(0, "StatusLine", { fg = c.fg, bg = c.black })
  hl(0, "StatusLineNC", { fg = c.bright_black, bg = c.bg })
  hl(0, "VertSplit", { fg = c.bright_black })
  hl(0, "WinSeparator", { fg = c.bright_black })
  hl(0, "Pmenu", { fg = c.fg, bg = c.black })
  hl(0, "PmenuSel", { fg = c.bg, bg = c.cursor })
  hl(0, "PmenuSbar", { bg = c.black })
  hl(0, "PmenuThumb", { bg = c.bright_black })

  hl(0, "Comment", { fg = c.bright_black, italic = true })
  hl(0, "Constant", { fg = c.yellow })
  hl(0, "String", { fg = c.green })
  hl(0, "Character", { fg = c.green })
  hl(0, "Number", { fg = c.yellow })
  hl(0, "Boolean", { fg = c.yellow })
  hl(0, "Float", { fg = c.yellow })

  hl(0, "Identifier", { fg = c.fg })
  hl(0, "Function", { fg = c.blue, bold = true })
  hl(0, "Statement", { fg = c.magenta, bold = true })
  hl(0, "Conditional", { fg = c.magenta, bold = true })
  hl(0, "Repeat", { fg = c.magenta, bold = true })
  hl(0, "Label", { fg = c.magenta })
  hl(0, "Operator", { fg = c.cyan })
  hl(0, "Keyword", { fg = c.magenta, bold = true })
  hl(0, "Exception", { fg = c.red, bold = true })
  hl(0, "PreProc", { fg = c.cyan })
  hl(0, "Type", { fg = c.yellow })
  hl(0, "Special", { fg = c.blue })
  hl(0, "Underlined", { underline = true })
  hl(0, "Error", { fg = c.red, bg = c.bg })
  hl(0, "Todo", { fg = c.yellow, bg = c.bg, bold = true })

  hl(0, "DiagnosticError", { fg = c.red })
  hl(0, "DiagnosticWarn", { fg = c.yellow })
  hl(0, "DiagnosticInfo", { fg = c.blue })
  hl(0, "DiagnosticHint", { fg = c.cyan })
  hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = c.red })
  hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = c.yellow })
  hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = c.blue })
  hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = c.cyan })

  hl(0, "FloatBorder", { fg = c.bright_black, bg = c.bg })
  hl(0, "FloatTitle", { fg = c.blue, bg = c.bg, bold = true })
  hl(0, "MatchParen", { fg = c.cursor, bold = true, underline = true })

  hl(0, "NeoTreeNormal", { fg = c.fg, bg = c.black })
  hl(0, "NeoTreeNormalNC", { fg = c.fg, bg = c.black })
  hl(0, "NeoTreeEndOfBuffer", { fg = c.black, bg = c.black })
  hl(0, "NeoTreeCursorLine", { bg = c.bg })
  hl(0, "NeoTreeDirectoryIcon", { fg = c.blue })
  hl(0, "NeoTreeDirectoryName", { fg = c.blue, bold = true })
  hl(0, "NeoTreeFileName", { fg = c.fg })
  hl(0, "NeoTreeFileIcon", { fg = c.fg })
  hl(0, "NeoTreeRootName", { fg = c.magenta, bold = true })
  hl(0, "NeoTreeGitAdded", { fg = c.green })
  hl(0, "NeoTreeGitModified", { fg = c.yellow })
  hl(0, "NeoTreeGitDeleted", { fg = c.red })
  hl(0, "NeoTreeGitUntracked", { fg = c.bright_black })
  hl(0, "NeoTreeWinSeparator", { fg = c.bright_black, bg = c.black })

  hl(0, "NvimTreeNormal", { fg = c.fg, bg = c.black })
  hl(0, "NvimTreeNormalNC", { fg = c.fg, bg = c.black })
  hl(0, "NvimTreeEndOfBuffer", { fg = c.black, bg = c.black })
  hl(0, "NvimTreeCursorLine", { bg = c.bg })
  hl(0, "NvimTreeFolderIcon", { fg = c.blue })
  hl(0, "NvimTreeFolderName", { fg = c.blue, bold = true })
  hl(0, "NvimTreeRootFolder", { fg = c.magenta, bold = true })
  hl(0, "NvimTreeGitDirty", { fg = c.yellow })
  hl(0, "NvimTreeGitNew", { fg = c.green })
  hl(0, "NvimTreeGitDeleted", { fg = c.red })

  hl(0, "TelescopeNormal", { fg = c.fg, bg = c.black })
  hl(0, "TelescopeBorder", { fg = c.bright_black, bg = c.black })
  hl(0, "TelescopePromptNormal", { fg = c.fg, bg = c.black })
  hl(0, "TelescopePromptBorder", { fg = c.blue, bg = c.black })
  hl(0, "TelescopePromptPrefix", { fg = c.blue, bg = c.black })
  hl(0, "TelescopeResultsNormal", { fg = c.fg, bg = c.black })
  hl(0, "TelescopeResultsBorder", { fg = c.bright_black, bg = c.black })
  hl(0, "TelescopePreviewNormal", { fg = c.fg, bg = c.black })
  hl(0, "TelescopePreviewBorder", { fg = c.bright_black, bg = c.black })
  hl(0, "TelescopeSelection", { fg = c.fg, bg = c.bright_black })
  hl(0, "TelescopeMatching", { fg = c.yellow, bold = true })

  hl(0, "BufferLineFill", { bg = c.black })
  hl(0, "BufferLineBackground", { fg = c.bright_black, bg = c.black })
  hl(0, "BufferLineBufferSelected", { fg = c.fg, bg = c.bg, bold = true })
  hl(0, "BufferLineBufferVisible", { fg = c.fg, bg = c.black })
  hl(0, "BufferLineSeparator", { fg = c.black, bg = c.black })
  hl(0, "BufferLineSeparatorSelected", { fg = c.black, bg = c.bg })
  hl(0, "BufferLineIndicatorSelected", { fg = c.blue, bg = c.bg })
  hl(0, "BufferLineModified", { fg = c.yellow, bg = c.black })
  hl(0, "BufferLineModifiedSelected", { fg = c.yellow, bg = c.bg })

  hl(0, "GitSignsAdd", { fg = c.green })
  hl(0, "GitSignsChange", { fg = c.yellow })
  hl(0, "GitSignsDelete", { fg = c.red })

  hl(0, "WhichKey", { fg = c.blue })
  hl(0, "WhichKeyGroup", { fg = c.magenta, bold = true })
  hl(0, "WhichKeyDesc", { fg = c.fg })
  hl(0, "WhichKeySeparator", { fg = c.bright_black })
  hl(0, "WhichKeyFloat", { bg = c.black })
  hl(0, "WhichKeyBorder", { fg = c.bright_black, bg = c.black })

  hl(0, "CmpItemAbbr", { fg = c.fg })
  hl(0, "CmpItemAbbrMatch", { fg = c.blue, bold = true })
  hl(0, "CmpItemAbbrMatchFuzzy", { fg = c.blue, bold = true })
  hl(0, "CmpItemKindFunction", { fg = c.blue })
  hl(0, "CmpItemKindMethod", { fg = c.blue })
  hl(0, "CmpItemKindConstructor", { fg = c.yellow })
  hl(0, "CmpItemKindVariable", { fg = c.fg })
  hl(0, "CmpItemKindKeyword", { fg = c.magenta })
  hl(0, "CmpItemKindSnippet", { fg = c.green })

  hl(0, "MiniNotifyNormal", { fg = c.fg, bg = c.black })
  hl(0, "MiniNotifyBorder", { fg = c.bright_black, bg = c.black })
  hl(0, "MiniNotifyTitle", { fg = c.blue, bold = true })

  hl(0, "@variable", { fg = c.fg })
  hl(0, "@variable.builtin", { fg = c.magenta, italic = true })
  hl(0, "@function", { fg = c.blue, bold = true })
  hl(0, "@function.builtin", { fg = c.blue, bold = true })
  hl(0, "@method", { fg = c.blue, bold = true })
  hl(0, "@keyword", { fg = c.magenta, bold = true })
  hl(0, "@keyword.function", { fg = c.magenta, italic = true })
  hl(0, "@keyword.return", { fg = c.magenta, italic = true })
  hl(0, "@string", { fg = c.green })
  hl(0, "@comment", { fg = c.bright_black, italic = true })
  hl(0, "@constant", { fg = c.yellow })
  hl(0, "@constant.builtin", { fg = c.yellow, bold = true })
  hl(0, "@type", { fg = c.yellow })
  hl(0, "@type.builtin", { fg = c.yellow })
  hl(0, "@property", { fg = c.fg })
  hl(0, "@field", { fg = c.fg })
  hl(0, "@constructor", { fg = c.yellow, bold = true })
  hl(0, "@tag", { fg = c.magenta })
  hl(0, "@tag.attribute", { fg = c.yellow })
  hl(0, "@tag.delimiter", { fg = c.bright_black })

  hl(0, "@markup.heading.1", { fg = c.red, bold = true })
  hl(0, "@markup.heading.2", { fg = c.magenta, bold = true })
  hl(0, "@markup.heading.3", { fg = c.yellow, bold = true })
  hl(0, "@markup.heading.4", { fg = c.green, bold = true })
  hl(0, "@markup.heading.5", { fg = c.blue, bold = true })
  hl(0, "@markup.heading.6", { fg = c.cyan, bold = true })
  hl(0, "@markup.strong", { bold = true })
  hl(0, "@markup.italic", { italic = true })
  hl(0, "@markup.strikethrough", { strikethrough = true })
  hl(0, "@markup.underline", { underline = true })
  hl(0, "@markup.link", { fg = c.cyan, underline = true })
  hl(0, "@markup.link.label", { fg = c.blue })
  hl(0, "@markup.link.url", { fg = c.cyan, underline = true })
  hl(0, "@markup.raw", { fg = c.green, bg = c.black })
  hl(0, "@markup.list", { fg = c.magenta })
  hl(0, "@markup.list.checked", { fg = c.green })
  hl(0, "@markup.list.unchecked", { fg = c.bright_black })
end

M.lualine_theme = {
  normal = {
    a = { fg = M.colors.bg, bg = M.colors.blue, gui = "bold" },
    b = { fg = M.colors.fg, bg = M.colors.black },
    c = { fg = M.colors.fg, bg = M.colors.bg },
  },
  insert = {
    a = { fg = M.colors.bg, bg = M.colors.green, gui = "bold" },
    b = { fg = M.colors.fg, bg = M.colors.black },
    c = { fg = M.colors.fg, bg = M.colors.bg },
  },
  visual = {
    a = { fg = M.colors.bg, bg = M.colors.magenta, gui = "bold" },
    b = { fg = M.colors.fg, bg = M.colors.black },
    c = { fg = M.colors.fg, bg = M.colors.bg },
  },
  replace = {
    a = { fg = M.colors.bg, bg = M.colors.red, gui = "bold" },
    b = { fg = M.colors.fg, bg = M.colors.black },
    c = { fg = M.colors.fg, bg = M.colors.bg },
  },
  command = {
    a = { fg = M.colors.bg, bg = M.colors.yellow, gui = "bold" },
    b = { fg = M.colors.fg, bg = M.colors.black },
    c = { fg = M.colors.fg, bg = M.colors.bg },
  },
  inactive = {
    a = { fg = M.colors.bright_black, bg = M.colors.black },
    b = { fg = M.colors.bright_black, bg = M.colors.black },
    c = { fg = M.colors.bright_black, bg = M.colors.bg },
  },
}

return M
