return {
  {'tpope/vim-fugitive', cmd = 'Git'},

  {
    'FabijanZulj/blame.nvim',
    cmd = 'BlameToggle',
    opts = {
      mappings = {
        commit_info = 'K',
      },
    },
  },

  {
    'kdheepak/lazygit.nvim',
    cmd = {'LazyGit', 'LazyGitConfig', 'LazyGitCurrentFile', 'LazyGitFilter', 'LazyGitFilterCurrentFile'},
    dependencies = {'nvim-lua/plenary.nvim'},
    keys = {
      {'<leader>gg', '<cmd>LazyGit<CR>', desc = 'LazyGit: Open'},
    },
  },

  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    opts = function()
      local desc = Utils.plugin_keymap_desc('gitsigns')

      return {
        signs = {
          add = {text = Utils.icons.git.added},
          change = {text = Utils.icons.git.changed},
          delete = {text = Utils.icons.git.deleted},
          topdelete = {text = Utils.icons.git.deleted},
          changedelete = {text = Utils.icons.git.changed},
          untracked = {text = Utils.icons.git.added},
        },
        current_line_blame = true,
        current_line_blame_opts = {delay = 500},
        preview_config = {
          border = 'single',
          title = 'Preview changes',
          title_pos = 'center',
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
            vim.schedule(function()
              gs.next_hunk()
              vim.cmd('normal! zz')
            end)
            return '<Ignore>'
          end, {expr = true, desc = desc('Next hunk')})

          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function()
              gs.prev_hunk()
              vim.cmd('normal! zz')
            end)
            return '<Ignore>'
          end, {expr = true, desc = desc('Previous hunk')})

          -- Actions
          map('n', '<leader>gs', gs.stage_hunk, {desc = desc('Stage hunk')})
          map('n', '<leader>gr', gs.reset_hunk, {desc = desc('Reset hunk')})
          map('v', '<leader>gs', function()
            gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')}
          end, {desc = desc('Stage hunk')})
          map('v', '<leader>gr', function()
            gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')}
          end, {desc = desc('Reset hunk')})
          -- map('n', '<leader>hS', gs.stage_buffer, {desc = desc('Stage buffer')})
          -- map('n', '<leader>hu', gs.undo_stage_hunk, {desc = desc('Undo stage hunk')})
          -- map('n', '<leader>hR', gs.reset_buffer, {desc = desc('Reset buffer')})
          map('n', '<leader>gp', gs.preview_hunk, {desc = desc('Preview hunk')})
          map('n', '<leader>gb', function() gs.blame_line {full = true} end, {desc = desc('Blame line')})
          -- map('n', '<leader>tb', gs.toggle_current_line_blame, {desc = desc('Toggle current line blame')})
          -- map('n', '<leader>hd', gs.diffthis, {desc = desc('Diff this')})
          -- map('n', '<leader>hD', function() gs.diffthis('~') end, {desc = desc('Diff this')})
          -- map('n', '<leader>td', gs.toggle_deleted, {desc = desc('Toggle deleted')})

          -- Text object
          map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end,
      }
    end,
  },
}
