local desc = require('utils').plugin_keymap_desc('LSP')
local M = {}

M.setup = function()
  return {
    {
      'williamboman/mason.nvim',
      build = ':MasonUpdate',
      opts = {
        ui = {border = 'rounded'}
      },
    },

    {
      'williamboman/mason-lspconfig.nvim',
      event = 'VeryLazy',
      opts = {
        ensure_installed = {'tailwindcss', 'cssls', 'lua_ls', 'eslint', 'emmet_language_server', 'tsserver', 'bashls'},
        automatic_installation = true,
      },
    },

    {
      'neovim/nvim-lspconfig',
      event = {'BufReadPost', 'BufNewFile', 'BufWritePre'},
      dependencies = {'folke/neodev.nvim'},
      config = function()
        vim.diagnostic.config({
          virtual_text = true,
          severity_sort = true,
          underline = true,
          float = {
            border = 'rounded',
            source = 'always',
            title = 'Diagnostics',
            max_width = 100,
          },
        })

        vim.lsp.handlers['textDocument/hover'] = function(_, result, ctx, config)
          config = require('utils').merge_table(config or {}, {border = 'rounded', title = 'Hover', max_width = 100})
          config.focus_id = ctx.method
          if not (result and result.contents) then
            return
          end
          local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
          markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
          if vim.tbl_isempty(markdown_lines) then
            return
          end
          return vim.lsp.util.open_floating_preview(markdown_lines, 'markdown', config)
        end

        vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
          vim.lsp.handlers.signature_help,
          {title = 'Signature', border = 'rounded', max_width = 100}
        )

        local icons = require('utils.icons')
        for type, icon in pairs(icons.diagnostics) do
          local hl = 'DiagnosticSign' .. type
          vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
        end

        -- ########################### NEODEV ###########################
        local neodev = require('neodev')
        neodev.setup({
          library = {plugins = {'nvim-dap-ui'}, types = true},
        })

        -- ########################### LSP ###########################
        local function on_attach(client, bufnr)
          local function map(mode, keys, func, description)
            vim.keymap.set(mode, keys, func, {buffer = bufnr, desc = desc(description)})
          end

          map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
          map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code Action')
          map('n', 'gd', vim.lsp.buf.definition, 'Goto Definition')
          map('n', 'gD', vim.lsp.buf.declaration, 'Goto Declaration')
          map('n', 'gi', vim.lsp.buf.implementation, 'Goto Implementation')
          map('n', 'gl', vim.diagnostic.open_float, 'Open diagnostics')
          map('n', '[d', function()
            vim.diagnostic.goto_prev()
            vim.cmd('normal! zz')
          end, 'Previous diagnostic')
          map('n', ']d', function()
            vim.diagnostic.goto_next()
            vim.cmd('normal! zz')
          end, 'Next diagnostic')
          map('n', '<leader>td', vim.lsp.buf.type_definition, 'Type Definition')
          map('n', '<leader>hd', vim.lsp.buf.hover, 'Hover Documentation')
          map('n', '<leader>sd', vim.lsp.buf.signature_help, 'Signature Documentation')
          map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, 'Workspace Add Folder')
          map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, 'Workspace Remove Folder')
          map('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, 'Workspace List Folders')
          map('n', '<leader>f', function()
            require('conform').format({async = true, lsp_fallback = true})
          end, 'Format current buffer with LSP')

          map('i', '<C-s>', vim.lsp.buf.signature_help, 'Signature Documentation')

          -- Create a command `:Format` local to the LSP buffer
          vim.api.nvim_create_user_command('Format', function(args)
            local range = nil
            if args.count ~= -1 then
              local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
              range = {
                start = {args.line1, 0},
                ['end'] = {args.line2, end_line:len()},
              }
            end
            require('conform').format({async = true, lsp_fallback = true, range = range})
          end, {range = true})
        end

        local lspconfig = require('lspconfig')
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        capabilities.textDocument.foldingRange = {dynamicRegistration = false, lineFoldingOnly = true}

        local lsp_servers = {
          tailwindcss = {capabilities = capabilities, on_attach = on_attach},
          emmet_language_server = {capabilities = capabilities, on_attach = on_attach},
          bashls = {capabilities = capabilities, on_attach = on_attach},
          cssls = require('plugins.lsp.configs.cssls').setup(capabilities, on_attach),
          eslint = require('plugins.lsp.configs.eslint').setup(capabilities, on_attach),
          lua_ls = require('plugins.lsp.configs.lua_ls').setup(capabilities, on_attach),
          tsserver = require('plugins.lsp.configs.tsserver').setup(capabilities, on_attach),
        }

        for server_name, server_config in pairs(lsp_servers) do
          lspconfig[server_name].setup(server_config)
        end

        vim.keymap.set('n', '<leader>ef', ':EslintFixAll<CR>', {desc = 'Eslint: Fix all'})

        -- ########################### TYPESCRIPT ###########################
        local function typescript_keymap(user_command, lsp_command, description)
          vim.keymap.set('n', user_command, lsp_command, {desc = 'Typescript: ' .. description})
        end

        local function organize_imports()
          vim.lsp.buf.execute_command({
            command = '_typescript.organizeImports',
            arguments = {vim.fn.expand('%:p')}
          })
        end

        typescript_keymap('<leader>to', organize_imports, 'Organize imports')
      end,
    },
  }
end

return M
