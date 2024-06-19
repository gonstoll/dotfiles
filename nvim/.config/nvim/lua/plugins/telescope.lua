local desc = require('utils').plugin_keymap_desc('telescope')

return {
  {
    'nvim-telescope/telescope-file-browser.nvim',
    lazy = true,
    dependencies = {'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim'},
  },

  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'},
    },
    keys = function()
      local telescope = require('telescope')
      local builtin = require('telescope.builtin')

      return {
        {';?', builtin.oldfiles, desc = desc('Find recently opened files')},
        {';l', builtin.buffers, desc = desc('Find opened buffers in current neovim instance')},
        {';/', builtin.current_buffer_fuzzy_find, desc = desc('Fuzzily search in current buffer')},
        {'gr', builtin.lsp_references, desc = desc('Goto References')},
        {';sl', builtin.live_grep, desc = desc('Search by live grep')},
        {';gf', builtin.git_files, desc = desc('Search Git Files')},
        {';sk', builtin.keymaps, desc = desc('Keymaps')},
        {';sd', builtin.diagnostics, desc = desc('Search Diagnostics')},
        {';sh', builtin.help_tags, desc = desc('Search Help')},
        {';sc', builtin.colorscheme, desc = desc('Search Colorscheme')},
        {';ss', builtin.search_history, desc = desc('Get list of searches')},
        {'<leader>ds', builtin.lsp_document_symbols, desc = desc('Document Symbols')},
        {'<leader>ws', builtin.lsp_dynamic_workspace_symbols, desc = desc('Workspace Symbols')},
        {'sf', function() telescope.extensions.file_browser.file_browser({path = '%:p:h', hidden = true, respect_gitignore = false}) end, desc = desc('Search Files')},
        {';;', function() telescope.extensions.resume.resume() end, desc = desc('Resume')},
        {';f', function() builtin.find_files({no_ignore = true, hidden = true}) end, desc = desc('Find files not respecting gitignore')},
        {';sf', function() builtin.find_files({find_command = {'rg', '--files', '--hidden', '--ignore', '-g', '!.git'}}) end, desc = desc('Search files respecting gitignore')},
        {';cd', function() builtin.find_files({cwd = require('telescope.utils').buffer_dir()}) end, desc = desc('Search in Current buffer Directory')},
        {';sg', function() builtin.grep_string({search = vim.fn.input('Grep > ')}) end, desc = desc('Search by grep')},
        {';sw', function() builtin.grep_string({search = vim.fn.expand('<cword>')}) end, desc = desc('Search word under cursor')},
        {';sW', function() builtin.grep_string({search = vim.fn.expand('<cWORD>')}) end, desc = desc('Search WORD under cursor')},
        {';se', function() builtin.diagnostics({bufnr = 0}) end, desc = desc('Get file diagnostics')},
      }
    end,
    cmd = 'Telescope',
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      local themes = require('telescope.themes')
      local telescopeConfig = require('telescope.config')
      local fb_actions = telescope.extensions.file_browser.actions
      local vimgrep_arguments = {unpack(telescopeConfig.values.vimgrep_arguments)}

      table.insert(vimgrep_arguments, '--hidden')
      table.insert(vimgrep_arguments, '--glob')
      table.insert(vimgrep_arguments, '!**/.git/*')

      telescope.setup({
        defaults = {
          theme = 'center',
          sorting_strategy = 'ascending',
          vimgrep_arguments = vimgrep_arguments,
          layout_config = {
            horizontal = {
              width = 0.9,
              preview_width = 0.4,
            },
          },
        },
        extensions = {
          ['ui-select'] = {themes.get_dropdown()},
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
      })

      -- Enable telescope fzf native, if installed
      telescope.load_extension('fzf')
      telescope.load_extension('file_browser')
    end,
  }
}
