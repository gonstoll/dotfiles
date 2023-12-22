local M = {}

M.config = function()
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
      opts = {
        ensure_installed = {'tailwindcss', 'cssls', 'lua_ls', 'eslint', 'emmet_language_server', 'tsserver', 'bashls'},
        automatic_installation = true,
      },
    },

    {
      'neovim/nvim-lspconfig',
      event = {'BufReadPost', 'BufNewFile', 'BufWritePre'},
      dependencies = {
        'folke/neodev.nvim',
        {
          'kevinhwang91/nvim-ufo',
          dependencies = {'kevinhwang91/promise-async', lazy = true},
        }
      },
      init = function()
        vim.diagnostic.config({
          virtual_text = false,
          severity_sort = true,
          float = {
            border = 'rounded',
            source = 'always',
            title = 'Diagnostics',
            max_width = 100,
          },
        })

        vim.lsp.handlers['textDocument/hover'] = function(_, result, ctx, config)
          config = require('utils').mergeTable(config or {}, {border = 'rounded', title = 'Hover', max_width = 100})
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
      end,
      config = function()
        local function on_attach(client, bufnr)
          local function nmap(keys, func, desc)
            if desc then
              desc = 'LSP: ' .. desc
            end

            vim.keymap.set('n', keys, func, {buffer = bufnr, desc = desc})
          end

          local function imap(keys, func, desc)
            if desc then
              desc = 'LSP: ' .. desc
            end

            vim.keymap.set('i', keys, func, {buffer = bufnr, desc = desc})
          end

          nmap('<leader>rn', vim.lsp.buf.rename, 'Rename')
          nmap('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
          nmap('gd', vim.lsp.buf.definition, 'Goto Definition')
          nmap('gD', vim.lsp.buf.declaration, 'Goto Declaration')
          nmap('gi', vim.lsp.buf.implementation, 'Goto Implementation')
          nmap('gl', vim.diagnostic.open_float, 'Open diagnostics')
          nmap('[d', vim.diagnostic.goto_prev, 'Previous diagnostic')
          nmap(']d', vim.diagnostic.goto_next, 'Next diagnostic')
          nmap('<leader>td', vim.lsp.buf.type_definition, 'Type Definition')
          nmap('<leader>hd', vim.lsp.buf.hover, 'Hover Documentation')
          nmap('<leader>sd', vim.lsp.buf.signature_help, 'Signature Documentation')
          nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, 'Workspace Add Folder')
          nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, 'Workspace Remove Folder')
          nmap('<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, 'Workspace List Folders')
          nmap('<leader>f', function()
            require('conform').format({async = true, lsp_fallback = true})
          end, 'Format current buffer with LSP')

          imap('<C-s>', vim.lsp.buf.signature_help, 'Signature Documentation')

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

          if client.server_capabilities['documentSymbolProvider'] then
            require('nvim-navic').attach(client, bufnr)
          end
        end

        local lspconfig = require('lspconfig')

        -- ########################### LSP ###########################
        require('lspconfig.ui.windows').default_options.border = 'rounded'

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true
        }

        local lsp_servers = {
          tailwindcss = {},
          cssls = {},
          emmet_language_server = {},
          bashls = {},
          eslint = require('plugins.lsp.configs.eslint').setup(capabilities, on_attach),
          lua_ls = require('plugins.lsp.configs.lua_ls').setup(capabilities, on_attach),
          tsserver = require('plugins.lsp.configs.tsserver').setup(capabilities, on_attach),
        }

        for server_name, server_config in pairs(lsp_servers) do
          if (server_config == nil) then
            lspconfig[server_name].setup {
              capabilities = capabilities,
              on_attach = on_attach,
            }
          else
            lspconfig[server_name].setup(server_config)
          end
        end

        -- ########################### TYPESCRIPT ###########################
        local function typescript_keymap(user_command, lsp_command, description)
          vim.keymap.set('n', user_command, lsp_command, {desc = 'Typescript: ' .. description})
        end

        typescript_keymap('<leader>to', ':OrganizeImports<CR>', 'Organize imports')

        -- ########################### NEODEV ###########################
        local neodev = require('neodev')
        neodev.setup()

        -- ########################### UFO ###########################
        local ufo = require('ufo')
        ufo.setup()

        vim.keymap.set('n', 'zR', ufo.openAllFolds)
        vim.keymap.set('n', 'zM', ufo.closeAllFolds)
        vim.keymap.set('n', 'K', function()
          local winid = ufo.peekFoldedLinesUnderCursor(true)
          if not winid then
            vim.lsp.buf.hover()
          end
        end, {desc = 'LSP: Show hover documentation and folded code'})
      end,
    },
  }
end

return M
