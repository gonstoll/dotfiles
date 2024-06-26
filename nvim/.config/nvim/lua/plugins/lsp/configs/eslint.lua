local desc = require('utils').plugin_keymap_desc('eslint')
local M = {}

M.setup = function(capabilities)
  return {
    capabilities = capabilities,
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
