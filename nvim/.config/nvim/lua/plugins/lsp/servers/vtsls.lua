local desc = require('utils').plugin_keymap_desc('typescript')
local lsp_utils = require('utils.lsp')
local M = {}

local settings = {
  updateImportsOnFileMove = {enabled = 'always'},
  format = {
    enable = false,
    insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
    insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = false,
  },
  preferences = {
    importModuleSpecifier = os.getenv('LSP_TS_IMPORT_MODULE_SPECIFIER_PROJECT_RELATIVE') and 'project-relative' or 'auto',
  },
  inlayHints = {
    parameterNames = {enabled = 'literals'},
    parameterTypes = {enabled = true},
    variableTypes = {enabled = true},
    propertyDeclarationTypes = {enabled = true},
    functionLikeReturnTypes = {enabled = true},
    enumMemberValues = {enabled = true},
  },
}

M.setup = function(capabilities)
  return {
    capabilities = capabilities,
    settings = {
      complete_function_calls = true,
      vtsls = {
        enableMoveToFileCodeAction = true,
        autoUseWorkspaceTsdk = true,
        experimental = {
          completion = {
            enableServerSideFuzzyMatch = true,
          },
        },
      },
      javascript = settings,
      typescript = settings,
    },
    keys = {
      {
        '<leader>tD',
        function()
          local params = vim.lsp.util.make_position_params()
          lsp_utils.execute({
            command = 'typescript.goToSourceDefinition',
            arguments = {params.textDocument.uri, params.position},
            open = true,
          })
        end,
        desc = desc('Go to source definition'),
      },
      {
        '<leader>tr',
        function()
          lsp_utils.execute({
            command = 'typescript.findAllFileReferences',
            arguments = {vim.uri_from_bufnr(0)},
            open = true,
          })
        end,
        desc = desc('Fin all file references'),
      },
      {
        '<leader>to',
        function()
          vim.lsp.buf.code_action({
            apply = true,
            context = {
              only = {'source.organizeImports'},
              diagnostics = {},
            },
          })
        end,
        desc = desc('Organize imports'),
      },
      {
        '<leader>ta',
        function()
          vim.lsp.buf.code_action({
            apply = true,
            context = {
              only = {'source.addMissingImports.ts'},
              diagnostics = {},
            },
          })
        end,
        desc = desc('Add missing imports'),
      },
      {
        '<leader>tR',
        function()
          vim.lsp.buf.code_action({
            apply = true,
            context = {
              only = {'source.removeUnused.ts'},
              diagnostics = {},
            },
          })
        end,
        desc = desc('Remove unused imports'),
      },
      {
        '<leader>tf',
        function()
          vim.lsp.buf.code_action({
            apply = true,
            context = {
              only = {'source.fixAll.ts'},
              diagnostics = {},
            },
          })
        end,
        desc = desc('Fix all'),
      },
      {
        '<leader>tt',
        function()
          lsp_utils.execute({command = 'typescript.selectTypeScriptVersion'})
        end,
        desc = desc('Select typescript version'),
      },
    },
  }
end

return M
