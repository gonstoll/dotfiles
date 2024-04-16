local M = {}

M.setup = function(capabilities, on_attach)
  return {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
      allow_incremental_sync = false,
    },
    settings = {
      javascript = {
        format = {
          enable = false,
          insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
          insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = false,
        },
        updateImportsOnFileMove = {
          enabled = 'always',
        },
      },
      typescript = {
        format = {
          enable = false,
          insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
          insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = false,
        },
        updateImportsOnFileMove = {
          enabled = 'always',
        },
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = true,
          },
        },
      },
    },
  }
end

return M
