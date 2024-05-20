local vim_test_desc = require('utils').plugin_keymap_desc('vim test')
local neotest_desc = require('utils').plugin_keymap_desc('neotest')

return {
  {
    'vim-test/vim-test',
    keys = {
      {'<leader>TN', '<cmd>TestNearest<cr>', desc = vim_test_desc('Run nearest test')},
      {'<leader>TF', '<cmd>TestFile<cr>', desc = vim_test_desc('Run all tests in file')},
      {'<leader>TS', '<cmd>TestSuite<cr>', desc = vim_test_desc('Run all tests in suite')},
      {'<leader>TL', '<cmd>TestLast<cr>', desc = vim_test_desc('Run last test')},
      {'<leader>TV', '<cmd>TestVisit<cr>', desc = vim_test_desc('Visit test file')},
    },
  },

  {
    'nvim-neotest/neotest',
    dependencies = {'nvim-neotest/nvim-nio', 'nvim-neotest/neotest-jest'},
    keys = {
      {'<leader>Tt', function() require('neotest').run.run(vim.fn.expand('%')) end, desc = neotest_desc('Run File')},
      {'<leader>TT', function() require('neotest').run.run(vim.uv.cwd()) end, desc = neotest_desc('Run All Test Files')},
      {'<leader>Tr', function() require('neotest').run.run() end, desc = neotest_desc('Run Nearest')},
      {'<leader>Tl', function() require('neotest').run.run_last() end, desc = neotest_desc('Run Last')},
      {'<leader>Ts', function() require('neotest').summary.toggle() end, desc = neotest_desc('Toggle Summary')},
      {'<leader>To', function() require('neotest').output.open({enter = true, auto_close = true}) end, desc = neotest_desc('Show Output')},
      {'<leader>TO', function() require('neotest').output_panel.toggle() end, desc = neotest_desc('Toggle Output Panel')},
      {'<leader>TS', function() require('neotest').run.stop() end, desc = neotest_desc('Stop')},
    },
    opts = {
      status = {virtual_text = true},
      output = {open_on_run = true},
    },
    config = function(_, opts)
      local adapters = {
        require('neotest-jest')({
          jestCommand = 'npm test --',
          jestConfigFile = 'custom.jest.config.ts',
          env = {CI = true},
          cwd = function(path) return vim.fn.getcwd() end,
        }),
        require('neotest-vitest')({
          filter_dir = function(name, rel_path, root)
            return name ~= 'node_modules'
          end,
        }),
      }
      table.insert(opts, adapters)
      require('neotest').setup(opts)
    end
  },
}
