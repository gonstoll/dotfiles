return {
  {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = {'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim'}
  },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable('make') == 1
    end,
  },

  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
    dependencies = {'nvim-lua/plenary.nvim'},
    config = function()
      local telescope = require('telescope')
      local builtin = require('telescope.builtin')
      local utils = require('telescope.utils')
      local actions = require('telescope.actions')
      local trouble = require('trouble.providers.telescope')

      local fb_actions = telescope.extensions.file_browser.actions

      local function telescope_buffer_dir()
        return vim.fn.expand('%:p:h')
      end

      vim.cmd('hi TelescopePreviewDirectory guifg=#ea9a97')

      telescope.setup {
        defaults = {
          mappings = {
            i = {
              ['<C-t>'] = trouble.open_with_trouble,
              ['<C-p>'] = actions.move_selection_previous,
            },
            n = {
              ['<C-t>'] = trouble.open_with_trouble,
            },
          },
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
            hidden = true,
            hijack_netrw = true,
            respect_gitignore = false,
            mappings = {
              -- your custom insert mode mappings
              ['i'] = {
                ['<C-w>'] = function() vim.cmd('normal vbd') end,
                ['<C-p>'] = actions.move_selection_previous,
              },
              ['n'] = {
                -- your custom normal mode mappings
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

      vim.keymap.set('n', ';f', function()
        builtin.find_files({
          no_ignore = false,
          hidden = true
        })
      end, {desc = 'Find files respecting gitignore'})

      vim.keymap.set('n', ';;', function()
        builtin.resume()
      end, {desc = 'Resume'})

      vim.keymap.set('n', ';se', function()
        builtin.diagnostics()
      end, {desc = 'Get workspace diagnostics (Telescope)'})

      vim.keymap.set('n', ';e', function()
        builtin.diagnostics({bufnr = 0})
      end, {desc = 'Get file diagnostics (Telescope)'})

      vim.keymap.set('n', ';x', vim.diagnostic.open_float, {desc = 'Line Diagnostics (Telescope)'})

      vim.keymap.set('n', 'sf', function()
        telescope.extensions.file_browser.file_browser({
          path = '%:p:h',
          cwd = telescope_buffer_dir(),
          respect_gitignore = false,
          hidden = true,
          grouped = false,
        })
      end, {desc = '[S]earch [F]iles'})

      vim.keymap.set('n', ';sk', ':Telescope keymaps<CR>', {desc = 'Telescope keymaps'})
      vim.keymap.set('n', ';?', builtin.oldfiles, {desc = 'Find recently opened files'})
      vim.keymap.set('n', ';y', builtin.buffers, {desc = 'Find opened buffers in current neovim instance'})
      vim.keymap.set('n', ';gf', builtin.git_files, {desc = 'Search Git Files'})
      vim.keymap.set('n', ';sf', builtin.find_files, {desc = 'Search Files'})
      vim.keymap.set('n', ';sh', builtin.help_tags, {desc = 'Search Help'})
      vim.keymap.set('n', ';sw', builtin.grep_string, {desc = 'Search current Word'})
      vim.keymap.set('n', ';sg', builtin.live_grep, {desc = 'Search by Grep'})
      vim.keymap.set('n', ';sd', builtin.diagnostics, {desc = 'Search Diagnostics (Telescope)'})
      vim.keymap.set('n', ';sc', builtin.colorscheme, {desc = 'Search Colorscheme'})
      vim.keymap.set('n', ';ss', builtin.search_history, {desc = 'Get list of searches'})
      vim.keymap.set('n', ';/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {})
      end, {desc = '[/] Fuzzily search in current buffer'})
      vim.keymap.set('n', ';cd', function()
        builtin.find_files({cwd = utils.buffer_dir()})
      end, {desc = 'Search in Current buffer Directory'})
    end,
  }
}
