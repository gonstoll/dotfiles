local desc = require('utils').plugin_keymap_desc('luasnip')

local ls = require('luasnip')
local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep

local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node
local d = ls.dynamic_node
local snippet = ls.s
local snippet_from_nodes = ls.sn

-- Keymaps
vim.keymap.set('n', '<leader><leader>s', '<cmd>source ~/.config/nvim/after/plugin/snippets.lua<CR>', {
  desc = desc('Source snippets')
})
vim.keymap.set({'i', 's'}, '<C-l>', function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, {desc = desc('Next choice')})

-- Snippets
ls.add_snippets('all', {
  snippet('date', {
    f(function()
      return string.format(string.gsub(vim.bo.commentstring, '%%s', ' %%s'), os.date())
    end, {}),
  }),
  snippet('todo', {
    c(1, {
      t('TODO: (gonza) - '),
      t('NOTE: (gonza) - '),
      t('FIX: (gonza) - '),
      t('WARNING: (gonza) - '),
      t('HACK: (gonza) - '),
      t('PERF: (gonza) - '),
    })
  })
})

ls.add_snippets('lua', {
  snippet('req', fmt("local {} = require('{}')", {
    f(function(import_name)
      local parts = vim.split(import_name[1][1], '.', true)
      return parts[#parts] or ''
    end, {1}),
    i(1, 'module')
  }))
})
