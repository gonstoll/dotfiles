return {
  {
    'github/copilot.vim',
    config = false,
    event = 'VeryLazy',
    init = function()
      vim.keymap.set('i', '<C-j>', 'copilot#Accept("<CR>")', {
        noremap = true,
        silent = true,
        expr = true,
        replace_keycodes = false
      })

      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
    end,
  },

  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'canary',
    event = 'VeryLazy',
    dependencies = {'github/copilot.vim', 'nvim-lua/plenary.nvim'},
    opts = {
      debug = false,
    },
  },
}
