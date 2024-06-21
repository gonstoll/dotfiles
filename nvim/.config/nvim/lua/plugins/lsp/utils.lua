local M = {}

M.execute = function(opts)
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

return M
