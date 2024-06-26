local M = {}

M.setup = function(capabilities)
  return {
    capabilities = capabilities,
    settings = {
      css = {
        lint = {unknownAtRules = 'ignore'},
      },
    },
  }
end

return M
