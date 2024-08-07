local utils = require('utils')
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight yanked text
autocmd('TextYankPost', {
  pattern = '*',
  group = augroup('YankHighlight', {}),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Disable eslint on node_modules
autocmd({'BufNewFile', 'BufRead'}, {
  pattern = {'**/node_modules/**', 'node_modules', '/node_modules/*'},
  group = augroup('DisableEslintOnNodeModules', {}),
  callback = function()
    vim.diagnostic.disable(0)
  end,
})

-- Fugitive keymaps
autocmd('BufWinEnter', {
  pattern = '*',
  group = augroup('Fugitive', {}),
  callback = function()
    if (vim.bo.filetype ~= 'fugitive') then
      return
    end

    -- Only run this on fugitive buffers
    local bufnr = vim.api.nvim_get_current_buf()
    vim.keymap.set('n', '<leader>P', function()
      vim.cmd.Git('push')
    end, {buffer = bufnr, remap = false, desc = 'Fugitive: Push'})
    vim.keymap.set('n', '<leader>p', function()
      vim.cmd.Git('pull')
    end, {buffer = bufnr, remap = false, desc = 'Fugitive: Pull'})
  end,
})

-- Disable commenting new lines
vim.cmd('autocmd BufEnter * set formatoptions-=cro')
vim.cmd('autocmd BufEnter * setlocal formatoptions-=cro')

-- Make sure any opened buffer which is contained in a git repo will be tracked
vim.cmd('autocmd BufEnter * :lua require("lazygit.utils").project_root_dir()')

-- Statusline
local statusline_group = augroup('StatusLine', {})
autocmd({'WinEnter', 'BufEnter'}, {
  pattern = '*',
  group = statusline_group,
  callback = function()
    if (vim.bo.filetype == 'oil') then
      vim.cmd('setlocal statusline=%!v:lua.Statusline.oil()')
      return
    end
    vim.cmd('setlocal statusline=%!v:lua.Statusline.active()')
  end,
})

autocmd({'WinLeave', 'BufLeave'}, {
  pattern = '*',
  group = statusline_group,
  callback = function()
    vim.cmd('setlocal statusline=%!v:lua.Statusline.inactive()')
  end,
})

autocmd('TermOpen', {
  group = augroup('custom-term-open', {}),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrolloff = 0
  end,
})

-- au('FileType', {
--   pattern = {'fugitive', 'netrw', 'qf', 'help'},
--   callback = function()
--     vim.keymap.set('n', 'q', vim.cmd.close, {desc = 'Close the current buffer', buffer = true})
--   end,
-- })

autocmd('LspAttach', {
  group = augroup('lsp-attach', {}),
  callback = function(opts)
    local bufnr = opts.buf
    local function keyset(mode, keys, func, desc)
      vim.keymap.set(mode, keys, func, {buffer = bufnr, desc = 'LSP: ' .. desc})
    end

    keyset('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
    keyset('n', '<leader>ca', vim.lsp.buf.code_action, 'Code Action')
    keyset('n', '<leader>td', vim.lsp.buf.type_definition, 'Type Definition')
    keyset('n', '<leader>hd', vim.lsp.buf.hover, 'Hover Documentation')
    keyset('n', '<leader>sd', vim.lsp.buf.signature_help, 'Signature Documentation')
    keyset('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, 'Workspace Add Folder')
    keyset('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, 'Workspace Remove Folder')
    keyset('n', 'gd', utils.cmd_center(vim.lsp.buf.definition), 'Goto Definition')
    keyset('n', 'gD', utils.cmd_center(vim.lsp.buf.declaration), 'Goto Declaration')
    keyset('n', 'gi', utils.cmd_center(vim.lsp.buf.implementation), 'Goto Implementation')
    keyset('n', '[d', utils.cmd_center(vim.diagnostic.goto_prev), 'Previous diagnostic')
    keyset('n', ']d', utils.cmd_center(vim.diagnostic.goto_next), 'Next diagnostic')
    keyset('n', 'gl', vim.diagnostic.open_float, 'Open diagnostics')

    keyset('n', '<leader>it', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({bufnr = bufnr}))
    end, 'Toggle inlay hints')
    keyset('n', '<leader>f', function()
      require('conform').format({async = true, lsp_fallback = true})
    end, 'Format current buffer with LSP')

    keyset('i', '<C-s>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_create_user_command('Format', function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = {args.line1, 0},
          ['end'] = {args.line2, end_line:len()},
        }
      end
      require('conform').format({async = true, lsp_fallback = true, range = range})
    end, {range = true})
  end
})

-- Set Cursor and CursorLine highlights on colorscheme change
autocmd('ColorScheme', {
  pattern = '*',
  group = augroup('CursorLine', {}),
  callback = function()
    vim.api.nvim_set_hl(0, 'Cursor', {bg = 'NONE'})
    vim.api.nvim_set_hl(0, 'CursorLine', {bg = 'NONE'})
  end,
})
