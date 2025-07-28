require("config.options")
require("config.keymaps")

local plugins = require("config.plugins")
vim.pack.add(plugins.get_specs())

plugins.setup_all()
