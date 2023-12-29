local desc = require('utils').pluginKeymapDescriptor('telescope')

local keys = {
  {
    desc = desc('Search Files'),
    lhs = 'sf',
    rhs = function() require('telescope').extensions.file_browser.file_browser({path = '%:p:h', hidden = true, respect_gitignore = false,}) end,
  },
  {
    desc = desc('Find files respecting gitignore'),
    lhs = ';f',
    rhs = function() require('telescope.builtin').find_files({no_ignore = true, hidden = true}) end,
  },
  {
    desc = desc('Get file diagnostics'),
    lhs = ';se',
    rhs = function() require('telescope.builtin').diagnostics({bufnr = 0}) end,
  },
  {
    desc = desc('Search in Current buffer Directory'),
    lhs = ';cd',
    rhs = function() require('telescope.builtin').find_files({cwd = require('telescope.utils').buffer_dir()}) end,
  },
  {
    desc = desc('Search Files'),
    lhs = ';sf',
    rhs = function() require('telescope.builtin').find_files() end,
  },
  {
    desc = desc('Search by Grep'),
    lhs = ';sg',
    rhs = function() require('telescope.builtin').live_grep() end,
  },
  {
    desc = desc('Search Git Files'),
    lhs = ';gf',
    rhs = function() require('telescope.builtin').git_files() end,
  },
  {
    desc = desc('Keymaps'),
    lhs = ';sk',
    rhs = function() require('telescope.builtin').keymaps() end,
  },
  {
    desc = desc('Search Diagnostics'),
    lhs = ';sd',
    rhs = function() require('telescope.builtin').diagnostics() end,
  },
  {
    desc = desc('Search current Word'),
    lhs = ';sw',
    rhs = function() require('telescope.builtin').grep_string() end,
  },
  {
    desc = desc('Find recently opened files'),
    lhs = ';?',
    rhs = function() require('telescope.builtin').oldfiles() end,
  },
  {
    desc = desc('Find opened buffers in current neovim instance'),
    lhs = ';y',
    rhs = function() require('telescope.builtin').buffers() end,
  },
  {
    desc = desc('Search Help'),
    lhs = ';sh',
    rhs = function() require('telescope.builtin').help_tags() end,
  },
  {
    desc = desc('Search Colorscheme'),
    lhs = ';sc',
    rhs = function() require('telescope.builtin').colorscheme() end,
  },
  {
    desc = desc('Get list of searches'),
    lhs = ';ss',
    rhs = function() require('telescope.builtin').search_history() end,
  },
  {
    desc = desc('Fuzzily search in current buffer'),
    lhs = ';/',
    rhs = function() require('telescope.builtin').current_buffer_fuzzy_find() end,
  },
  {
    desc = desc('Resume'),
    lhs = ';;',
    rhs = function() require('telescope').extensions.resume.resume() end,
  },
  {
    desc = desc('Document Symbols'),
    lhs = '<leader>ds',
    rhs = function() require('telescope.builtin').lsp_document_symbols() end,
  },
  {
    desc = desc('Workspace Symbols'),
    lhs = '<leader>ws',
    rhs = function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end,
  },
  {
    desc = desc('Goto References'),
    lhs = 'gr',
    rhs = function() require('telescope.builtin').lsp_references() end,
  },
}

local function get_lazy_keys()
  local lazy_keys = {}
  for _, key in ipairs(keys) do
    table.insert(lazy_keys, {key.lhs, key.rhs, desc = key.desc})
  end
  return lazy_keys
end

return {
  {
    'nvim-telescope/telescope-file-browser.nvim',
    lazy = true,
    dependencies = {'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim'},
  },

  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'},
    },
    keys = get_lazy_keys(),
    cmd = 'Telescope',
    config = function()
      local telescope = require('telescope')
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
            hijack_netrw = false,
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

      for _, key in ipairs(keys) do
        vim.keymap.set('n', key.lhs, key.rhs, {desc = key.desc})
      end
    end,
  }
}
