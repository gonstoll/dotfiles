local desc = Utils.plugin_keymap_desc('eslint')
local M = {}

M.setup = function(capabilities)
  return {
    capabilities = capabilities,
    settings = {
      format = false,
      run = 'onSave',
      -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
      workingDirectories = {mode = 'auto'},
    },
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
