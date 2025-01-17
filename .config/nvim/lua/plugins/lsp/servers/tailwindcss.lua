local lspconfig = require('lspconfig')
local roots = {'tailwind.config.js', 'tailwind.config.ts'}

return {
  root_dir = lspconfig.util.root_pattern(table.concat(roots, ', ')),
}
