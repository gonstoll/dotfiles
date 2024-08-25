local desc = require('utils').plugin_keymap_desc('typescript')
local lsp_utils = require('plugins.lsp.utils')
local M = {}

M.setup = function(capabilities)
  return {
    capabilities = capabilities,
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
        preferences = {
          importModuleSpecifier = 'project-relative',
        },
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
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
        preferences = {
          importModuleSpecifier = 'project-relative',
        },
        inlayHints = {
          includeInlayParameterNameHints = 'literal',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
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
