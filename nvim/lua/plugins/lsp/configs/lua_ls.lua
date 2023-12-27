local M = {}

M.setup = function(capabilities, on_attach)
  return {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      Lua = {
        workspace = {checkThirdParty = false},
        telemetry = {enable = false},
        completion = {callSnippet = 'Replace'},
        diagnostics = {
          globals = {'vim'},
        },
        format = {
          enable = true,
          defaultConfig = {
            quote_style = 'single',
            space_around_table_field_list = false,
            space_inside_square_brackets = false,
          },
        },
      },
    },
  }
end

return M
