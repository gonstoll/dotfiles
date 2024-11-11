local M = {}

---@param fontFamily 'sf' | 'jetbrains' | 'fira' | 'hack' | 'literation' | 'geist'
M.getFonts = function(fontFamily)
  local families = {
    sf = {
      family = 'SFMono Nerd Font',
      weight = 'Regular',
      italic = false,
      stretch = 'Normal',
    },
    jetbrains = {
      family = 'JetBrainsMono Nerd Font',
      weight = 'Regular',
      italic = false,
      stretch = 'Normal',
    },
    fira = {
      family = 'FiraCode Nerd Font',
      weight = 'Regular',
      italic = false,
      stretch = 'Normal',
    },
    hack = {
      family = 'Hack Nerd Font',
      weight = 400,
      italic = false,
      stretch = 'Normal',
    },
    literation = {
      family = 'LiterationMono Nerd Font',
      weight = 450,
      italic = false,
      stretch = 'Normal',
    },
    geist = {
      family = 'GeistMono Nerd Font',
      weight = 400,
      italic = false,
      stretch = 'Normal',
    },
  }

  local fonts = {}
  for family, font in pairs(families) do
    if family ~= fontFamily then
      table.insert(fonts, font)
    end
  end

  table.insert(fonts, 1, families[fontFamily])
  table.insert(fonts, {family = 'Apple Color Emoji'})
  return fonts
end

return M
