local M = {}

---@param opts table<string, any>
function M.execute(opts)
  local params = {
    command = opts.command,
    arguments = opts.arguments,
  }
  if opts.open then
    require('trouble').open({
      mode = 'lsp_command',
      params = params,
    })
  else
    return vim.lsp.buf_request(0, 'workspace/executeCommand', params, opts.handler)
  end
end

-- Taken from https://www.reddit.com/r/neovim/comments/1gf7kyn/lsp_configuration_debugging/
-- Inspects active LSPs configuration
---@param client_name string LSP client name
local function open_lsp_float(client_name)
  local client = vim.lsp.get_clients({name = client_name})

  if #client == 0 then
    vim.notify('No active LSP clients found with this name: ' .. client_name, vim.log.levels.WARN)
    return
  end

  -- Create a temporary buffer to show the configuration
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = math.floor(vim.o.columns * 0.75),
    height = math.floor(vim.o.lines * 0.90),
    col = math.floor(vim.o.columns * 0.125),
    row = math.floor(vim.o.lines * 0.05),
    border = 'single',
    title = ' ' .. (client_name:gsub('^%l', string.upper)) .. ': LSP Configuration ',
    title_pos = 'center',
  })

  local lines = {}
  for i, this_client in ipairs(client) do
    if i > 1 then
      table.insert(lines, string.rep('-', 80))
    end
    table.insert(lines, 'Client: ' .. this_client.name)
    table.insert(lines, 'ID: ' .. this_client.id)
    table.insert(lines, '')
    table.insert(lines, 'Configuration:')

    local config_lines = vim.split(vim.inspect(this_client.config), '\n')
    vim.list_extend(lines, config_lines)
  end

  -- Set the lines in the buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Set buffer options
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = 'lua'
  vim.bo[buf].bh = 'delete'

  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q<CR>', {noremap = true, silent = true})
end

function M.inspect_lsp_client()
  local fzf = require('fzf-lua')
  local clients = vim.lsp.get_clients()
  local client_names = {}

  for _, client in ipairs(clients) do
    table.insert(client_names, client.name)
  end

  fzf.fzf_exec(client_names, {
    prompt = 'LSP Client name: ',
    winopts = {height = 0.33},
    actions = {
      ['default'] = function(selected, opts)
        local selected_client = selected[1]
        open_lsp_float(selected_client)
      end,
    },
  })
end

---@param on_attach fun(client:vim.lsp.Client, buffer)
---@param name? string
function M.on_attach(on_attach, name)
  return vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local buffer = args.buf ---@type number
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and (not name or client.name == name) then
        return on_attach(client, buffer)
      end
    end,
  })
end

return M
