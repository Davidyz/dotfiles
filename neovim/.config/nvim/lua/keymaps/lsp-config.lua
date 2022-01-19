require('keymaps.utils')

local nvim_lsp = require('lspconfig')
local servers = {'pyright'}

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = require('keymaps.utils').Lsp_on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
