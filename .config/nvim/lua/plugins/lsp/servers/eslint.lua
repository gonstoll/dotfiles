local desc = Utils.plugin_keymap_desc('eslint')
local M = {}

M.setup = function(capabilities)
  return {
    capabilities = capabilities,
    settings = {
      format = false,
      -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
      workingDirectories = {mode = 'auto'},
    },
    flags = {
      allow_incremental_sync = false,
      debounce_text_changes = 1000,
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
