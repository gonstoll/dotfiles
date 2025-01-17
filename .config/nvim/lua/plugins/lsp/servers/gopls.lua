local M = {}

M.setup = function(capabilities)
  return {
    capabilities = capabilities,
    settings = {
      gopls = {
        -- analyses = {
        --   unusedparams = true,
        -- },
        -- staticcheck = true,
        gofumpt = true,
      },
    },
  }
end

return M
