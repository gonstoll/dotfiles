local desc = require('utils').plugin_keymap_desc('snacks')

return {
  'folke/snacks.nvim',
  opts = {
    bigfile = {enabled = true},
    quickfile = {enabled = true},
    gitbrowse = {enabled = true},
    dashboard = {enabled = false},
    notifier = {enabled = false},
    statuscolumn = {enabled = false},
    words = {enabled = false},
  },
  keys = function()
    local snacks = require('snacks')
    return {
      {
        '<leader>.',
        function()
          vim.ui.input({
            prompt = 'Enter filetype for the scratch buffer: ',
            default = 'markdown',
          }, function(ft)
            snacks.scratch.open({
              ft = ft,
              name = os.date('%Y-%m-%d-%H-%M-%S'),
              win = {
                width = 150,
                height = 40,
                border = 'single',
                title = 'Scratch Buffer',
              },
            })
          end)
        end,
        desc = desc('Open a scratch buffer'),
      },
      {
        '<leader>S',
        -- function() snacks.scratch.select() end,
        function() require('utils.snacks').select() end,
        desc = desc('Select a scratch buffer'),
      },
      {
        '<leader>cR',
        function() snacks.rename.rename_file() end,
        desc = desc('Rename File'),
      },
      {
        '<leader>gy',
        function() snacks.gitbrowse() end,
        desc = desc('Open line(s) in browser'),
        mode = {'n', 'v'},
      },
      {
        '<leader>gY',
        function()
          snacks.gitbrowse.open({
            open = function(url)
              vim.fn.setreg('+', url)
              vim.notify('Yanked url to clipboard')
            end,
          })
        end,
        desc = desc('Copy line(s) link'),
        mode = {'n', 'v'},
      },
    }
  end,
}
