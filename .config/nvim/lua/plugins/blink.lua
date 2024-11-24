---@param ctx blink.cmp.CompletionRenderContext
---@return blink.cmp.Component[]
local function draw(ctx)
  local kind = '[' .. ctx.kind .. ']'
  return {
    {' ' .. ctx.item.label .. ' ', fill = true},
    {kind .. ' '},
  }
end

return {
  {'saghen/blink.compat', opts = {impersonate_nvim_cmp = true, enable_events = true}},

  {
    'saghen/blink.cmp',
    version = 'v0.*', -- REQUIRED release tag to download pre-built binaries
    dependencies = {
      'saghen/blink.compat',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-emoji',
      'garymjr/nvim-snippets',
    },
    event = 'InsertEnter',
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      highlight = {use_nvim_cmp_as_default = true},
      nerd_font_variant = 'mono',
      sources = {
        completion = {
          enabled_providers = {'lsp', 'path', 'snippets', 'buffer', 'lazydev', 'cmdline', 'calc', 'emoji'},
        },
        providers = {
          lsp = {
            -- dont show LuaLS require statements when lazydev has items
            fallback_for = {'lazydev'},
          },
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
          },
        },
      },
      keymap = {
        ['<C-y>'] = {'show', 'show_documentation', 'hide_documentation'},
        ['<C-e>'] = {'hide', 'fallback'},
        ['<CR>'] = {'accept', 'fallback'},
        ['<Up>'] = {'select_prev', 'fallback'},
        ['<C-p>'] = {'select_prev', 'fallback'},
        ['<Down>'] = {'select_next', 'fallback'},
        ['<C-n>'] = {'select_next', 'fallback'},
        ['<C-u>'] = {'scroll_documentation_up', 'fallback'},
        ['<C-d>'] = {'scroll_documentation_down', 'fallback'},
        ['<Tab>'] = {'snippet_forward', 'fallback'},
        ['<S-Tab>'] = {'snippet_backward', 'fallback'},
      },
      windows = {
        autocomplete = {
          winblend = vim.o.pumblend,
          auto_show = false,
          selection = 'manual',
          -- draw = 'minimal',
          draw = draw,
        },
        documentation = {
          auto_show = true,
        },
      },
      kind_icons = {
        Text = '',
        Method = '󰊕',
        Function = '󰊕',
        Constructor = '',
        Field = '󰇽',
        Variable = '󰂡',
        Class = '⬟',
        Interface = '',
        Module = '',
        Property = '󰜢',
        Unit = '',
        Value = '󰎠',
        Enum = '',
        Keyword = '󰌋',
        Snippet = '󰒕',
        Color = '󰏘',
        Reference = '',
        File = '󰧮',
        Folder = '󰉋',
        EnumMember = '',
        Constant = '󰏿',
        Struct = '',
        Event = '',
        Operator = '󰆕',
        TypeParameter = '󰅲',
      },
    },
    config = function(_, opts)
      -- setup compat sources
      local enabled = opts.sources.completion.enabled_providers
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
  },
}
