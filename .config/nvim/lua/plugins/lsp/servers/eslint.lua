local desc = Utils.plugin_keymap_desc('eslint')
local M = {}

M.setup = function(capabilities)
  return {
    capabilities = capabilities,
    settings = {
      format = false,
      workingDirectories = {mode = 'auto'}, -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
    },
    flags = os.getenv('DEBOUNCE_ESLINT') and {
      allow_incremental_sync = false,
      debounce_text_changes = 1000,
    } or nil,
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
