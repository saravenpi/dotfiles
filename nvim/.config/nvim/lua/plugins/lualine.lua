return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, "😄")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local function wordCount()
        local word_count = vim.fn.wordcount().words
        return "✍️  words: " .. word_count
      end
      local function wordGoal()
        local word_count = vim.fn.wordcount().words
        local goal = 6000
        local percentage = word_count / goal
        local rounded = math.floor(percentage * 100)
        return "🎉 goal: " .. rounded .. "/100"
      end
      local function gato()
        return "🐈"
      end

      return {
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = { left = "", right = "|" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "diagnostics", { gato } },
          lualine_c = { "filename" },
          lualine_x = { "filetype" },
          lualine_y = { "searchcount" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      }
    end,
  },
}
