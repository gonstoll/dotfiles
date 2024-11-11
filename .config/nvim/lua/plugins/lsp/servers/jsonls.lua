local M = {}

M.setup = function(capabilities)
  return {
    capabilities = capabilities,
    settings = {
      json = {
        maxItemsComputed = 5000,
        colorDecorators = {enable = true},
        format = {enable = true},
        keepLines = {enable = true},
        schemaDownload = {enable = true},
        trace = {server = 'off'},
        validate = {enable = true},
      },
    },
  }
end

return M
