local M = {}

M.setup = function(capabilities, on_attach)
  return {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      css = {
        lint = {unknownAtRules = 'ignore'},
      },
    },
  }
end

return M
