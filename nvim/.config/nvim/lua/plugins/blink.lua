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
  'saghen/blink.cmp',
  version = 'v0.*', -- REQUIRED release tag to download pre-built binaries
  ---@module "blink.cmp"
  ---@type blink.cmp.Config
  opts = {
    highlight = {use_nvim_cmp_as_default = true},
    keymap = {
      show = '<C-y>',
      hide = '<C-e>',
      accept = '<CR>',
      select_prev = {'<Up>', '<C-p>'},
      select_next = {'<Down>', '<C-n>'},
      scroll_documentation_up = '<C-u>',
      scroll_documentation_down = '<C-d>',
      snippet_forward = '<Tab>',
      snippet_backward = '<S-Tab>',
    },
    windows = {
      autocomplete = {
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
}
