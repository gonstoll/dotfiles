return {
  'saghen/blink.cmp',
  version = '*',
  event = 'InsertEnter',
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
    sources = {
      default = {'lsp', 'path', 'snippets', 'buffer', 'lazydev'},
      providers = {
        lsp = {
          fallbacks = {'buffer', 'path'},
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
        -- Manual selection, if not in cmdline
        selection = {
          preselect = false,
          auto_insert = function(ctx) return ctx.mode == 'cmdline' end,
        },
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
    fuzzy = {
      use_typo_resistance = false,
    },
  },
  opts_extend = {'sources.default'},
}
