local M = {}

M.setup = function(capabilities, on_attach)
  return {
    capabilities = capabilities,
    on_attach = on_attach,
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
      },
    },
    commands = {
      OrganizeImports = {
        function()
          local params = {
            command = '_typescript.organizeImports',
            arguments = {vim.api.nvim_buf_get_name(0)},
            title = '',
          }
          vim.lsp.buf.execute_command(params)
        end,
        description = 'Organize imports',
      },
    },
  }
end

return M
