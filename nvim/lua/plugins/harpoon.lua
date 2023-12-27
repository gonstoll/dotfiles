return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = {{'nvim-lua/plenary.nvim'}},
  config = function()
    local harpoon = require('harpoon')
    local extensions = require('harpoon.extensions')
    local utils = require('utils')

    local menu_opts = {
      border = 'rounded',
      title_pos = 'center',
    }

    local function km(rhs, command, opts)
      vim.keymap.set(
        'n',
        rhs,
        command,
        utils.mergeTable(opts, {desc = opts.desc and 'Harpoon: ' .. opts.desc or nil})
      )
    end

    harpoon:setup({})
    harpoon:extend(extensions.builtins.command_on_nav('UfoEnableFold'))
    harpoon:extend({
      UI_CREATE = function(cx)
        km(
          '<C-v>',
          function()
            harpoon.ui:select_menu_item({vsplit = true})
          end,
          {desc = 'Open as vertical split', buffer = cx.bufnr}
        )
        km(
          '<C-x>',
          function() harpoon.ui:select_menu_item({split = true}) end,
          {desc = 'Open as split', buffer = cx.bufnr}
        )
        km(
          '<C-t>',
          function() harpoon.ui:select_menu_item({tabedit = true}) end,
          {desc = 'Open in new tab', buffer = cx.bufnr}
        )
      end,
    })

    km(';a', function() harpoon:list():append() end, {desc = 'Add to list'})
    km(';h', function() harpoon.ui:toggle_quick_menu(harpoon:list(), menu_opts) end, {desc = 'Open menu'})

    km(';1', function() harpoon:list():select(1) end, {desc = 'Select file 1'})
    km(';2', function() harpoon:list():select(2) end, {desc = 'Select file 2'})
    km(';3', function() harpoon:list():select(3) end, {desc = 'Select file 3'})
    km(';4', function() harpoon:list():select(4) end, {desc = 'Select file 4'})
    km(';5', function() harpoon:list():select(5) end, {desc = 'Select file 5'})
    km(';6', function() harpoon:list():select(6) end, {desc = 'Select file 6'})
    km(';7', function() harpoon:list():select(7) end, {desc = 'Select file 7'})
    km(';8', function() harpoon:list():select(8) end, {desc = 'Select file 8'})
    km(';9', function() harpoon:list():select(9) end, {desc = 'Select file 9'})
    -- If I ever have more than 9 tabs open, time to rethink my life choices

    km('<S-h>', function() harpoon:list():prev() end, {desc = 'Previous file'})
    km('<S-l>', function() harpoon:list():next() end, {desc = 'Next file'})
  end
}
