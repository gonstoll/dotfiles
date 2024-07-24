-- A lot here was taken from https://github.com/mike-jl/harpoonEx
local desc = require('utils').plugin_keymap_desc('harpoon')

local globalIndex = {}

local function get_full_path(path)
  local bufPath = vim.uv.fs_realpath(path)
  if not bufPath then
    if string.sub(path, 1, 1) == '/' then
      bufPath = path
    else
      bufPath = vim.uv.fs_realpath('.') .. '/' .. path
    end
  end
  return bufPath
end

local function sync_index(list, index)
  if index then
    globalIndex[list.name] = index
    return
  end

  if globalIndex[list.name] > list._length then
    globalIndex[list.name] = list._length
    return
  end
  local bufPath = get_full_path(vim.api.nvim_buf_get_name(0))
  -- find corresponding harpoon item
  for i = 1, list._length do
    local item = list.items[i]
    if item ~= nil and item.value ~= nil then
      local harpoonPath = get_full_path(item.value)
      if bufPath == harpoonPath then
        globalIndex[list.name] = i
        return
      end
    end
  end
end

local function cur_buf_is_harpoon(list)
  local current = list.items[globalIndex[list.name]]
  if not current then
    return true
  end

  local bufnr = vim.fn.bufnr(get_full_path(current.value))

  return bufnr == vim.fn.bufnr()
end

local function next_harpoon(list, prev)
  if not cur_buf_is_harpoon(list) then
    list:select(globalIndex[list.name])
    return
  end
  local i = globalIndex[list.name] or 0
  local j = 1
  while true do
    if prev then
      i = i - 1
    else
      i = i + 1
    end
    if list.items[i] then
      list:select(i)
      return
    end
    j = j + 1
    if j > list._length then
      return
    end
  end
end

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
      SELECT = function(args)
        sync_index(args.list, args.idx)
      end,
      ADD = function(args)
        sync_index(args.list, args.idx)
      end,
      REMOVE = function(args)
        sync_index(args.list)
      end,
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
    -- vim.keymap.set('n', '<S-h>', function() harpoon:list():prev() end, {desc = desc('Previous file')})
    -- vim.keymap.set('n', '<S-l>', function() harpoon:list():next() end, {desc = desc('Next file')})
    vim.keymap.set('n', '<S-h>', function() next_harpoon(harpoon:list(), true) end, {desc = desc('Previous file')})
    vim.keymap.set('n', '<S-l>', function() next_harpoon(harpoon:list(), false) end, {desc = desc('Next file')})
  end
}
