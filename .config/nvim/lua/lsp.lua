local M = {}
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local methods = vim.lsp.protocol.Methods

---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
  ---@param mode string|string[] -- Vim mode
  ---@param keys string -- Key sequence
  ---@param func fun() -- Function to execute
  ---@param desc? string -- Keymap description
  local function keyset(mode, keys, func, desc)
    vim.keymap.set(mode, keys, func, {buffer = bufnr, desc = 'LSP: ' .. desc})
  end

  keyset('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
  keyset({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, 'Code Action')
  keyset('n', '<leader>td', vim.lsp.buf.type_definition, 'Type Definition')
  keyset('n', '<leader>sd', vim.lsp.buf.signature_help, 'Signature Documentation')
  keyset('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, 'Workspace Add Folder')
  keyset('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, 'Workspace Remove Folder')
  keyset('n', 'K', vim.lsp.buf.hover, 'Hover Documentation')
  keyset('n', 'gd', Utils.cmd_center(vim.lsp.buf.definition), 'Goto Definition')
  keyset('n', 'gD', Utils.cmd_center(vim.lsp.buf.declaration), 'Goto Declaration')
  keyset('n', 'gi', Utils.cmd_center(vim.lsp.buf.implementation), 'Goto Implementation')
  keyset('n', '[d', Utils.cmd_center(vim.diagnostic.goto_prev), 'Previous diagnostic')
  keyset('n', ']d', Utils.cmd_center(vim.diagnostic.goto_next), 'Next diagnostic')
  keyset('n', 'gl', vim.diagnostic.open_float, 'Open diagnostics')

  keyset('n', '<leader>it', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({bufnr = bufnr}))
  end, 'Toggle inlay hints')
  keyset('n', '<leader>fa', function()
    require('conform').format({async = true, lsp_fallback = true})
  end, 'Format current buffer with LSP')

  keyset('n', '<leader>lc', function()
    Utils.fzf.inspect_lsp_client()
  end, 'Inspect LSP Client configuration')

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

  -- Toggle signature help
  if client.supports_method(methods.textDocument_signatureHelp) then
    local signature = require('blink.cmp.signature.window')
    keyset('i', '<C-s>', function()
      if signature.win:is_open() then
        signature.win:close()
        return
      end
      signature.win:open()
      signature.update_position()
    end, 'Signature help')
  end

  local highlight_enabled = false
  local group_name = 'gonstoll/document_highlight'

  local function enable_document_highlight()
    local under_cursor_highlights_group = augroup(group_name, {clear = true})
    autocmd({'CursorHold', 'InsertLeave'}, {
      group = under_cursor_highlights_group,
      desc = 'Highlight references under the cursor',
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    autocmd({'CursorMoved', 'InsertEnter', 'BufLeave'}, {
      group = under_cursor_highlights_group,
      desc = 'Clear highlight references',
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
    highlight_enabled = true
  end

  local function disable_document_highlight()
    vim.api.nvim_clear_autocmds({group = group_name})
    vim.lsp.buf.clear_references()
    highlight_enabled = false
  end

  local function toggle_document_highlight()
    if highlight_enabled then
      disable_document_highlight()
    else
      enable_document_highlight()
    end
  end

  if client.supports_method(methods.textDocument_documentHighlight) then
    keyset('n', '<leader>ma', toggle_document_highlight, 'Toggle document highlights')
  end
end

autocmd('LspAttach', {
  group = augroup('lsp-attach', {}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- Just in case y'know
    if not client then
      return
    end

    on_attach(client, args.buf)
  end,
})

vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  underline = true,
  float = {
    border = 'single',
    source = true,
    max_width = 100,
  },
})

-- vim.lsp.handlers['textDocument/hover'] = function(_, result, ctx, config)
--   config = Utils.merge_table(config or {}, {border = 'single', max_width = 100})
--   config.focus_id = ctx.method
--   if not (result and result.contents) then
--     return
--   end
--   local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
--   markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
--   if vim.tbl_isempty(markdown_lines) then
--     return
--   end
--   return vim.lsp.util.open_floating_preview(markdown_lines, 'markdown', config)
-- end

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  {
    border = 'single',
    -- max_width = 100,
    max_width = math.floor(vim.o.columns * 0.4),
    max_height = math.floor(vim.o.lines * 0.5),
  }
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  {
    title = 'Signature help',
    border = 'single',
    title_pos = 'left',
    -- max_width = 100,
    max_width = math.floor(vim.o.columns * 0.4),
    max_height = math.floor(vim.o.lines * 0.5),
  }
)

for type, icon in pairs(Utils.icons.diagnostics) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
end

-- Configures the LSP server with completion capabilities and (optionally) its configurations and keybinds
---@param server string
---@param config? table
function M.server_setup(server, config)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

  require('lspconfig')[server].setup(
    vim.tbl_deep_extend('error', {capabilities = capabilities, silent = true}, config or {})
  )

  if config and config.keys then
    for _, key in ipairs(config.keys) do
      vim.keymap.set('n', key[1], key[2], {desc = key.desc})
    end
  end
end

return M
