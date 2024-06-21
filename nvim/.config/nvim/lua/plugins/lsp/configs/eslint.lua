local desc = require('utils').plugin_keymap_desc('eslint')
local M = {}

M.setup = function(capabilities, on_attach)
  return {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {format = false},
    keys = {
      {
        '<leader>ef',
        ':EslintFixAll<CR>',
        desc = desc('Fix all'),
      },
    },
  }
end

return M
