-- Credit goes where credit is due. This is a modified version of:
-- https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html
local icons = require('utils.icons')

local modes = {
  ['n'] = '[Normal]',
  ['no'] = '[Normal]',
  ['v'] = '[Visual]',
  ['V'] = '[Visual line]',
  [''] = '[Visual block]',
  ['s'] = '[Select]',
  ['S'] = '[Select line]',
  [''] = '[Select block]',
  ['i'] = '[Insert]',
  ['ic'] = '[Insert]',
  ['R'] = '[Replace]',
  ['Rv'] = '[Visual replace]',
  ['c'] = '[Command]',
  ['cv'] = '[Vim ex]',
  ['ce'] = '[Ex]',
  ['r'] = '[Prompt]',
  ['rm'] = '[Moar]',
  ['r?'] = '[Confirm]',
  ['!'] = '[Shell]',
  ['t'] = '[Terminal]',
  ['nt'] = '[Terminal]',
}

local function mode()
  local current_mode = vim.api.nvim_get_mode().mode
  return string.format('%s', modes[current_mode])
end

local function update_mode_colors()
  local current_mode = vim.api.nvim_get_mode().mode
  local mode_color = '%#StatusLineAccent#'
  if current_mode == 'n' then
    mode_color = '%#StatusLineAccent#'
  elseif current_mode == 'i' or current_mode == 'ic' then
    mode_color = '%#StatusLineInsertAccent#'
  elseif current_mode == 'v' or current_mode == 'V' or current_mode == '' then
    mode_color = '%#StatusLineVisualAccent#'
  elseif current_mode == 'R' then
    mode_color = '%#StatusLineReplaceAccent#'
  elseif current_mode == 'c' then
    mode_color = '%#StatusLineCmdLineAccent#'
  elseif current_mode == 't' or current_mode == 'nt' then
    mode_color = '%#StatusLineTerminalAccent#'
  end
  return mode_color
end

local function filepath()
  local fpath = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.:h')
  if fpath == '' or fpath == '.' then
    return ' '
  end
  if string.find(fpath, 'oil://') then
    fpath = string.gsub(fpath, 'oil://', '')
  end
  fpath = fpath:gsub(vim.env.HOME, '~', 1)

  local is_wide = vim.api.nvim_win_get_width(0) > 80

  if not is_wide then
    fpath = vim.fn.pathshorten(fpath)
  end

  return string.format('%%<%s/', fpath)
end

local function filename()
  local fname = vim.fn.expand('%:t')
  if fname == '' then
    return ''
  end
  return fname .. ' '
end

local function lsp()
  local count = {}
  local levels = {
    errors = 'Error',
    warnings = 'Warn',
    info = 'Info',
    hints = 'Hint',
  }

  for k, level in pairs(levels) do
    count[k] = vim.tbl_count(vim.diagnostic.get(0, {severity = level}))
  end

  local errors = ''
  local warnings = ''
  local hints = ''
  local info = ''

  if count['errors'] ~= 0 then
    errors = ' %#StatusLineDiagnosticSignError#' .. icons.diagnostics.Error .. count['errors']
  end
  if count['warnings'] ~= 0 then
    warnings = ' %#StatusLineDiagnosticSignWarn#' .. icons.diagnostics.Warn .. count['warnings']
  end
  if count['hints'] ~= 0 then
    hints = ' %#StatusLineDiagnosticSignHint#' .. icons.diagnostics.Hint .. count['hints']
  end
  if count['info'] ~= 0 then
    info = ' %#StatusLineDiagnosticSignInfo#' .. icons.diagnostics.Info .. count['info']
  end

  return errors .. warnings .. hints .. info .. '%#Statusline# '
end

local vcs = function()
  local git_info = vim.b.gitsigns_status_dict
  if not git_info or git_info.head == '' then
    return ''
  end
  local added = git_info.added and ('%#StatusLineGitSignsAdd#' .. icons.git.added .. ' ' .. git_info.added .. ' ') or ''
  local changed = git_info.changed and
      ('%#StatusLineGitSignsChange#' .. icons.git.changed .. ' ' .. git_info.changed .. ' ') or ''
  local removed = git_info.removed and
      ('%#StatusLineGitSignsDelete#' .. icons.git.deleted .. ' ' .. git_info.removed .. ' ') or ''
  if git_info.added == 0 then
    added = ''
  end
  if git_info.changed == 0 then
    changed = ''
  end
  if git_info.removed == 0 then
    removed = ''
  end
  return table.concat({
    ' ',
    icons.git.branch2,
    ' ',
    git_info.head,
    '  ',
    added,
    changed,
    removed,
  })
end

local function filetype()
  return string.format(' %s ', vim.bo.filetype)
end

local function modified()
  return '%m'
end

local function lineinfo()
  if vim.bo.filetype == 'alpha' then
    return ''
  end
  return ' %P %l:%c '
end

Statusline = {}

function Statusline.active()
  return table.concat({
    -- update_mode_colors(),
    -- mode(),
    '%#Statusline# ',
    filepath(),
    filename(),
    modified(),
    vcs(),
    '%#Statusline#',
    '%=%#StatusLineExtra#',
    lsp(),
    filetype(),
    lineinfo(),
  })
end

function Statusline.inactive()
  return ' %F'
end

function Statusline.oil()
  return table.concat({
    '%#Statusline#  ',
    filepath(),
  })
end
