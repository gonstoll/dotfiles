return {
    'rmagatti/auto-session',
    cmd = {'SessionRestore', 'SessionSave'},
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
        enabled = false,
        auto_restore = false,
        auto_create = false,
        suppressed_dirs = {'~/', '~/Dev/', '~/Downloads', '~/Documents', '~/Desktop/'},
    },
}
