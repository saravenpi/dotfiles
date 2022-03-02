local nvim_lsp = require('lspconfig')
vim.notify = require("notify")


-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)



-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
function on_attach(client, bufnr)-- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end



local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}



local servers = {'tsserver', 'pyright', 'gopls', 'rust_analyzer', 'solargraph', 'omnisharp'}
for _, lsp in ipairs(servers) do
  if lsp == 'omnisharp' then
    -- omnisharp lsp config
    nvim_lsp[lsp].setup {
      capabilities =  capabilities,
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        vim.notify(lsp .. " lsp loaded successfully" , "info", { timeout = 2500 })
      end,
      cmd = { "/home/saravenpi/omnisharp/OmniSharp", "--languageserver" , "--hostPID", tostring(pid) }
      }
  else 
    nvim_lsp[lsp].setup {
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        vim.notify(lsp .. " lsp loaded successfully" , "info", { timeout = 2500 })
      end,
      capabilities = capabilities
      }
  end
end




require("trouble").setup {
  position = "bottom", -- position of the list can be: bottom, top, left, right
  height = 10, -- height of the trouble list when position is top or bottom
  width = 25, -- width of the list when position is left or right
  icons = true, -- use devicons for filenames
  mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
  fold_open = "", -- icon used for open folds
  fold_closed = "", -- icon used for closed folds
  group = true, -- group results by file
  padding = true, -- add an extra new line on top of the list
  action_keys = { -- key mappings for actions in the trouble list
  -- map to {} to remove a mapping, for example:
  -- close = {},
  close = "q", -- close the list
  cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
  refresh = "r", -- manually refresh
  jump = {"<cr>", "<tab>"}, -- jump to the diagnostic or open / close folds
  open_split = { "<c-x>" }, -- open buffer in new split
  open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
  open_tab = { "<c-t>" }, -- open buffer in new tab
  jump_close = {"o"}, -- jump to the diagnostic and close the list
  toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
  toggle_preview = "P", -- toggle auto_preview
  hover = "K", -- opens a small popup with the full multiline message
  preview = "p", -- preview the diagnostic location
  close_folds = {"zM", "zm"}, -- close all folds
  open_folds = {"zR", "zr"}, -- open all folds
  toggle_fold = {"zA", "za"}, -- toggle fold of current file
  previous = "k", -- preview item
  next = "j" -- next item
  },
indent_lines = true, -- add an indent guide below the fold icons
auto_open = false, -- automatically open the list when you have diagnostics
auto_close = false, -- automatically close the list when you have no diagnostics
auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
auto_fold = false, -- automatically fold a file trouble list at creation
auto_jump = {"lsp_definitions"}, -- for the given modes, automatically jump if there is only a single result
signs = {
  -- icons / text used for a diagnostic
  error = "",
  warning = "",
  hint = "",
  information = "",
  other = "﫠"
  },
use_diagnostic_signs = true -- enabling this will use the signs defined in your lsp client
}
