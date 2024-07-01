local lspconfig = require('plugins.lsp.lspconfig')

return {
  lspconfig.setup(),
  {'onsails/lspkind-nvim', config = false},
}
