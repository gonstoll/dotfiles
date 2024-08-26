local icons = require('utils.icons')
local desc = require('utils').plugin_keymap_desc('fzf')

local grep_opts = {
  'rg',
  '--vimgrep',
  '--hidden',
  '--glob',
  '"!**/.git/*"',
  '--column',
  '--line-number',
  '--no-heading',
  '--color=always',
  '--smart-case',
  '--max-columns=4096',
  '-e',
}

return {
  'ibhagwan/fzf-lua',
  dependencies = {{'nvim-tree/nvim-web-devicons', lazy = true}},
  cmd = 'FzfLua',
  event = 'VeryLazy',
  keys = function()
    local fzf = require('fzf-lua')
    return {
      {';?', fzf.oldfiles, desc = desc('Find recently opened files')},
      {';;', fzf.buffers, desc = desc('Find opened buffers in current neovim instance')},
      {';/', fzf.lgrep_curbuf, desc = desc('Fuzzily search in current buffer')},
      {';sf', fzf.files, desc = desc('Search files')},
      {';sg', fzf.grep, desc = desc('Search by grep')},
      {';sl', fzf.live_grep, desc = desc('Search by live grep')},
      {';gf', fzf.git_files, desc = desc('Search Git Files')},
      {';sk', fzf.keymaps, desc = desc('Keymaps')},
      {';sh', fzf.helptags, desc = desc('Search Help')},
      {';sm', fzf.manpages, desc = desc('Search man pages')},
      {';ss', fzf.search_history, desc = desc('Get list of searches')},
      {';se', fzf.lsp_document_diagnostics, desc = desc('Get file diagnostics')},
      {';sd', fzf.lsp_workspace_diagnostics, desc = desc('Search Diagnostics')},
      {';gr', fzf.lsp_references, desc = desc('Goto References')},
      {';ds', fzf.lsp_document_symbols, desc = desc('Document Symbols')},
      {';ws', fzf.lsp_live_workspace_symbols, desc = desc('Workspace Symbols')},
    }
  end,
  opts = function()
    local actions = require('fzf-lua.actions')

    require('fzf-lua').register_ui_select(function(_, items)
      local min_h, max_h = 0.35, 0.70
      local h = (#items + 4) / vim.o.lines
      if h < min_h then
        h = min_h
      elseif h > max_h then
        h = max_h
      end
      return {
        winopts = {height = h, width = 0.60, row = 0.40},
      }
    end)

    return {
      winopts = {
        width = 0.60,
        height = 0.9,
        backdrop = 100,
        preview = {
          layout = 'vertical',
          vertical = 'down:45%',
        },
      },
      fzf_opts = {
        ['--tiebreak'] = 'begin', -- Proper sort of results (see https://github.com/ibhagwan/fzf-lua/issues/411#issuecomment-1125527931)
        ['--info'] = 'default',
        ['--layout'] = 'default',
        ['--margin'] = '0,1',
      },
      keymap = {
        builtin = {
          ['<C-d>'] = 'preview-page-down',
          ['<C-u>'] = 'preview-page-up',
        },
        fzf = {
          ['ctrl-d'] = 'preview-page-down',
          ['ctrl-u'] = 'preview-page-up',
          ['ctrl-q'] = 'select-all+accept',
        },
      },
      files = {
        cwd_prompt = false,
        prompt = icons.misc.file .. ' ',
      },
      grep = {
        cwd_prompt = false,
        prompt = icons.misc.search .. ' ',
        input_prompt = 'Grep For ❯ ',
        cmd = table.concat(grep_opts, ' '),
        -- actions = {
        --   ['ctrl-q'] = {
        --     fn = actions.file_edit_or_qf, prefix = 'select-all+'
        --   },
        -- },
      },
      buffers = {
        actions = {
          ['ctrl-x'] = {actions.buf_del, actions.resume},
        },
      },
    }
  end,
}
