-- ============================================================================
-- Vis Editor Configuration
-- Minimal, elegant port of Neovim setup with native Vis capabilities
-- Maintained in ~/.dotfiles/vis/.config/vis/visrc.lua
-- ============================================================================

-- Load standard vis module (provides core Lua API and default plugins)
require("vis")

-- 1. Plugins
require("plugins/palette")
require("plugins/commentary")
require("plugins/surround")
require("plugins/autopairs")

-- 2. Core Configurations
require("config/options").setup()
require("config/fzf").setup()
require("config/explorer").setup()
require("config/statusline").setup()
require("config/keymaps").setup()
