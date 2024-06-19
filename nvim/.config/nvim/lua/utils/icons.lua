local M = {
  diagnostics = {
    Error = ' ',
    Warn = ' ',
    Hint = ' ',
    Info = ' '
  },
  git = {
    added = '',
    changed = '',
    deleted = '',
  },
  dap = {
    Stopped = {'󰁕 ', 'DiagnosticSignWarn', 'DapStoppedLine'},
    Breakpoint = {' ', 'DiagnosticSignInfo'},
    BreakpointCondition = {' ', 'DiagnosticSignHint'},
    BreakpointRejected = {' ', 'DiagnosticSignError'},
    LogPoint = '.>',
  },
}

return M
