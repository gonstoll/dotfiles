return {
  {'tpope/vim-fugitive', cmd = 'Git'},

  {
    'kdheepak/lazygit.nvim',
    event = 'BufReadPre',
    dependencies = {'nvim-lua/plenary.nvim'},
  },

  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    opts = function()
      local icons = require('utils.icons')

      return {
        signs = {
          add = {text = icons.git.added},
          change = {text = icons.git.changed},
          delete = {text = icons.git.deleted},
          topdelete = {text = icons.git.deleted},
          changedelete = {text = icons.git.changed},
          untracked = {text = icons.git.added},
        },
        current_line_blame = true,
        current_line_blame_opts = {delay = 500},
        preview_config = {
          border = 'rounded',
          title = 'Preview changes',
          title_pos = 'center'
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, {expr = true, desc = 'Next hunk (Gitsigns)'})

          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, {expr = true, desc = 'Previous hunk (Gitsigns)'})

          -- Actions
          map('n', '<leader>hs', gs.stage_hunk, {desc = 'Stage hunk (Gitsigns)'})
          map('n', '<leader>hr', gs.reset_hunk, {desc = 'Reset hunk (Gitsigns)'})
          map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end,
            {desc = 'Stage hunk (Gitsigns)'})
          map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end,
            {desc = 'Reset hunk (Gitsigns)'})
          map('n', '<leader>hS', gs.stage_buffer, {desc = 'Stage buffer (Gitsigns)'})
          map('n', '<leader>hu', gs.undo_stage_hunk, {desc = 'Undo stage hunk (Gitsigns)'})
          map('n', '<leader>hR', gs.reset_buffer, {desc = 'Reset buffer (Gitsigns)'})
          map('n', '<leader>hp', gs.preview_hunk, {desc = 'Preview hunk (Gitsigns)'})
          map('n', '<leader>hb', function() gs.blame_line {full = true} end, {desc = 'Blame line (Gitsigns)'})
          map('n', '<leader>tb', gs.toggle_current_line_blame, {desc = 'Toggle current line blame (Gitsigns)'})
          map('n', '<leader>hd', gs.diffthis, {desc = 'Diff this (Gitsigns)'})
          map('n', '<leader>hD', function() gs.diffthis('~') end, {desc = 'Diff this (Gitsigns)'})
          map('n', '<leader>td', gs.toggle_deleted, {desc = 'Toggle deleted (Gitsigns)'})

          -- Text object
          map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end,
      }
    end,
    config = function(_, opts)
      local gitsigns = require('gitsigns')

      gitsigns.setup(opts)

      local scrollbar_handler = require('scrollbar.handlers.gitsigns')

      scrollbar_handler.setup()
    end
  }
}
