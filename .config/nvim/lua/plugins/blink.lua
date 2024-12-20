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
    },
    appearance = {
      use_nvim_cmp_as_default = true,
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
            get_filetype = function(context)
              return vim.bo.filetype
            end,
          },
        },
      },
      -- optionally disable cmdline completions
      -- cmdline = {},
    },
    signature = {enabled = true},
    completion = {
      trigger = {
        show_on_accept_on_trigger_character = false,
      },
      list = {
        selection = 'manual',
      },
      menu = {
        draw = {
          treesitter = {'lsp'},
          columns = {
            -- {'kind_icon'}, {'label', 'label_description', gap = 1}
            {'label', gap = 1}, {'kind_icon', gap = 1, 'kind'},
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
  config = function(_, opts)
    local enabled = opts.sources.default
    for _, source in ipairs(opts.sources.compat or {}) do
      opts.sources.providers[source] = vim.tbl_deep_extend(
        'force',
        {name = source, module = 'blink.compat.source'},
        opts.sources.providers[source] or {}
      )
      if type(enabled) == 'table' and not vim.tbl_contains(enabled, source) then
        table.insert(enabled, source)
      end
    end

    require('blink.cmp').setup(opts)
  end,
}
