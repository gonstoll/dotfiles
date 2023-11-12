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
      {'nvim-tree/nvim-web-devicons', lazy = true},
    },
    opts = {
      ui = {border = 'rounded'},
      symbol_in_winbar = {enable = false},
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

  -- Stops inactive LSP clients to free RAM
  {
    'zeioth/garbage-day.nvim',
    event = 'LspAttach',
    opts = {notifications = true},
  },

  -- VS code like winbar with breadcrumbs
  {
    'utilyre/barbecue.nvim',
    name = 'barbecue',
    event = 'BufReadPre',
    version = '*',
    dependencies = {
      'SmiteshP/nvim-navic',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      attach_navic = false,
    },
  },

  {
    'neovim/nvim-lspconfig',
    -- event = 'LspAttach',
    event = {'BufReadPost', 'BufNewFile', 'BufWritePre'},
    dependencies = {
      'folke/neodev.nvim',
      {
        'williamboman/mason.nvim',
        build = ':MasonUpdate',
      },
      'williamboman/mason-lspconfig.nvim',
      {
        'kevinhwang91/nvim-ufo',
        dependencies = {'kevinhwang91/promise-async', lazy = true},
      }
    },
    config = function()
      local mason = require('mason')

      mason.setup({
        ui = {border = 'rounded'}
      })

      local function on_attach(client, bufnr)
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
        nmap('gl', '<cmd>lua vim.diagnostic.open_float()<cr>', 'Open diagnostics')
        nmap('[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', 'Previous diagnostic')
        nmap(']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', 'Next diagnostic')
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

        if client.server_capabilities['documentSymbolProvider'] then
          require('nvim-navic').attach(client, bufnr)
        end
      end

      local mason_lspconfig = require('mason-lspconfig')
      local lspconfig = require('lspconfig')
      -- local typescript_tools = require('typescript-tools')

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
      require('lspconfig.ui.windows').default_options.border = 'rounded'

      local servers = {
        tailwindcss = {},
        cssls = {},
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
        eslint = {format = false},
        emmet_language_server = {},
        tsserver = {},
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
        tsserver = function()
          lspconfig.tsserver.setup {
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
                  preferTypeOnlyAutoImports = true,
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
              RenameFile = {
                function()
                  local source_file, target_file

                  vim.ui.input({
                      prompt = 'Source: ',
                      completion = 'file',
                      default = vim.api.nvim_buf_get_name(0)
                    },
                    function(input)
                      source_file = input
                    end
                  )

                  vim.ui.input({
                      prompt = 'Target: ',
                      completion = 'file',
                      default = source_file
                    },
                    function(input)
                      target_file = input
                    end
                  )

                  local params = {
                    command = '_typescript.applyRenameFile',
                    arguments = {
                      {
                        sourceUri = source_file,
                        targetUri = target_file,
                      },
                    },
                    title = ''
                  }

                  vim.lsp.util.rename(source_file, target_file, {})
                  vim.lsp.buf.execute_command(params)
                end
              },
            },
          }
        end
      }

      -- ########################### TYPESCRIPT ###########################
      local function typescript_keymap(user_command, lsp_command, description)
        vim.keymap.set('n', user_command, lsp_command, {desc = 'Typescript: ' .. description})
      end

      typescript_keymap('<leader>to', ':OrganizeImports<CR>', 'Organize imports')
      typescript_keymap('<leader>tr', ':RenameFile<CR>', 'Rename file')

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
