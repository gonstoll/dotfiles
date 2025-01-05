return {
  'saghen/blink.cmp',
  version = '*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'enter',
      ['<C-y>'] = {'show', 'show_documentation', 'hide_documentation'},
      ['<C-u>'] = {'scroll_documentation_up', 'fallback'},
      ['<C-d>'] = {'scroll_documentation_down', 'fallback'},
      cmdline = {
        preset = 'enter',
        ['<Tab>'] = {'select_next', 'fallback'},
        ['<S-Tab>'] = {'select_prev', 'fallback'},
      },
    },
    appearance = {
      nerd_font_variant = 'mono',
    },
    sources = {
      default = {'lsp', 'path', 'snippets', 'buffer', 'lazydev'},
      providers = {
        path = {
          -- Disable path provider for vtsls to use the lsp provider instead
          -- See https://github.com/Saghen/blink.cmp/discussions/884#discussioncomment-11736446
          enabled = function()
            return not vim.tbl_contains({
              'typescript',
              'typescriptreact',
              'javascript',
              'javascriptreact',
            }, vim.bo.filetype)
          end,
        },
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100, -- show at a higher priority than lsp
        },
        snippets = {
          name = 'Snippets',
          module = 'blink.cmp.sources.snippets',
          min_keyword_length = 3,
          opts = {
            friendly_snippets = false,
            search_paths = {vim.fn.stdpath('config') .. '/snippets/nvim'},
            global_snippets = {'all'},
            extended_filetypes = {},
            ignored_filetypes = {},
            get_filetype = function()
              return vim.bo.filetype
            end,
          },
        },
      },
    },
    signature = {enabled = true},
    completion = {
      trigger = {
        show_on_accept_on_trigger_character = false,
      },
      list = {
        selection = function(ctx)
          return ctx.mode == 'cmdline' and 'auto_insert' or 'manual'
        end,
      },
      menu = {
        draw = {
          treesitter = {'lsp'},
          columns = {
            {'label', gap = 2}, {'kind_icon', gap = 1, 'kind'},
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
    },
  },
  opts_extend = {'sources.default'},
}
