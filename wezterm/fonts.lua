local M = {}

M.getFonts = function()
  return {
    {
      family = 'SFMono Nerd Font',
      weight = 450,
      italic = false,
      stretch = 'Normal',
    },
    {
      family = 'JetBrainsMono Nerd Font',
      weight = 400,
      italic = false,
      stretch = 'Normal',
    },
    {
      family = 'FiraCode Nerd Font',
      weight = 450,
      italic = false,
      stretch = 'Normal',
    },
    {
      family = 'Hack Nerd Font',
      weight = 400,
      italic = false,
      stretch = 'Normal',
    },
    {
      family = 'LiterationMono Nerd Font',
      weight = 450,
      italic = false,
      stretch = 'Normal',
    },
    {family = 'Apple Color Emoji'},
  }
end

return M
