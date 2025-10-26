local session_dir = vim.fn.expand("~/.config/vim-sessions")
local session_file = session_dir .. "/vim-session"

vim.api.nvim_create_user_command("SessionSave", function()
    vim.fn.mkdir(session_dir, "p")
    vim.cmd("mksession! " .. vim.fn.fnameescape(session_file))
    vim.notify("Session saved", vim.log.levels.INFO)
end, {desc = "Save current session"})

vim.api.nvim_create_user_command("SessionRestore", function()
    if vim.fn.filereadable(session_file) == 1 then
        vim.cmd("source " .. vim.fn.fnameescape(session_file))
        vim.notify("Session restored", vim.log.levels.INFO)
    else
        vim.notify("No session found", vim.log.levels.WARN)
    end
end, {desc = "Restore saved session"})
