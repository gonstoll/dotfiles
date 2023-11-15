return {
  {
    'nvim-telescope/telescope-file-browser.nvim',
    event = 'BufReadPre',
    dependencies = {'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim'},
  },

  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'},
    },
    event = 'BufReadPre',
    config = function()
      local telescope = require('telescope')
      local builtin = require('telescope.builtin')
      local utils = require('telescope.utils')
      local actions = require('telescope.actions')

      local fb_actions = telescope.extensions.file_browser.actions

      telescope.setup {
        defaults = {
          theme = 'center',
          sorting_strategy = 'ascending',
          layout_config = {
            horizontal = {
              width = 0.9,
              preview_width = 0.4,
            },
          },
        },
        extensions = {
          file_browser = {
            hijack_netrw = true,
            mappings = {
              ['i'] = {
                ['<C-p>'] = actions.move_selection_previous,
              },
              ['n'] = {
                ['C'] = fb_actions.create,
                ['R'] = fb_actions.rename,
                ['h'] = fb_actions.goto_parent_dir,
              },
            },
          },
        },
      }

      -- Enable telescope fzf native, if installed
      telescope.load_extension('fzf')
      telescope.load_extension('file_browser')

      vim.keymap.set('n', 'sf', function()
        telescope.extensions.file_browser.file_browser({
          path = '%:p:h',
          hidden = true,
        })
      end, {desc = '[S]earch [F]iles (Telescope file browser)'})

      local function telescope_keymap(map, command, desc)
        local description = desc .. ' (Telescope)'
        vim.keymap.set('n', map, command, {desc = description})
      end

      telescope_keymap(';f', function()
        builtin.find_files({
          no_ignore = true,
          hidden = true
        })
      end, 'Find files respecting gitignore')

      telescope_keymap(';se', function()
        builtin.diagnostics({bufnr = 0})
      end, 'Get file diagnostics')

      telescope_keymap(';cd', function()
        builtin.find_files({cwd = utils.buffer_dir()})
      end, 'Search in Current buffer Directory')

      telescope_keymap(';sf', builtin.find_files, 'Search Files')
      telescope_keymap(';sg', builtin.live_grep, 'Search by Grep')
      telescope_keymap(';gf', builtin.git_files, 'Search Git Files')
      telescope_keymap(';sk', ':Telescope keymaps<CR>', 'Keymaps')
      telescope_keymap(';sd', builtin.diagnostics, 'Search Diagnostics')
      telescope_keymap(';sw', builtin.grep_string, 'Search current Word')
      telescope_keymap(';?', builtin.oldfiles, 'Find recently opened files')
      telescope_keymap(';y', builtin.buffers, 'Find opened buffers in current neovim instance')
      telescope_keymap(';sh', builtin.help_tags, 'Search Help')
      telescope_keymap(';sc', builtin.colorscheme, 'Search Colorscheme')
      telescope_keymap(';ss', builtin.search_history, 'Get list of searches')
      telescope_keymap(';/', builtin.current_buffer_fuzzy_find, 'Fuzzily search in current buffer')
      telescope_keymap(';;', builtin.resume, 'Resume')
    end,
  }
}
