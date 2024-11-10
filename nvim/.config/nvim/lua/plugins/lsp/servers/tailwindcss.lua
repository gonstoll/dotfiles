local M = {}

M.setup = function(capabilities)
  local lspconfig = require('lspconfig')
  local roots = {'tailwind.config.js', 'tailwind.config.ts'}

  return {
    capabilities = capabilities,
    root_dir = lspconfig.util.root_pattern(table.concat(roots, ', ')),
  }
end

return M
