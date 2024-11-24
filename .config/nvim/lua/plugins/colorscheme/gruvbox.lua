return {
  'sainnhe/gruvbox-material',
  lazy = true,
  config = function()
    vim.g.gruvbox_material_better_performance = 1
    vim.g.gruvbox_material_foreground = 'mix'
    vim.g.gruvbox_material_background = 'hard'
    vim.g.gruvbox_material_ui_contrast = 'high' -- The contrast of line numbers, indent lines, etc.
    vim.g.gruvbox_material_float_style = 'dim'

    local configuration = vim.fn['gruvbox_material#get_configuration']()
    local palette = vim.fn['gruvbox_material#get_palette'](
      configuration.background,
      configuration.foreground,
      configuration.colors_override
    )

    local highlights_groups = {
      FoldColumn = {bg = 'none', fg = palette.grey0[1]},
      SignColumn = {bg = 'none'},
      EndOfBuffer = {bg = 'none', fg = palette.grey0[1]},
      Normal = {bg = 'none', fg = palette.fg0[1]},
      NormalFloat = {bg = 'none', fg = palette.fg0[1]},
      FloatBorder = {bg = 'none'},
      FloatTitle = {bg = 'none', fg = palette.orange[1]},
      TelescopeTitle = {bg = 'none', fg = palette.fg0[1]},
      TelescopeBorder = {bg = 'none', fg = palette.fg0[1]},
      TelescopeNormal = {fg = 'none'},
      TelescopePromptNormal = {bg = 'none', fg = palette.fg0[1]},
      TelescopeResultsNormal = {bg = 'none', fg = palette.fg0[1]},
      TelescopeResultsDiffUntracked = {bg = 'none', fg = palette.orange[1]},
      TelescopeSelection = {bg = palette.bg5[1], fg = palette.fg0[1]},
      TelescopePreviewDirectory = {fg = palette.red[1]},
      TelescopePromptCounter = {bg = 'none', fg = palette.fg0[1]},
      TelescopeMatching = {bold = false, bg = 'none', fg = palette.green[1]},
      Visual = {bg = palette.bg_visual_red[1]},
      ColorColumn = {bg = palette.bg_visual_blue[1]},
      CursorLine = {bg = palette.bg3[1], blend = 25},
      GitSignsAdd = {bg = 'none', fg = palette.green[1]},
      GitSignsChange = {bg = 'none', fg = palette.yellow[1]},
      GitSignsDelete = {bg = 'none', fg = palette.red[1]},
      DiffAdd = {bg = 'none', fg = palette.green[1]},
      DiffChange = {bg = 'none', fg = palette.yellow[1]},
      DiffDelete = {bg = 'none', fg = palette.red[1]},
      DiffText = {bg = 'none', fg = palette.blue[1]},
      LspInfoBorder = {bg = 'none', fg = palette.fg0[1]},
      MatchParen = {bg = palette.grey2[1], fg = palette.bg0[1]},
      DiagnosticSignWarn = {bg = 'none', fg = palette.yellow[1]},
      ErrorMsg = {fg = palette.red[1]},
    }

    for group, styles in pairs(highlights_groups) do
      vim.api.nvim_set_hl(0, group, styles)
    end
  end,
}
