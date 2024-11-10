local M = {}

M.setup = function(capabilities)
  return {
    capabilities = capabilities,
    settings = {
      json = {
        format = {
          enable = true,
          keepLines = true,
        },
      },
    },
  }
end

return M
