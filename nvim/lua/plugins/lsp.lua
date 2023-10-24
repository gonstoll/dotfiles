return {
  {
    'onsails/lspkind-nvim',
    init = function()
      return {mode = 'symbol'}
    end,
  },

  {
    'nvimdev/lspsaga.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    event = 'LspAttach',
    opts = {
      ui = {border = 'rounded'},
      symbol_in_winbar = {
        enable = true,
        folder_level = 2,
      },
      lightbulb = {
        enable = false,
        sign = false,
      },
      outline = {
        layout = 'float',
        max_height = 0.7,
        left_width = 0.4,
      },
    },
    keys = {
      {
        '<leader>gj',
        '<Cmd>Lspsaga diagnostic_jump_next<CR>',
        mode = 'n',
        noremap = true,
        silent = true,
        desc = 'Diagnostics: Jump next (lspsaga)',
      },
      {
        '<leader>gh',
        '<Cmd>Lspsaga hover_doc<CR>',
        mode = 'n',
        noremap = true,
        silent = true,
        desc = 'Documentation on hover (lspsaga)'
      },
      {
        '<leader>gl',
        '<Cmd>Lspsaga show_line_diagnostics<CR>',
        mode = 'n',
        noremap = true,
        silent = true,
        desc = "Diagnostics: Show line's (lspsaga)",
      },
      {
        '<leader>gb',
        '<Cmd>Lspsaga show_buf_diagnostics<CR>',
        mode = 'n',
        noremap = true,
        silent = true,
        desc = "Diagnostics: Show buffer's (lspsaga)",
      },
      {
        '<leader>gf',
        '<Cmd>Lspsaga finder<CR>',
        mode = 'n',
        noremap = true,
        silent = true,
        desc = 'Find references (lspsaga)',
      },
      {
        '<leader>gp',
        '<Cmd>Lspsaga peek_definition<CR>',
        mode = 'n',
        noremap = true,
        silent = true,
        desc = 'Peek definition (lspsaga)',
      },
      {
        '<leader>gt',
        '<Cmd>Lspsaga peek_type_definition<CR>',
        mode = 'n',
        noremap = true,
        silent = true,
        desc = 'Peek type definition (lspsaga)',
      },
      {
        '<leader>gr',
        '<Cmd>Lspsaga rename<CR>',
        mode = 'n',
        noremap = true,
        silent = true,
        desc = 'Rename (lspsaga)',
      },
      {
        '<leader>go',
        '<Cmd>Lspsaga outline<CR>',
        mode = 'n',
        noremap = true,
        silent = true,
        desc = "Show file outline (lspsaga) - 'e' to jump, 'o' to toggle",
      },
      {
        '<leader>ga',
        '<cmd>Lspsaga code_action<CR>',
        mode = {'n', 'v'},
        desc = 'Show code action (lspsaga)',
      },
    },
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'williamboman/mason.nvim',
        build = ':MasonUpdate',
      },
      'williamboman/mason-lspconfig.nvim',
      'folke/neodev.nvim',
      'pmizio/typescript-tools.nvim',
      {
        'kevinhwang91/nvim-ufo',
        dependencies = 'kevinhwang91/promise-async',
        event = 'VeryLazy',
      },
      'b0o/schemastore.nvim',
    },
    init = function()
      vim.diagnostic.config({
        virtual_text = false,
        severity_sort = true,
        float = {
          border = 'rounded',
          source = 'always',
          title = 'Diagnostics',
        },
      })

      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
        vim.lsp.handlers.hover,
        {border = 'rounded', title = 'Hover'}
      )

      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        {border = 'rounded'}
      )
    end,
    config = function()
      local mason = require('mason')

      mason.setup({
        ui = {border = 'rounded'}
      })

      local function on_attach(_, bufnr)
        local function nmap(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end

          vim.keymap.set('n', keys, func, {buffer = bufnr, desc = desc})
        end

        nmap('<leader>rn', vim.lsp.buf.rename, 'Rename')
        nmap('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
        nmap('gd', vim.lsp.buf.definition, 'Goto Definition')
        nmap('gD', vim.lsp.buf.declaration, 'Goto Declaration')
        nmap('gr', require('telescope.builtin').lsp_references, 'Goto References')
        nmap('gi', vim.lsp.buf.implementation, 'Goto Implementation')
        nmap('<leader>td', vim.lsp.buf.type_definition, 'Type Definition')
        nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, 'Document Symbols')
        nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace Symbols')
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

        nmap('gl', '<cmd>lua vim.diagnostic.open_float()<cr>', 'Open diagnostics')
        nmap('[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', 'Previous diagnostic')
        nmap(']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', 'Next diagnostic')
      end

      local mason_lspconfig = require('mason-lspconfig')
      local lspconfig = require('lspconfig')
      local typescript_tools = require('typescript-tools')

      -- ########################### NEODEV ###########################
      local neodev = require('neodev')
      neodev.setup()

      -- ########################### LSP ###########################
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      local servers = {
        tailwindcss = {},
        cssls = {},
        astro = {},
        efm = {},
        lua_ls = {
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
        jsonls = {
          schemas = require('schemastore').json.schemas {
            select = {
              '.eslintrc',
              'package.json',
              'prettierrc.json',
              'babelrc.json'
            },
          },
          validate = {enable = true},
        },
        eslint = {format = false},
        emmet_language_server = {},
      }

      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
      }

      mason_lspconfig.setup_handlers {
        function(server_name)
          lspconfig[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
          }
        end,
      }

      -- ########################### TYPESCRIPT ###########################
      typescript_tools.setup {
        on_attach = on_attach,
        settings = {
          expose_as_code_action = 'all',
          complete_function_calls = true,
        }
      }

      local function typescript_keymap(user_command, lsp_command, description)
        vim.keymap.set('n', user_command, lsp_command, {desc = 'Typescript: ' .. description})
      end

      typescript_keymap('<leader>to', ':TSToolsOrganizeImports<CR>', 'Organize imports (Typescript)')
      typescript_keymap('<leader>ts', ':TSToolsSortImports<CR>', 'Sort imports (Typescript)')
      typescript_keymap('<leader>ta', ':TSToolsAddMissingImports<CR>', 'Add missing imports (Typescript)')
      typescript_keymap('<leader>tf', ':TSToolsFixAll<CR>', 'Fix all (Typescript)')
      typescript_keymap('<leader>tr', ':TSToolsRenameFile<CR>',
        'Rename current file and apply changes to connected files (Typescript)')

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
