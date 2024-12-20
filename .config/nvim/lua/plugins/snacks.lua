local desc = Utils.plugin_keymap_desc('snacks')

local function get_root()
  local path = os.getenv('HOME') .. '/notes/scratch'
  if not vim.fn.isdirectory(path) then
    vim.fn.mkdir(path, 'p')
  end
  return path
end

return {
  'folke/snacks.nvim',
  lazy = false,
  opts = {
    bigfile = {enabled = true},
    quickfile = {enabled = true},
    gitbrowse = {enabled = true},
    dashboard = {enabled = false},
    notifier = {enabled = false},
    statuscolumn = {enabled = false},
    words = {enabled = false},
    scratch = {
      root = get_root(),
      win = {width = 150, height = 40, border = 'single'},
    },
  },
  keys = function()
    local snacks = require('snacks')
    return {
      {
        '<leader>.',
        function()
          vim.ui.input({
            prompt = 'Enter scratch buffer title: ',
            default = '',
          }, function(t)
            local title = t ~= '' and t:gsub('%s+', '_') or 'Untitled'
            snacks.scratch.open({
              ft = 'markdown',
              name = title .. '_' .. os.date('%Y-%m-%d-%H-%M-%S'),
              win = {
                title = title,
              },
            })
          end)
        end,
        desc = desc('Open a scratch buffer'),
      },
      {
        '<leader>S',
        -- function() snacks.scratch.select() end,
        function() Utils.fzf.scratch_select() end,
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
