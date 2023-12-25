return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = {{'nvim-lua/plenary.nvim'}},
  config = function()
    local harpoon = require('harpoon')
    local utils = require('utils')

    local list_name = 'ufo'
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

    harpoon:setup({
      [list_name] = {
        select = function(list_item, list, option)
          local bufnr = vim.fn.bufnr(list_item.value)
          local set_position = false

          if bufnr == -1 then
            set_position = true
            bufnr = vim.fn.bufnr(list_item.value, true)
          end
          if not vim.api.nvim_buf_is_loaded(bufnr) then
            vim.fn.bufload(bufnr)
            vim.api.nvim_set_option_value('buflisted', true, {
              buf = bufnr,
            })
          end

          vim.api.nvim_set_current_buf(bufnr)

          if set_position then
            vim.api.nvim_win_set_cursor(0, {
              list_item.context.row or 1,
              list_item.context.col or 0,
            })
          end

          vim.cmd('UfoEnableFold')
        end
      }
    })

    harpoon:extend({
      UI_CREATE = function(cx)
        km(
          '<C-v>',
          function() harpoon.ui:select_menu_item({vsplit = true}) end,
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

    km(';a', function() harpoon:list(list_name):append() end, {desc = 'Add to list'})
    km(';h', function() harpoon.ui:toggle_quick_menu(harpoon:list(list_name), menu_opts) end, {desc = 'Open menu'})

    km(';1', function() harpoon:list(list_name):select(1) end, {desc = 'Select file 1'})
    km(';2', function() harpoon:list(list_name):select(2) end, {desc = 'Select file 2'})
    km(';3', function() harpoon:list(list_name):select(3) end, {desc = 'Select file 3'})
    km(';4', function() harpoon:list(list_name):select(4) end, {desc = 'Select file 4'})
    km(';5', function() harpoon:list(list_name):select(5) end, {desc = 'Select file 5'})
    km(';6', function() harpoon:list(list_name):select(6) end, {desc = 'Select file 6'})
    km(';7', function() harpoon:list(list_name):select(7) end, {desc = 'Select file 7'})
    km(';8', function() harpoon:list(list_name):select(8) end, {desc = 'Select file 8'})
    km(';9', function() harpoon:list(list_name):select(9) end, {desc = 'Select file 9'})
    -- If I ever have more than 9 tabs open, time to rethink my life choices

    km('<S-h>', function() harpoon:list(list_name):prev() end, {desc = 'Previous file'})
    km('<S-l>', function() harpoon:list(list_name):next() end, {desc = 'Next file'})
  end
}
