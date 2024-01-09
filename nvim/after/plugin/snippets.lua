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
      local parts = vim.split(import_name[1][1], '.', {plain = true})
      return parts[#parts] or ''
    end, {1}),
    i(1, 'module')
  }))
})

local typescript_snippets = {
  snippet('iar', t("import * as React from 'react'")),
  snippet('logging', fmt("console.log('logging {} ', {})", {i(1), i(0)})),
  snippet('rsc', {
    c(1, {
      t("'use server'"),
      t("'use client'"),
    })
  }),
  snippet('func', {
    c(1, {
      fmt([[export function {}() {{
        {}
      }}]], {i(1), i(0)}),
      fmt([[export async function {}() {{
        {}
      }}]], {i(1), i(0)}),
    })
  }),
}

local react_snippets = {
  snippet('rc', {
    c(1, {
      fmt([[import * as React from 'react'

export function {}() {{
  return <div />{}
}}]], {i(1), i(0)}),
      fmt([[import * as React from 'react'

type Props = {{
  {}
}}

export function {}({{{}}}: Props) {{
  return <div />{}
}}]], {i(3), i(2), i(1), i(0)}),
    })
  }),
  snippet('izod', t("import {z} from 'zod'")),
}

ls.add_snippets('typescript', typescript_snippets)
ls.add_snippets('javascript', typescript_snippets)
ls.add_snippets('typescriptreact', require('utils').merge_table(typescript_snippets, react_snippets))
ls.add_snippets('javascriptreact', require('utils').merge_table(typescript_snippets, react_snippets))
