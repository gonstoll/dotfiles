local keys = {
  {
    desc = 'Search Files',
    lhs = 'sf',
    rhs =
    '<cmd>lua require("telescope").extensions.file_browser.file_browser({path = "%:p:h", hidden = true, respect_gitignore = false,})<CR>',
  },
  {
    desc = 'Find files respecting gitignore',
    lhs = ';f',
    rhs = '<cmd>lua require("telescope.builtin").find_files({no_ignore = true, hidden = true})<CR>',
  },
  {
    desc = 'Get file diagnostics',
    lhs = ';se',
    rhs = '<cmd>lua require("telescope.builtin").diagnostics({bufnr = 0})<CR>',
  },
  {
    desc = 'Search in Current buffer Directory',
    lhs = ';cd',
    rhs = '<cmd>lua require("telescope.builtin").find_files({cwd = require("telescope.utils").buffer_dir()})<CR>',
  },
  {
    desc = 'Search Files',
    lhs = ';sf',
    rhs = '<cmd>lua require("telescope.builtin").find_files()<CR>',
  },
  {
    desc = 'Search by Grep',
    lhs = ';sg',
    rhs = '<cmd>lua require("telescope.builtin").live_grep()<CR>',
  },
  {
    desc = 'Search Git Files',
    lhs = ';gf',
    rhs = '<cmd>lua require("telescope.builtin").git_files()<CR>',
  },
  {
    desc = 'Keymaps',
    lhs = ';sk',
    rhs = '<cmd>lua require("telescope.builtin").keymaps()<CR>',
  },
  {
    desc = 'Search Diagnostics',
    lhs = ';sd',
    rhs = '<cmd>lua require("telescope.builtin").diagnostics()<CR>',
  },
  {
    desc = 'Search current Word',
    lhs = ';sw',
    rhs = '<cmd>lua require("telescope.builtin").grep_string()<CR>',
  },
  {
    desc = 'Find recently opened files',
    lhs = ';?',
    rhs = '<cmd>lua require("telescope.builtin").oldfiles()<CR>',
  },
  {
    desc = 'Find opened buffers in current neovim instance',
    lhs = ';y',
    rhs = '<cmd>lua require("telescope.builtin").buffers()<CR>',
  },
  {
    desc = 'Search Help',
    lhs = ';sh',
    rhs = '<cmd>lua require("telescope.builtin").help_tags()<CR>',
  },
  {
    desc = 'Search Colorscheme',
    lhs = ';sc',
    rhs = '<cmd>lua require("telescope.builtin").colorscheme()<CR>',
  },
  {
    desc = 'Get list of searches',
    lhs = ';ss',
    rhs = '<cmd>lua require("telescope.builtin").search_history()<CR>',
  },
  {
    desc = 'Fuzzily search in current buffer',
    lhs = ';/',
    rhs = '<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<CR>',
  },
  {
    desc = 'Resume',
    lhs = ';;',
    rhs = '<cmd>lua require("telescope").extensions.resume.resume()<CR>',
  },
  {
    desc = 'Document Symbols',
    lhs = '<leader>ds',
    rhs = '<cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>',
  },
  {
    desc = 'Workspace Symbols',
    lhs = '<leader>ws',
    rhs = '<cmd>lua require("telescope.builtin").lsp_dynamic_workspace_symbols()<CR>',
  },
  {
    desc = 'Goto References',
    lhs = 'gr',
    rhs = '<cmd>lua require("telescope.builtin").lsp_references()<CR>',
  },
}

local function get_desc(description)
  return description .. ' (Telescope)'
end

local function get_lazy_keys()
  local lazy_keys = {}
  for _, key in ipairs(keys) do
    local desc = get_desc(key.desc)
    table.insert(lazy_keys, {key.lhs, key.rhs, desc = desc})
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
        vim.keymap.set('n', key.lhs, key.rhs, {desc = get_desc(key.desc)})
      end
    end,
  }
}
