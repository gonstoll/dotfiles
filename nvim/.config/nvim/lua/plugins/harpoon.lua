local desc = require('utils').plugin_keymap_desc('harpoon')

return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = {'nvim-lua/plenary.nvim'},
  config = function()
    local harpoon = require('harpoon')
    local extensions = require('harpoon.extensions')
    local menu_opts = {border = 'single', title_pos = 'center'}

    harpoon:setup({settings = {save_on_toggle = true, sync_on_ui_close = true}})
    harpoon:extend(extensions.builtins.command_on_nav('UfoEnableFold'))
    harpoon:extend({
      UI_CREATE = function(cx)
        vim.keymap.set(
          'n',
          '<C-v>',
          function() harpoon.ui:select_menu_item({vsplit = true}) end,
          {desc = desc('Open as vertical split'), buffer = cx.bufnr}
        )
        vim.keymap.set(
          'n',
          '<C-x>',
          function() harpoon.ui:select_menu_item({split = true}) end,
          {desc = desc('Open as split'), buffer = cx.bufnr}
        )
        vim.keymap.set(
          'n',
          '<C-t>',
          function() harpoon.ui:select_menu_item({tabedit = true}) end,
          {desc = desc('Open in new tab'), buffer = cx.bufnr}
        )
      end,
    })

    vim.keymap.set('n', ';h', function() harpoon.ui:toggle_quick_menu(harpoon:list(), menu_opts) end, {desc = desc('Open menu')})
    vim.keymap.set('n', ';a', function() harpoon:list():add() end, {desc = desc('Add to list')})
    vim.keymap.set('n', ';1', function() harpoon:list():select(1) end, {desc = desc('Select file 1')})
    vim.keymap.set('n', ';2', function() harpoon:list():select(2) end, {desc = desc('Select file 2')})
    vim.keymap.set('n', ';3', function() harpoon:list():select(3) end, {desc = desc('Select file 3')})
    vim.keymap.set('n', ';4', function() harpoon:list():select(4) end, {desc = desc('Select file 4')})
    vim.keymap.set('n', ';5', function() harpoon:list():select(5) end, {desc = desc('Select file 5')})
    vim.keymap.set('n', ';6', function() harpoon:list():select(6) end, {desc = desc('Select file 6')})
    vim.keymap.set('n', ';7', function() harpoon:list():select(7) end, {desc = desc('Select file 7')})
    vim.keymap.set('n', ';8', function() harpoon:list():select(8) end, {desc = desc('Select file 8')})
    vim.keymap.set('n', ';9', function() harpoon:list():select(9) end, {desc = desc('Select file 9')}) -- If I ever have more than 9 tabs open, time to rethink my life choices
    vim.keymap.set('n', '<S-h>', function() harpoon:list():prev() end, {desc = desc('Previous file')})
    vim.keymap.set('n', '<S-l>', function() harpoon:list():next() end, {desc = desc('Next file')})
  end
}
