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
    return {
      winopts = {
        width = 0.8,
        height = 0.9,
        backdrop = 100,
      },
      fzf_opts = {
        ['--tiebreak'] = 'begin', -- Proper sort of results (see https://github.com/ibhagwan/fzf-lua/issues/411#issuecomment-1125527931)
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
      buffers = {
        keymap = {builtin = {['C-d'] = false}},
        actions = {
          ['ctrl-x'] = false,
          ['ctrl-d'] = {actions.buf_del, actions.resume},
        },
      },
      grep = {
        cmd = table.concat(grep_opts, ' ')
      },
    }
  end,
}
