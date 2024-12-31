return {
  'saghen/blink.cmp',
  version = 'v0.*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'enter',
      ['<C-y>'] = {'show', 'show_documentation', 'hide_documentation'},
      -- ['<C-e>'] = {'hide', 'fallback'},
      -- ['<CR>'] = {'accept', 'fallback'},
      -- ['<Tab>'] = {'snippet_forward', 'fallback'},
      -- ['<S-Tab>'] = {'snippet_backward', 'fallback'},
      -- ['<Up>'] = {'select_prev', 'fallback'},
      -- ['<Down>'] = {'select_next', 'fallback'},
      -- ['<C-p>'] = {'select_prev', 'fallback'},
      -- ['<C-n>'] = {'select_next', 'fallback'},
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
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100, -- show at a higher priority than lsp
        },
        snippets = {
          name = 'Snippets',
          module = 'blink.cmp.sources.snippets',
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
