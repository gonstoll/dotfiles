return {
  'rmagatti/auto-session',
  cmd = {'SessionRestore', 'SessionSave'},
  opts = {
    log_level = 'error',
    auto_restore_enabled = false,
    auto_session_suppress_dirs = {'~/', '~/Dev/', '~/Downloads', '~/Documents', '~/Desktop/'},
  },
}
